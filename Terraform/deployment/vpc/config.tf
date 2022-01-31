terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    # remove if using backend.hcl
    # bucket = var.bucket
    # key    = var.key
    # region = var.aws_region
  }
}
