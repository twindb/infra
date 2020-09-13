from pprint import pformat
from os import path as osp

import pytest
import requests
from terraform_ci import terraform_apply

from tests.conftest import LOG, TEST_ZONE, REGION


@pytest.mark.flaky(reruns=0, reruns_delay=30)
@pytest.mark.timeout(600)
def test_lb(ec2_client, route53_client, elbv2_client):
    terraform_dir = "test_data/test_create_lb"
    destroy_after = True

    with open(osp.join(terraform_dir, "configuration.tfvars"), "w") as fp:
        fp.write('region = "%s"' % REGION)

    with terraform_apply(
        terraform_dir, destroy_after=destroy_after, json_output=True
    ) as tf_output:
        assert len(tf_output["network_subnet_private_ids"]) == 3
        assert len(tf_output["network_subnet_public_ids"]) == 3

        response = route53_client.list_hosted_zones_by_name(DNSName=TEST_ZONE)
        assert len(response["HostedZones"]) == 1, "Zone %s is not hosted by AWS: %s" % (
            TEST_ZONE,
            response,
        )
        zone_id = response["HostedZones"][0]["Id"]

        response = route53_client.list_resource_record_sets(HostedZoneId=zone_id)
        a_records = [
            a["Name"] for a in response["ResourceRecordSets"] if a["Type"] == "A"
        ]
        for record in ["bogus-test-stuff", "www"]:
            assert "%s.%s." % (record, TEST_ZONE) in a_records, (
                "Record %s is missing in %s: %s"
                % (record, TEST_ZONE, pformat(a_records, indent=4))
            )

        response = ec2_client.describe_vpcs(
            Filters=[{"Name": "cidr", "Values": ["10.1.0.0/16"]}],
        )
        # Check VPC is created
        assert len(response["Vpcs"]) == 1, "Unexpected number of VPC: %s" % pformat(
            response, indent=4
        )

        response = elbv2_client.describe_load_balancers()
        assert (
            len(response["LoadBalancers"]) == 1
        ), "Unexpected number of Load Balancer: %s" % pformat(response, indent=4)

        assert (
            len(response["LoadBalancers"][0]["AvailabilityZones"]) == 3
        ), "Unexpected number of Availability Zones: %s" % pformat(response, indent=4)

        try:
            response = ec2_client.describe_instances(
                Filters=[{"Name": "instance-state-name", "Values": ["running"]}],
            )
            total_instances = 0
            for reservation in response["Reservations"]:
                total_instances += len(reservation["Instances"])

            assert total_instances == 3, "Unexpected number of Instances: %s" % pformat(
                response, indent=4
            )
        except AssertionError:
            LOG.warning("Test failed. Will rerun it.")
            raise

        for a_rec in ["bogus-test-stuff", "www"]:
            response = requests.get("https://%s.%s" % (a_rec, TEST_ZONE))
            assert all(
                (response.status_code == 200, response.text == "Success Message\r\n")
            ), ("Unsuccessful HTTP response: %s" % response.text)

    response = ec2_client.describe_volumes(
        Filters=[{"Name": "status", "Values": ["available"]}],
    )
    assert (
        len(response["Volumes"]) == 0
    ), "Unexpected number of EBS volumes: %s" % pformat(response, indent=4)
