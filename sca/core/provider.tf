provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws    = "~> 2.59"
    random = "~> 2.2"
  }
}
