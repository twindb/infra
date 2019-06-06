resource "null_resource" "dependency_setter" {
    depends_on = [
        "aws_nat_gateway.nat_gw"
    ]
}
