resource "cloudflare_record" "comodo_cert_root" {
    domain = "twindb.com"
    name = "8da788b18ede99b529cb38dcaf4eec59"
    type = "CNAME"
    value = "44f4f2068c609e7f3cc68c9a64d4c5b4a9ee2f8c.comodoca.com"
}

resource "cloudflare_record" "comodo_cert_console" {
    domain = "twindb.com"
    name = "8da788b18ede99b529cb38dcaf4eec59.console"
    type = "CNAME"
    value = "44f4f2068c609e7f3cc68c9a64d4c5b4a9ee2f8c.comodoca.com"
}

resource "cloudflare_record" "comodo_cert_recovery" {
    domain = "twindb.com"
    name = "8da788b18ede99b529cb38dcaf4eec59.recovery"
    type = "CNAME"
    value = "44f4f2068c609e7f3cc68c9a64d4c5b4a9ee2f8c.comodoca.com"
}

resource "cloudflare_record" "comodo_cert_www" {
    domain = "twindb.com"
    name = "8da788b18ede99b529cb38dcaf4eec59.www"
    type = "CNAME"
    value = "44f4f2068c609e7f3cc68c9a64d4c5b4a9ee2f8c.comodoca.com"
}

resource "cloudflare_record" "calendar" {
    domain = "twindb.com"
    name = "calendar"
    type = "CNAME"
    value = "ghs.googlehosted.com"
}

resource "cloudflare_record" "drive" {
    domain = "twindb.com"
    name = "drive"
    type = "CNAME"
    value = "ghs.googlehosted.com"
}

resource "cloudflare_record" "mail" {
    domain = "twindb.com"
    name = "mail"
    type = "CNAME"
    value = "ghs.googlehosted.com"
}

resource "cloudflare_record" "sites" {
    domain = "twindb.com"
    name = "sites"
    type = "CNAME"
    value = "ghs.googlehosted.com"
}

resource "cloudflare_record" "google_mail_record_1" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "MX"
    value = "alt1.aspmx.l.google.com"
    priority = 20
}

resource "cloudflare_record" "google_mail_record_2" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "MX"
    value = "alt2.aspmx.l.google.com"
    priority = 20
}

resource "cloudflare_record" "google_mail_record_3" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "MX"
    value = "aspmx2.googlemail.com"
    priority = 30
}

resource "cloudflare_record" "google_mail_record_4" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "MX"
    value = "aspmx3.googlemail.com"
    priority = 30
}

resource "cloudflare_record" "google_mail_record_5" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "MX"
    value = "aspmx.l.google.com"
    priority = 10
}

resource "cloudflare_record" "verification_record_1" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "TXT"
    value = "google-site-verification=BqWSkj_7dcdE3TMAOuyQC0e2v8LW9z3483yL4oZZSR8"
}

resource "cloudflare_record" "verification_record_2" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "TXT"
    value = "google-site-verification=l5Z3IhVRk8kWX0vLhbgsPaJnncmStkN0_Lv5m_yxRRg"
}

resource "cloudflare_record" "verification_record_3" {
    domain = "twindb.com"
    name = "twindb.com"
    type = "TXT"
    value = "v=spf1 +a +mx include:_spf.google.com include:_spf.reply.io ~all"
}

resource "cloudflare_record" "verification_record_5" {
    domain = "twindb.com"
    name = "google._domainkey"
    type = "TXT"
    value = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqbVWkpfWvLgSBDrhMFhw1XJJrJcaBUGF/U+ckN8g+S6uKCpxyWuhlqBuXUd63J1M2MhHpWd5JacpJf8q3Fi/v+YRmz8pF4+/jNyaFLqHBtjhL/9mBQVLKGkIM9jWK9g8eR5e7BX8UfVMd6s02Eue5g04OX7spaIwIRAIttN/70pEPRZpR/Iyav/magDnoF4u6Sl0G7yhnssAzxuAvl54DlLSnG6xq1xD9Wa0KQCq/XTdfwc0CPN07GUnWIpLQmn7Pbokxl1WO5CGKqawJ/iJ73pL+SnT1BVfp4vFCu/5tUM5A5y9x7aHNRtmalOdCwXEAEGLKTZtgcJasGkqGQWt7QIDAQAB"
}

