from os import path as osp
from os import environ
from pprint import pformat

import pytest
from terraform_ci import strip_backend, terraform_apply

from tests.conftest import update_source, create_tf_conf
from network_connectivity_tester.orchestrator import connectivity_tester


@pytest.mark.parametrize(
    ", ".join(
        [
            "region",
            "management_cidr_block",
            "vpc_cidr_block",
            "subnets",
            "expected_nat_gateways_count",
            "expected_subnet_all_count",
            "expected_subnet_public_count",
            "expected_subnet_private_count",
            "tf_node_dir"
        ]
    ),
    [
        # One VPC with no subnets
        (
            "us-east-1",
            "10.0.0.0/16",
            "10.0.0.0/16",
            "[]",
            0,  # expected_nat_gateways_count
            0,  # expected_subnet_all_count
            0,  # expected_subnet_public_count
            0,  # expected_subnet_private_count
            None,  # No connection testing
        ),
        # One VPC with one subnet
        (
            "us-east-1",
            "192.168.0.0/24",
            "192.168.0.0/24",
            """[
                {
                    cidr                    = "192.168.0.0/24"
                    availability-zone       = "us-east-1a"
                    map_public_ip_on_launch = true
                    create_nat              = false
                    forward_to              = null
                }
            ]
            """,
            0,  # expected_nat_gateways_count
            1,  # expected_subnet_all_count
            1,  # expected_subnet_public_count
            0,  # expected_subnet_private_count
            "test_data/test_one_vpc_1_subnet",
        ),
        # One VPC with three subnets
        (
            "us-east-1",
            "10.1.0.0/16",
            "10.1.0.0/16",
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
                    map_public_ip_on_launch = false
                    create_nat              = false
                    forward_to              = "10.1.0.0/24"
                },
                {
                    cidr                    = "10.1.2.0/24"
                    availability-zone       = "us-east-1c"
                    map_public_ip_on_launch = false
                    create_nat              = false
                    forward_to              = "10.1.0.0/24"
                }
            ]
            """,
            1,  # expected_nat_gateways_count
            3,  # expected_subnet_all_count
            1,  # expected_subnet_public_count
            2,  # expected_subnet_private_count
            "test_data/test_one_vpc_3_subnet",
        ),
    ],
)
def test_service_network(
    ec2_client_map,
    region,
    management_cidr_block,
    vpc_cidr_block,
    subnets,
    expected_nat_gateways_count,
    expected_subnet_all_count,
    expected_subnet_public_count,
    expected_subnet_private_count,
    tf_node_dir
):
    ec2_client = ec2_client_map[region]

    with strip_backend("test_data/service_network") as tf_dir:
        create_tf_conf(
            tf_dir=tf_dir,
            region=region,
            management_cidr_block=management_cidr_block,
            vpc_cidr_block=vpc_cidr_block,
            subnets=subnets,
        )
        update_source(osp.join(tf_dir, "main.tf"), osp.abspath("."))

        with terraform_apply(tf_dir, json_output=True) as tf_out:

            response = ec2_client.describe_vpcs(
                Filters=[
                    {"Name": "state", "Values": ["available"]},
                    {"Name": "cidr", "Values": [vpc_cidr_block]},
                ],
            )
            assert (
                len(response["Vpcs"]) == 1
            ), "Unexpected number of VPCs: %s" % pformat(response, indent=4)
            vpc_id = response["Vpcs"][0]["VpcId"]
            assert (
                tf_out["vpc_id"]["value"] == vpc_id
            ), "Unexpected terraform output: %s" % pformat(tf_out, indent=4)

            # Check Internet gateway is created
            response = ec2_client.describe_internet_gateways(
                Filters=[
                    {"Name": "attachment.vpc-id", "Values": [vpc_id]},
                    {"Name": "attachment.state", "Values": ["available"]},
                ],
            )
            assert len(response["InternetGateways"]) == 1

            # Check NAT gateway
            response = ec2_client.describe_nat_gateways(
                Filters=[{"Name": "state", "Values": ["available"]}],
            )
            assert len(response["NatGateways"]) == expected_nat_gateways_count

            # Check Elastic IP. Should be as many as NAT gateways
            response = ec2_client.describe_addresses(
                Filters=[{"Name": "domain", "Values": ["vpc"]}],
            )
            assert len(response["Addresses"]) == expected_nat_gateways_count

            assert len(tf_out["subnets_all"]["value"]) == expected_subnet_all_count
            assert (
                len(tf_out["subnets_public"]["value"]) == expected_subnet_public_count
            )
            assert (
                len(tf_out["subnets_private"]["value"]) == expected_subnet_private_count
            )

            if tf_node_dir:
                with connectivity_tester(region=region) as connectivity_test_object:
                    environ["TF_VAR_region"] = region
                    environ["TF_VAR_vpc_id"] = vpc_id
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
