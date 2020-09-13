resource "random_string" "random" {
  for_each = toset(
    [
      "auth_key",
      "secure_auth_key",
      "logged_in_key",
      "nonce_key",
      "auth_salt",
      "secure_auth_salt",
      "logged_in_salt",
      "nonce_salt"
    ]
  )
  special = false
  length  = 32
}
