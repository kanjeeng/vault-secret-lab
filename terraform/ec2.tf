data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  lab_ca_pem     = tls_self_signed_cert.ca.cert_pem
  vault_cert_pem = "${tls_locally_signed_cert.vault.cert_pem}${tls_self_signed_cert.ca.cert_pem}"
  vault_key_pem  = tls_private_key.vault.private_key_pem
}

# ---------------- vault-server ----------------
resource "aws_instance" "vault" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.3.1.10"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.vault.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/userdata/vault-server.sh", {
    ca_pem       = local.lab_ca_pem
    server_cert  = local.vault_cert_pem
    server_key   = local.vault_key_pem
    vault_hcl    = file("${path.module}/../vault/config/vault.hcl")
    policy_admin = file("${path.module}/../vault/policies/admin.hcl")
    policy_dbro  = file("${path.module}/../vault/policies/db-readonly.hcl")
    policy_dbrw  = file("${path.module}/../vault/policies/db-readwrite.hcl")
    policy_ssh   = file("${path.module}/../vault/policies/ssh-otp.hcl")
  })
  user_data_replace_on_change = true

  tags       = { Name = "vault-server" }
  depends_on = [aws_internet_gateway.lab]
}

resource "aws_eip" "vault" {
  domain = "vpc"
  tags   = { Name = "vault-server-eip" }
}

resource "aws_eip_association" "vault" {
  instance_id   = aws_instance.vault.id
  allocation_id = aws_eip.vault.id
}

# ---------------- db-server ----------------
resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.3.1.20"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.db.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/userdata/db-server.sh", {
    seed_sql  = file("${path.module}/../db/seed-appdb.sql")
    admin_sql = file("${path.module}/../db/vault-admin-user.sql")
  })
  user_data_replace_on_change = true

  tags       = { Name = "db-server" }
  depends_on = [aws_internet_gateway.lab]
}

# ---------------- ssh-target ----------------
resource "aws_instance" "ssh_target" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.3.1.30"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.ssh_target.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/userdata/ssh-target.sh", {
    ca_pem        = local.lab_ca_pem
    helper_config = file("${path.module}/../ssh-target/helper-config.hcl")
    pam_snippet   = file("${path.module}/../ssh-target/pam-sshd.snippet")
    sshd_snippet  = file("${path.module}/../ssh-target/sshd-config.snippet")
  })
  user_data_replace_on_change = true

  tags       = { Name = "ssh-target" }
  depends_on = [aws_internet_gateway.lab]
}

# ---------------- client-node ----------------
resource "aws_instance" "client" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.3.1.40"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.client.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "one-time"
    }
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/userdata/client-node.sh", {
    ca_pem   = local.lab_ca_pem
    demo_db  = file("${path.module}/../client/demo-db.sh")
    demo_ssh = file("${path.module}/../client/demo-ssh.sh")
  })
  user_data_replace_on_change = true

  tags       = { Name = "client-node" }
  depends_on = [aws_internet_gateway.lab]
}
