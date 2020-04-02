variable "ec2_key_name" {
  description = "AWS EC2 Key name for SSH access"
  type        = string
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "m4.xlarge"
}

variable aws_region {}
variable project {}
variable random_id {}
variable secrets_manager_name {}
variable iam_instance_profile_name {}
variable security_groups {}
variable vpcs {}
variable subnets {}
variable route_tables {}
variable transit_gateways {}
