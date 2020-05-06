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
variable "allowed_mgmt_cidr" {
  description = "CIDR of allowed IPs for the BIG-IP management interface"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  description = "CIDR of allowed IPs for the BIG-IP Virtual Servers"
  type        = string
  default     = "0.0.0.0/0"
}

variable "cidr-1" {
  description = "CIDR block for the Security VPC"
  default     = "10.100.0.0/16"
}

variable "cidr-2" {
  description = "CIDR block for the Applicaiton VPC"
  default     = "10.200.0.0/16"
}

variable "cidr-3" {
  description = "CIDR block for the Container VPC"
  default     = "10.240.0.0/16"
}


