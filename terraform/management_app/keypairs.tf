resource "aws_key_pair" "keypairs" {
    count = "${length(keys(var.keypairs))}"
    public_key = "${lookup(var.keypairs, element(keys(var.keypairs), count.index))}"
}
