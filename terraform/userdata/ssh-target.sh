#!/bin/bash
# Bootstrap ssh-target: instal vault-ssh-helper, siapkan user otpuser dan berkas snippet.
# Konfigurasi PAM dan sshd dikerjakan MANUAL.
set -eux
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y unzip curl wget ca-certificates

wget -O /tmp/vault-ssh-helper.zip https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
unzip -o /tmp/vault-ssh-helper.zip -d /usr/local/bin
chmod 755 /usr/local/bin/vault-ssh-helper

mkdir -p /etc/vault-ssh-helper.d /opt/lab/ssh-target
cat > /etc/vault-ssh-helper.d/vault-ca.crt <<'EOCA'
${ca_pem}
EOCA
cat > /opt/lab/ssh-target/helper-config.hcl <<'EOS1'
${helper_config}
EOS1
cat > /opt/lab/ssh-target/pam-sshd.snippet <<'EOS2'
${pam_snippet}
EOS2
cat > /opt/lab/ssh-target/sshd-config.snippet <<'EOS3'
${sshd_snippet}
EOS3

useradd -m -s /bin/bash otpuser
echo "otpuser:$(openssl rand -base64 24)" | chpasswd
touch /var/lib/cloud/instance/lab-bootstrap-done
