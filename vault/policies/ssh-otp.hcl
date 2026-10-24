# Hanya boleh membuat OTP untuk role otp_key_role
path "ssh/creds/otp_key_role" {
  capabilities = ["create", "update"]
}
