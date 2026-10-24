# Sertifikat TLS dibuat otomatis oleh Terraform:
# CA lab -> sertifikat server Vault dengan SAN IP 10.3.1.10 dan 127.0.0.1

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 8760

  subject {
    common_name  = "Vault Lab CA"
    organization = "vault-secret-lab"
  }

  allowed_uses = ["cert_signing", "crl_signing", "digital_signature"]
}

resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "vault" {
  private_key_pem = tls_private_key.vault.private_key_pem
  ip_addresses    = ["10.3.1.10", "127.0.0.1"]
  dns_names       = ["localhost", "vault-server"]

  subject {
    common_name  = "vault-server"
    organization = "vault-secret-lab"
  }
}

resource "tls_locally_signed_cert" "vault" {
  cert_request_pem      = tls_cert_request.vault.cert_request_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  validity_period_hours = 8760

  allowed_uses = ["key_encipherment", "digital_signature", "server_auth"]
}

# Key pair SSH untuk login ke semua instance
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "lab" {
  key_name   = "vault-lab-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/vault-lab-key.pem"
  file_permission = "0400"
}
