locals {
  userdata = format(
    "#cloud-config\n%s",
    yamlencode(
      {
        "groups" : [
          "www-data"
        ]
        "users" : [
          {
            name : "ubuntu",
            ssh_authorized_keys : [
              aws_key_pair.keypairs["deployer"].public_key
            ],
            sudo : "ALL=(ALL) NOPASSWD:ALL"
          },
          {
            name : "www-data",
            homedir : "/var/www",
            primary_group : "www-data",
            no_create_home : true,
            shell : "/usr/sbin/nologin"
          }
        ]
        "write_files" : [
          {
            content : format("[default]\nregion=%s\n", var.aws_region),
            path : "/root/.aws/config",
            permissions : "0600",
          },
          {
            content : templatefile(
              join(
                "/",
                [
                  path.module, "wp-config.php.tmpl"
                ]
              ),
              {
                db_name          = var.rds_database,
                db_user          = var.rds_username,
                db_password      = var.rds_password,
                db_host          = aws_db_instance.wordpress_db.address,
                auth_key         = random_string.random["auth_key"].result,
                secure_auth_key  = random_string.random["secure_auth_key"].result,
                logged_in_key    = random_string.random["logged_in_key"].result,
                nonce_key        = random_string.random["nonce_key"].result,
                auth_salt        = random_string.random["auth_salt"].result,
                secure_auth_salt = random_string.random["secure_auth_salt"].result,
                logged_in_salt   = random_string.random["logged_in_salt"].result,
                nonce_salt       = random_string.random["nonce_salt"].result,
              }
            ),
            path : "/var/www/html/wp-config.php",
            owner : "www-data",
            permissions : "0640",
          },
          {
            content : file(
              join("/", [path.module, "htaccess.conf"])
            ),
            path : "/etc/apache2/conf-available/htaccess.conf"

          },
          {
            content : file(
              join("/", [path.module, ".htaccess"])
            ),
            path : "/var/www/html/.htaccess"
          },
          {
            content : file(
              join("/", [path.module, "robots.txt"])
            ),
            path : "/var/www/html/robots.txt"
          }
        ]
        apt : {
        }
        package_update : true
        packages : [
          "awscli",
          "apache2",
          "git",
          "jq",
          "mysql-client",
          "nfs-common",
          "php",
          "php-curl",
          "php-gd",
          "php-imagick",
          "php-mbstring",
          "php-mysql",
          "php-xml",
          "php-zip",
          "php-tidy"
        ]
        runcmd : [
          ["wget", "-qO", "/var/run/latest.tar.gz", "https://wordpress.org/latest.tar.gz"],
          ["wget", "-qO", "/usr/local/bin/wp", "https://s3.amazonaws.com/twindb-release/wp-cli.phar"],
          ["chmod", "755", "/usr/local/bin/wp"],
          ["tar", "xf", "/var/run/latest.tar.gz", "-C", "/var/www/html/", "--strip-components=1", "wordpress"],
          ["rm", "-f", "/var/www/html/index.html"],
          ["mkdir", "-p", "/var/www/html/wp-content/uploads"],
          [
            "mount",
            "-t", "nfs4",
            "-o", "nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport",
            format("%s:/", aws_efs_file_system.uploads.dns_name),
            "/var/www/html/wp-content/uploads"
          ],
          ["chown", "-R", "www-data:www-data", "/var/www/html/"],
          ["systemctl", "restart", "apache2"],
          ["wp", "--allow-root", "--path=/var/www/html", "theme", "delete", "twentynineteen"],
          ["wp", "--allow-root", "--path=/var/www/html", "theme", "delete", "twentytwenty"],
          ["wp", "--allow-root", "--path=/var/www/html", "theme", "install", "twentytwentyone"],
          ["wp", "--allow-root", "--path=/var/www/html", "theme", "update", "twentytwentyone"],
          ["wp", "--allow-root", "--path=/var/www/html", "plugin", "delete", "hello"],
          ["wp", "--allow-root", "--path=/var/www/html", "plugin", "install", "google-captcha"],
          ["wp", "--allow-root", "--path=/var/www/html", "plugin", "install", "webp-converter-for-media"],
          ["wp", "--allow-root", "--path=/var/www/html", "plugin", "install", "w3-total-cache"],
          ["wp", "--allow-root", "--path=/var/www/html", "plugin", "update", "--all"],
          ["chown", "-R", "www-data:www-data", "/var/www/html/"],
          ["a2enmod", "rewrite"],
          ["a2enmod", "expires"],
          ["a2enmod", "ext_filter"],
          ["a2enmod", "headers"],

          ["a2enconf", "htaccess"],
          ["systemctl", "restart", "apache2"],
        ]
      }
    )
  )

}
