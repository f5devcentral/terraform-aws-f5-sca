variable "ec2_key_name" {
  description = "AWS EC2 Key name for SSH access"
  type        = string
}
variable appnodes_per_az {
    default = 3
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