provider "aws" {
  region = local.region
}

terraform {
  backend "s3" {
    bucket         = "aws-ecs-terraform-tfstate-2"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-ecs-terraform-tfstate-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

