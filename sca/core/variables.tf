variable "aws_region" {
  description = "AWS Region to deploy SCA in"
  type        = string
}

variable "project" {
  description = "Project name for the SCA deployment"
  type        = string
}

variable "vpcs" {
  description = "map of VPCs to create"
  type = map(object({
    cidr_block             = string
    num_availability_zones = number
  }))
  default = {
    "security" : {
      cidr_block : "10.100.0.0/16"
      num_availability_zones : 2
    }
    "application" : {
      cidr_block : "10.200.0.0/16"
      num_availability_zones : 2
    }
    "container" : {
      cidr_block : "10.240.0.0/16"
      num_availability_zones : 2
    }
  }
}

variable "subnets" {
  description = "map of subnets to create for each VPC"
  type = map(object({
    vpc                     = string
    netnum                  = number
    map_public_ip_on_launch = string
  }))
  default = {
    "internet" : {
      vpc : "security"
      netnum : 0
      map_public_ip_on_launch : true
    }
    "mgmt" : {
      vpc : "security"
      netnum : 2
      map_public_ip_on_launch : false
    }
    "dmz_outside" : {
      vpc : "security"
      netnum : 4
      map_public_ip_on_launch : false
    }
  }
}

variable "tags" {
  description = "map of tags to include in resource creation"
  type        = map(string)
  default     = {}
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
