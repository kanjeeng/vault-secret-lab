provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "vault-secret-lab"
      Session = "Sesi26-Secret-Management"
    }
  }
}
