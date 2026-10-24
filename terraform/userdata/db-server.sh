#!/bin/bash
# Bootstrap db-server: instal MariaDB, buka akses jaringan, buat appdb dan akun vaultadmin.
set -eux
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y mariadb-server

cat > /etc/mysql/mariadb.conf.d/99-lab.cnf <<'EOCNF'
[mysqld]
bind-address = 0.0.0.0
skip-name-resolve
EOCNF

mkdir -p /opt/lab/db
cat > /opt/lab/db/seed-appdb.sql <<'EOSQL1'
${seed_sql}
EOSQL1
cat > /opt/lab/db/vault-admin-user.sql <<'EOSQL2'
${admin_sql}
EOSQL2

systemctl enable mariadb
systemctl restart mariadb

mariadb < /opt/lab/db/seed-appdb.sql
mariadb < /opt/lab/db/vault-admin-user.sql
touch /var/lib/cloud/instance/lab-bootstrap-done
