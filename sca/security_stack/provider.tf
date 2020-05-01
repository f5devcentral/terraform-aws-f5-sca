provider "aws" {
  region = var.aws_region.value
}

terraform {
  required_providers {
    aws = "~> 2.59"
    template = "~> 2.1"
  }
}