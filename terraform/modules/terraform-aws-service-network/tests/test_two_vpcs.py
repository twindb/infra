from pprint import pformat
from os import path as osp
from os import environ
from textwrap import dedent

import pytest
from terraform_ci import terraform_apply, strip_backend

from tests.conftest import LOG, update_source, create_tf_conf
from network_connectivity_tester.orchestrator import connectivity_tester


@pytest.mark.parametrize(
    ", ".join(
        [
            "region",
            "management_cidr_block",
            "vpc_cidr_block",
            "management_subnets",
            "service_subnets",
        ]
    ),
    [
        # One VPC with one subnet
        (
            "us-east-1",
            "10.0.0.0/16",  # mgmt
            "10.1.0.0/16",  # service vpc
            dedent(
                """[
                    {
                      cidr                    = "10.0.0.0/24"
                      availability-zone       = "us-east-1a"
                      map_public_ip_on_launch = true
                      create_nat              = true
                      forward_to              = null
                    }
                ]
                """
            ),
            dedent(
                """[
                    {
                      cidr                    = "10.1.0.0/24"
                      availability-zone       = "us-east-1a"
                      map_public_ip_on_launch = true
                      create_nat              = true
                      forward_to              = null
                    },
                    {
                      cidr                    = "10.1.1.0/24"
                      availability-zone       = "us-east-1b"
                      map_public_ip_on_launch = true
                      create_nat              = true
                      forward_to              = null
                    },
                    {
                      cidr                    = "10.1.2.0/24"
                      availability-zone       = "us-east-1a"
                      map_public_ip_on_launch = false
                      create_nat              = false
                      forward_to              = "10.1.0.0/24"
                    },
                    {
                      cidr                    = "10.1.3.0/24"
                      availability-zone       = "us-east-1b"
                      map_public_ip_on_launch = false
                      create_nat              = false
                      forward_to              = "10.1.1.0/24"
                    }
                ]
                """
            ),
        ),
    ],
)
def test_vpc(
    ec2_client_map,
    region,
    management_cidr_block,
    vpc_cidr_block,
    management_subnets,
    service_subnets,
):

    ec2_client = ec2_client_map[region]

    with strip_backend("test_data/service_network") as tf_management_dir, strip_backend("test_data/service_network") as tf_service_dir:
        create_tf_conf(
            tf_dir=tf_management_dir,
            region=region,
            management_cidr_block=management_cidr_block,
            vpc_cidr_block=management_cidr_block,
            subnets=management_subnets,
        )
        update_source(osp.join(tf_management_dir, "main.tf"), osp.abspath("."))

        with terraform_apply(tf_management_dir, json_output=True) as tf_out:

            management_vpc_id = tf_out["vpc_id"]["value"]

            # with strip_backend("test_data/service_network") as tf_service_dir:
            create_tf_conf(
                tf_dir=tf_service_dir,
                region=region,
                management_cidr_block=management_cidr_block,
                vpc_cidr_block=vpc_cidr_block,
                subnets=service_subnets,
            )
            update_source(osp.join(tf_service_dir, "main.tf"), osp.abspath("."))

            with terraform_apply(tf_service_dir):
                vpc_ids = {}
                # VPCs are created
                for cidr in [management_cidr_block, vpc_cidr_block]:
                    response = ec2_client.describe_vpcs(
                        Filters=[
                            {"Name": "state", "Values": ["available",]},
                            {"Name": "cidr", "Values": [cidr,]},
                        ],
                    )
                    vpc_ids[cidr] = response["Vpcs"][0]["VpcId"]
                    assert (
                        len(response["Vpcs"]) == 1
                    ), "Unexpected number of VPCs: %s" % pformat(response, indent=4)

                # Check peering connection
                response = ec2_client.describe_vpc_peering_connections(
                    Filters=[
                        {"Name": "status-code", "Values": ["active",]},
                        {
                            "Name": "accepter-vpc-info.vpc-id",
                            "Values": [management_vpc_id,],
                        },
                    ],
                )
                assert len(response["VpcPeeringConnections"]) == 1, (
                    "Unexpected number of peering connections: %s"
                    % pformat(response, indent=4)
                )

                tf_node_dir = "test_data/test_two_vpc"

                with connectivity_tester(region=region) as connectivity_test_object:
                    environ["TF_VAR_region"] = region
                    environ["TF_VAR_mgmt_vpc_id"] = vpc_ids[management_cidr_block]
                    environ["TF_VAR_vpc_id"] = vpc_ids[vpc_cidr_block]
                    environ["TF_VAR_registration_queue"] = connectivity_test_object.queue_name

                    with terraform_apply(tf_node_dir, json_output=True) as tf_node_out:
                        # test connections
                        instances = tf_node_out["nodes"]["value"]
                        assert connectivity_test_object.wait_for_registrations(instances=instances)

                        # for instance in instances:
                        test_url = "https://www.google.com/"
                        for instance in instances:
                            assert connectivity_test_object.test_url(
                                instance=instance, url=test_url
                            ), "Unable to connect to %s" % pformat(test_url, indent=4)

                        for instance in instances:
                            for destination in instances:
                                assert connectivity_test_object.test_ping_internal(
                                    source=instance, destination=destination
                                ), "Unable to PING %s from %s" % (destination, instance)
