
sg_recovery_name = "recovery_sg"
web_app_sg_name = "web_app_sg"

vpc_default_tag = {
  Name = "VPC for default"
}

default_private_subnet_tag = {
  Name = "Default private"
}

default_public_subnet_tag = {
  Name = "Default public"
}

default_private_rt_tag = {
  Name = "Default VPC private"
}

default_rt_table_tag =  {
  Name = "Main routing table for VPC default"
}
###

recovery_vpc_tag_prod = {
  Name = "VPC for recovery production"
}

recovery_public_subnet_tag_prod = {
  Name = "Production recovery public subnet"
}

recovery_private_subnet_tag_prod = {
  Name = "Production recovery private subnet"
}

recovery_default_rt_prod = {
  Name = "Production default recovery route table"
}

recovery_private_rt_prod = {
  Name = "Production private recovery route table"
}
###

recover_vpc_tag_stage = {
  Name = "VPC for recovery staging"
}

recovery_public_subnet_tag_stage = {
  Name = "Staging recovery public subnet"
}

recovery_private_subnet_tag_stage = {
  Name = "Staging recovery private subnet"
}

recovery_default_rt_stage = {
  Name = "Staging default recovery route table"
}

recovery_private_rt_stage = {
  Name = "Staging private recovery route table"
}

###

web_vpc_tag_prod = {
  Name = "VPC for recovery production"
}

web_public_subnet_tag_prod = {
  Name = "Production web public subnet"
}

web_private_subnet_tag_prod = {
  Name = "Production web private subnet"
}

web_default_rt_prod = {
  Name = "Production default web route table"
}

web_private_rt_prod = {
  Name = "Production private web route table"
}

###
vpc_cidr_list = [
    "10.0.0.0/16",
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.3.0.0/16",
    "10.5.0.0/16",
    "10.8.0.0/16"
]

vpc_tags = {
  "10.0.0.0/16" = "VPC for default",
  "10.1.0.0/16" = "Production recovery VPC",
  "10.2.0.0/16" = "Production web VPC",
  "10.3.0.0/16" = "Testing VPC",
  "10.5.0.0/16" = "Staging web VPC",
  "10.8.0.0/16" = "Staging recovery VPC"
}

vpc_web_subnet_cidr_blocks = ["10.2.1.0/24", "10.2.0.0/24"]
vpc_recovery_subnets_cidr_blocks = ["10.1.1.0/24", "10.1.0.0/24"]
vpc_default_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]


vpc_recovery_subnets_cidr_blocks_staging = ["10.8.1.0/24", "10.8.2.0/24"]

website_uploads_s3_tags = {
  Name = "Twindb website uploads"
}

website_database_s3_uploads_tags = {
  Name = "Twindb website database"
}

jumphost_instance_tag = {
  Name = "jumphost"
}

jumphost_bucket_tag = {
  Name = "jumphost"
}

main_aws_key_pair_name = "deployer"

main_aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk//OJyy+2d6KfdQzCcAu5UYL55RjPdA1e/rvqpirxZqdObwpVe7owu9XvlQMtLtgcaidvTMyaOB+7zSPW9xt8Dn7FX5Sc+pRbIrp4NJ/X1IyLeagy+mPfR8gzgiEXjt9b5JI6J5NkALfBQciW+aCUixemYiZDyZzyLDNjZmamgcsElB+3eQSvFQ3trEumxYq1Bm3IxIu/b/hVcE65iSOu8tzScqbxCVDEvtz6xqWKLNOiHahHuQR30ur/6k889G7jngBaVHU8bL637lfCUN0C7NsNhuX0chYZtBCLh2xb1nSVehum98bIiChBUUzPMtACBvCcmHRlUjV4iNZmP2WH"

secondary_aws_key_pair_name = "travis_ci"

secondary_aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEKUN3zz7Jqs4js1MW7Pf88Dd7HCNNCLFBV4ZlKg79bwcdLT9/KjBmpr+AOO3PMSu6JOnUCpcgK/CZ15tnqgdjl72+7bwp5HD+tIS5nZj7EPFukGNVJsWz4gkChUfW3VohJmuywXjGhHCjEnPudBvHbVNL2ATkBrc1I4glpXtF6wgGbh8/U0Ve0+vdfshtKO2NBPK00n/ss/BJQNFHR7USSEVEiz6q45sfULYVofzLktujPG3BdeVA+ik7OmwlKgSYEHPYaufTBa1BQ8zWqbKOedeOvuIpS2RCOmZwfMmRvC9p7vwu8M/C7C0HbK4Ss7baeoHm74YhswKTYjq5V0WfFqTwYfP0o1YESo+NokSSQkJMIYoUf7Cg5RjdOZkR6lCKalpvPx/ejvWKs0gyFkDv4I8VylbDg8Fg+02jY7tlXxj7tb21ro1lRMMudhpTzxIG9yPkZOd+89RGLQxYhhOT2v3QjsC0nZpan7f5YjW/Bfba+RtsqHIOVRbHa3OU39wAom49lFjM+G81etJBd1HiQpYrKSEOFIeFBdATLPoUidoidUzWT1GVrS4+14S8ibYGbLDzFU+WyKm/q8XH2bJopUH7XpmtqJhcLVtx3aTSKlZAMBXjjHMjw9lL9mbx2JZQRFGkIqcRbp1MHXuFZtvX7k2Tx9wMJ71Lexursvvklw== root@49c5cfb48426"
