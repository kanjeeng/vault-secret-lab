# ---------- sg-client ----------
resource "aws_security_group" "client" {
  name        = "client-node-sg"
  description = "client-node: SSH hanya dari admin"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-client" }
}

# ---------- sg-vault ----------
resource "aws_security_group" "vault" {
  name        = "vault-server-sg"
  description = "vault-server: API 8200 hanya dari subnet VPC"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "Vault API dari subnet VPC"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [var.subnet_cidr]
  }

  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-vault" }
}

# ---------- sg-db ----------
resource "aws_security_group" "db" {
  name        = "db-server-sg"
  description = "db-server: MariaDB hanya dari Vault dan client"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description     = "MariaDB dari sg-vault dan sg-client"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vault.id, aws_security_group.client.id]
  }

  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-db" }
}

# ---------- sg-ssh-target ----------
resource "aws_security_group" "ssh_target" {
  name        = "ssh-target-sg"
  description = "ssh-target: SSH dari client dan admin"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description     = "SSH dari sg-client"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-ssh-target" }
}
