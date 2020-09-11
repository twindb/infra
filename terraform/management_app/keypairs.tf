resource "aws_key_pair" "keypairs" {
    for_each = var.keypairs
    public_key = each.value
    key_name = each.key
}
