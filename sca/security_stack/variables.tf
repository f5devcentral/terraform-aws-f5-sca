variable "ec2_key_name" {
  description = "AWS EC2 Key name for SSH access"
  type        = string
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "m4.xlarge"
}

variable "atc_versions" {
  description = "F5 Automation Toolchain Version used in this project"
  type        = map(string)
  default = {
    doVersion   = "1.12.0"
    as3Version  = "3.20.0"
    tsVersion   = "1.11.0"
    cfVersion   = "1.3.0"
    fastVersion = "0.2.0"
  }
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
variable aws_cidr_ips {}
variable subnet_cidrs {}
