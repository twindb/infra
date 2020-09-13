from pprint import pformat

import boto3
import pytest
import logging

from terraform_ci import setup_environment, setup_logging

# "114198773012" is our test account
# https://114198773012.signin.aws.amazon.com/console
TEST_ACCOUNT = "114198773012"
LOG = logging.getLogger(__name__)
REGION = "us-east-2"
TEST_ZONE = "revdb.dev"

setup_environment()
setup_logging(LOG, debug=True)

# make sure tests run under our test account
assert boto3.client("sts").get_caller_identity().get("Account") == TEST_ACCOUNT


@pytest.fixture()
def ec2_client():
    return boto3.client("ec2", region_name=REGION)


@pytest.fixture()
def route53_client():
    return boto3.client("route53", region_name=REGION)


@pytest.fixture()
def elbv2_client():
    return boto3.client("elbv2", region_name=REGION)
