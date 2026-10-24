#!/bin/bash
# Bootstrap client-node: Vault CLI, MariaDB client, sshpass, jq.
set -eux
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y gpg curl wget jq lsb-release ca-certificates mariadb-client sshpass

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt-get install -y vault
systemctl disable --now vault || true

cat > /usr/local/share/ca-certificates/vault-lab-ca.crt <<'EOCA'
${ca_pem}
EOCA
update-ca-certificates

cat > /etc/profile.d/vault.sh <<'EOPROF'
export VAULT_ADDR=https://10.3.1.10:8200
EOPROF

mkdir -p /opt/lab/client
cat > /opt/lab/client/demo-db.sh <<'EOD1'
${demo_db}
EOD1
cat > /opt/lab/client/demo-ssh.sh <<'EOD2'
${demo_ssh}
EOD2
chmod +x /opt/lab/client/*.sh
touch /var/lib/cloud/instance/lab-bootstrap-done
