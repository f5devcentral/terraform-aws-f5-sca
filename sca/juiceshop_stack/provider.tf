provider "aws" {
  region = var.aws_region.value # this value is expected from the core output
}

terraform {
  required_providers {
    aws = "~> 2.59"
  }
}