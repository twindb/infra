data "template_cloudinit_config" "webserver_init" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.userdata
  }
}
