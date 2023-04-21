terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }

#  backend "s3" {
#    bucket  = "tfstate-remote-s3"
#    key     = "eks-terraform-test.tfstate"
#    region  = "us-east-1"
#    encrypt = "true"
#    dynamodb_table = "tfstate-lock-dynamodb"
#  }

}

# Configuring the AWS Provider
provider "aws" {
  region = var.aws_region
}

