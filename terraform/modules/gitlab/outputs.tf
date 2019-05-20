output "public_gitlab_ip" {
  value = "${aws_eip.gitlab_eip.public_ip}"
}
