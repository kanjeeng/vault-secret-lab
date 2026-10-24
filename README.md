# vault-secret-lab

Praktikum Secret Management (Sesi 26) dengan HashiCorp Vault di AWS:

- Jalur A: Database Secrets Engine (MariaDB)
- Jalur B: SSH Secrets Engine (One-Time Password)

Infrastruktur (VPC, Security Group, 4 EC2 Spot, TLS, instalasi paket) dibuat
Terraform. Seluruh konfigurasi Vault dikerjakan manual mengikuti BAB II.

## Struktur

| Path | Isi |
|------|-----|
| terraform/ | IaC AWS + skrip user data per node |
| vault/ | vault.hcl dan policy HCL |
| db/ | SQL appdb dan akun vaultadmin |
| ssh-target/ | Snippet PAM, sshd, dan config vault-ssh-helper |
| client/ | Skrip demo opsional dari client-node |

## Menjalankan

    cd terraform
    cp terraform.tfvars.example terraform.tfvars    # isi admin_cidr
    terraform init
    terraform apply

Hapus seluruh lab setelah selesai:

    terraform destroy

Node: vault-server 10.3.1.10, db-server 10.3.1.20, ssh-target 10.3.1.30, client-node 10.3.1.40.
Password lab akun vaultadmin ada di db/vault-admin-user.sql (hanya untuk lab).
