management_cidr_block = "10.0.0.0/16"
vpc_cidr_list = [
    "10.0.0.0/16",
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.3.0.0/16",
    "10.5.0.0/16",
    "10.8.0.0/16"
]

//vpc_web_subnet_cidr_blocks = ["10.2.1.0/24", "10.2.0.0/24"]
//vpc_recovery_subnets_cidr_blocks = ["10.1.1.0/24", "10.1.0.0/24"]
//vpc_default_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
//vpc_recovery_subnets_cidr_blocks_staging = ["10.8.1.0/24", "10.8.2.0/24"]

main_aws_key_pair_name = "deployer"

main_aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk//OJyy+2d6KfdQzCcAu5UYL55RjPdA1e/rvqpirxZqdObwpVe7owu9XvlQMtLtgcaidvTMyaOB+7zSPW9xt8Dn7FX5Sc+pRbIrp4NJ/X1IyLeagy+mPfR8gzgiEXjt9b5JI6J5NkALfBQciW+aCUixemYiZDyZzyLDNjZmamgcsElB+3eQSvFQ3trEumxYq1Bm3IxIu/b/hVcE65iSOu8tzScqbxCVDEvtz6xqWKLNOiHahHuQR30ur/6k889G7jngBaVHU8bL637lfCUN0C7NsNhuX0chYZtBCLh2xb1nSVehum98bIiChBUUzPMtACBvCcmHRlUjV4iNZmP2WH"

secondary_aws_key_pair_name = "travis_ci"

secondary_aws_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEKUN3zz7Jqs4js1MW7Pf88Dd7HCNNCLFBV4ZlKg79bwcdLT9/KjBmpr+AOO3PMSu6JOnUCpcgK/CZ15tnqgdjl72+7bwp5HD+tIS5nZj7EPFukGNVJsWz4gkChUfW3VohJmuywXjGhHCjEnPudBvHbVNL2ATkBrc1I4glpXtF6wgGbh8/U0Ve0+vdfshtKO2NBPK00n/ss/BJQNFHR7USSEVEiz6q45sfULYVofzLktujPG3BdeVA+ik7OmwlKgSYEHPYaufTBa1BQ8zWqbKOedeOvuIpS2RCOmZwfMmRvC9p7vwu8M/C7C0HbK4Ss7baeoHm74YhswKTYjq5V0WfFqTwYfP0o1YESo+NokSSQkJMIYoUf7Cg5RjdOZkR6lCKalpvPx/ejvWKs0gyFkDv4I8VylbDg8Fg+02jY7tlXxj7tb21ro1lRMMudhpTzxIG9yPkZOd+89RGLQxYhhOT2v3QjsC0nZpan7f5YjW/Bfba+RtsqHIOVRbHa3OU39wAom49lFjM+G81etJBd1HiQpYrKSEOFIeFBdATLPoUidoidUzWT1GVrS4+14S8ibYGbLDzFU+WyKm/q8XH2bJopUH7XpmtqJhcLVtx3aTSKlZAMBXjjHMjw9lL9mbx2JZQRFGkIqcRbp1MHXuFZtvX7k2Tx9wMJ71Lexursvvklw== root@49c5cfb48426"
