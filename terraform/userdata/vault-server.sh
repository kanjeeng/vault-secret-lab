#!/bin/bash
# Bootstrap vault-server: instal Vault, pasang sertifikat TLS, jalankan service.
# Inisialisasi, unseal, audit, policy, dan secrets engine dikerjakan MANUAL.
set -eux
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y gpg curl wget jq lsb-release ca-certificates

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt-get install -y vault

mkdir -p /opt/vault/tls /opt/vault/data /var/log/vault /opt/lab/vault/policies

cat > /opt/vault/tls/tls.crt <<'EOCRT'
${server_cert}
EOCRT
cat > /opt/vault/tls/tls.key <<'EOKEY'
${server_key}
EOKEY
cat > /usr/local/share/ca-certificates/vault-lab-ca.crt <<'EOCA'
${ca_pem}
EOCA
update-ca-certificates

cat > /etc/vault.d/vault.hcl <<'EOHCL'
${vault_hcl}
EOHCL

cat > /opt/lab/vault/policies/admin.hcl <<'EOP1'
${policy_admin}
EOP1
cat > /opt/lab/vault/policies/db-readonly.hcl <<'EOP2'
${policy_dbro}
EOP2
cat > /opt/lab/vault/policies/db-readwrite.hcl <<'EOP3'
${policy_dbrw}
EOP3
cat > /opt/lab/vault/policies/ssh-otp.hcl <<'EOP4'
${policy_ssh}
EOP4

cat > /etc/profile.d/vault.sh <<'EOPROF'
export VAULT_ADDR=https://10.3.1.10:8200
EOPROF

chown -R vault:vault /opt/vault /var/log/vault /etc/vault.d
chmod 600 /opt/vault/tls/tls.key
chmod 644 /opt/vault/tls/tls.crt
chmod 755 /opt/vault/tls

systemctl enable --now vault
touch /var/lib/cloud/instance/lab-bootstrap-done
