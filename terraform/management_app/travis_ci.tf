module "testing_network" {
    source = "../modules/service_network_3"
    environment = "development"
    service_name = "travis_ci"
    vpc_cidr_block = "10.3.0.0/16"
    public_subnet_cidr = "10.3.0.0/24"
    private_subnet_cidr = "10.3.1.0/24"
    create_nat = 0
    management_cidr_block = "${var.management_cidr_block}"
}

resource "aws_iam_user" "chef_kitchen" {
    name = "chef-kitchen"
}

resource "aws_iam_access_key" "chef_kitchen_key" {
    user = "${aws_iam_user.chef_kitchen.name}"
}

resource "aws_iam_user_policy" "chef_kitchen_policy" {
    user = "${aws_iam_user.chef_kitchen.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:GetConsole*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances", "ec2:DescribeImages",
                "ec2:DescribeKeyPairs", "ec2:DescribeSecurityGroups",
                "ec2:DescribeAvailabilityZones",
                "ec2:RunInstances", "ec2:TerminateInstances",
                "ec2:StopInstances", "ec2:StartInstances",
                "ec2:CreateTags", "ec2:DescribeTags", "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:subnet/${module.testing_network.public_subnet_id}",
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*::image/ami-*",
                "arn:aws:ec2:*:*:key-pair/*",
                "arn:aws:ec2:*:*:security-group/*"
            ]
        }
    ]
}
EOF
}


# User for CI of twindb-backup tool
resource "aws_iam_user" "twindb_backup_ci" {
    name = "twindb-backup"
}

resource "aws_iam_access_key" "twindb_backup_ci_key" {
    user = "${aws_iam_user.twindb_backup_ci.name}"
}

resource "aws_iam_user_policy" "twindb_backup_ci" {
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
    user = "${aws_iam_user.twindb_backup_ci.name}"
}
