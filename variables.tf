variable "aws_region" {
  description = "AWS Region to deploy SCA in"
  type        = string
}

variable "project" {
  description = "Project name for the SCA deployment"
  type        = string
}

variable "region-az-1" {
  description = "AWS Region availability zone to deploy 1 of the 2 SCA stacks"
  type        = string
}

variable "region-az-2" {
  description = "AWS Region availability zone to deploy 1 of the 2 SCA stacks"
  type        = string
}
