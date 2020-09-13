locals {
  userdata = format(
    "#cloud-config\n%s",
    yamlencode(
      {
        packages : [
          "xinetd"
        ]
        write_files : [
          {
            path : "/etc/xinetd.d/http"
            permissions : "0600"
            content : file("${path.module}/xinetd.d.http")
          },
          {
            path : "/usr/local/bin/httpd"
            permissions : "0755"
            content : file("${path.module}/httpd.sh")
          }
        ]
        runcmd : [
          "systemctl start xinetd"
        ]
      }
    )
  )
}
