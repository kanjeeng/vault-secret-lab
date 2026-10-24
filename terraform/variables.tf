variable "aws_region" {
  description = "Region AWS untuk lab"
  type        = string
  default     = "ap-southeast-1"
}

variable "admin_cidr" {
  description = "IP publik operator dalam format CIDR, contoh 203.0.113.10/32"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.3.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.3.1.0/24"
}
