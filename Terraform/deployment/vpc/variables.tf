variable "aws_region" {
  default = "us-east-1"
}

variable "bucket" {
  type        = string
}
variable "key" {
  type        = string
}

variable "region" {
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "access_ip" {
  type = string
}

# DB variables--------------

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}