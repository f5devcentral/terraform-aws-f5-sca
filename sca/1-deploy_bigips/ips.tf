locals {
  ips_bigip_map = {
    "0" = {
      "network_interfaces" = {
        "us-west-1a:management:0" = {
          "device_index"      = "0"
          "interface_type"    = "management"
          "private_ips_count" = 0
          "public_ip"         = true
          "subnet_id"         = var.subnets.value.az1.security.mgmt
          "subnet_security_group_ids" = [
            var.security_groups.value.management
          ]
        }
        "us-west-1a:public:0" = {
          "device_index"      = "1"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_outside
          "subnet_security_group_ids" = [
            var.security_groups.value.public
          ]
        }
        "us-west-1a:private:0" = {
          "device_index"      = "2"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.application_region
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
        "us-west-1a:private:0" = {
          "device_index"      = "3"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_inside
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
      }
    }
    "1" = {
      "network_interfaces" = {
        "us-west-1b:management:0" = {
          "device_index"      = "0"
          "interface_type"    = "management"
          "private_ips_count" = 0
          "public_ip"         = true
          "subnet_id"         = var.subnets.value.az1.security.mgmt
          "subnet_security_group_ids" = [
            var.security_groups.value.management
          ]
        }
        "us-west-1b:public:0" = {
          "device_index"      = "1"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_outside
          "subnet_security_group_ids" = [
            var.security_groups.value.public
          ]
        }
        "us-west-1b:private:0" = {
          "device_index"      = "2"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.application_region
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
        "us-west-1b:private:0" = {
          "device_index"      = "3"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_inside
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
      }
    }
  }
}

#
# Create BIG-IP
#
module ips {
  source = "github.com/f5devcentral/terraform-aws-bigip?ref=develop"

  prefix = format(
    "%s-bigip_with_new_vpc-%s",
    var.project.value,
    var.random_id.value
  )
  ec2_instance_type           = var.ec2_instance_type
  ec2_key_name                = var.ec2_key_name
  aws_secretmanager_secret_id = var.secrets_manager_name.value
  bigip_map                   = local.ips_bigip_map
  iam_instance_profile        = var.iam_instance_profile_name.value
}
