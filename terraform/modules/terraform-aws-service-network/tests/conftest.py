import logging
from os import path as osp
from pprint import pformat

import boto3
import pytest
from textwrap import dedent

from terraform_ci import setup_environment, setup_logging

# "114198773012" is our test account
TEST_ACCOUNT = "114198773012"

# setup terraform environment
setup_environment()

LOG = logging.getLogger(__name__)
setup_logging(LOG, debug=True)

# make sure tests run under our test account
assert boto3.client("sts").get_caller_identity().get("Account") == TEST_ACCOUNT


@pytest.fixture(scope="session")
def ec2_client():
    return boto3.client("ec2", region_name="us-east-2")


@pytest.fixture(scope="session")
def ec2_client_map():
    regions = [
        reg["RegionName"]
        for reg in boto3.client("ec2", region_name="us-east-1").describe_regions()[
            "Regions"
        ]
    ]
    ec2_map = {reg: boto3.client("ec2", region_name=reg) for reg in regions}

    return ec2_map


def update_source(path, module_path):
    lines = open(path).readlines()
    with open(path, "w") as fp:
        for line in lines:
            line = line.replace("%SOURCE%", module_path)
            fp.write(line)


def create_tf_conf(tf_dir, region, management_cidr_block, vpc_cidr_block, subnets):
    with open(osp.join(tf_dir, "configuration.tfvars"), "w") as fd:
        fd.write(
            dedent(
                """
                region = "{region}"
                management_cidr_block = "{management_cidr_block}"
                vpc_cidr_block = "{vpc_cidr_block}"
                subnets = {subnets}
                """.format(
                    region=region,
                    management_cidr_block=management_cidr_block,
                    vpc_cidr_block=vpc_cidr_block,
                    subnets=subnets,
                )
            )
        )
    LOG.info(
        "Terraform configuration: %s",
        open(osp.join(tf_dir, "configuration.tfvars")).read(),
    )
