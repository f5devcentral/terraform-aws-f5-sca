locals {
  external_bigip_map = {
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
          "interface_type"    = "public"
          "private_ips_count" = 0
          "public_ip"         = true
          "subnet_id"         = var.subnets.value.az1.security.internet
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
        "us-west-1a:private:1" = {
          "device_index"      = "3"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_outside
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
          "subnet_id"         = var.subnets.value.az2.security.mgmt
          "subnet_security_group_ids" = [
            var.security_groups.value.management
          ]
        }
        "us-west-1b:public:0" = {
          "device_index"      = "1"
          "interface_type"    = "public"
          "private_ips_count" = 0
          "public_ip"         = true
          "subnet_id"         = var.subnets.value.az2.security.internet
          "subnet_security_group_ids" = [
            var.security_groups.value.public
          ]
        }
        "us-west-1b:private:0" = {
          "device_index"      = "2"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az2.security.application_region
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
        "us-west-1b:private:1" = {
          "device_index"      = "3"
          "interface_type"    = "private"
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az2.security.dmz_outside
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
      }
    }
  }
}
# Setup Onboarding scripts
data "template_file" "external_onboard" {
  template = "${file("${path.root}/templates/bigip_onboard.tmpl")}"

  vars = {
    #uname        	      = var.adminAccountName
    # atc versions
    #example version:
    #as3Version            = "3.16.0"
    doVersion   = var.atc_versions.doVersion
    as3Version  = var.atc_versions.as3Version
    tsVersion   = var.atc_versions.tsVersion
    cfVersion   = var.atc_versions.cfVersion
    fastVersion = var.atc_versions.fastVersion
    onboard_log = "/var/log/startup-script.log"
    secret_id   = var.secrets_manager_name.value
  }
}
#
# Create BIG-IP
#
module external {
  source = "github.com/f5devcentral/terraform-aws-bigip?ref=develop"

  prefix = format(
    "%s-bigip_with_new_vpc-%s",
    var.project.value,
    var.random_id.value
  )
  ec2_instance_type           = var.ec2_instance_type
  ec2_key_name                = var.ec2_key_name
  aws_secretmanager_secret_id = var.secrets_manager_name.value
  bigip_map                   = local.external_bigip_map
  iam_instance_profile        = var.iam_instance_profile_name.value
  custom_user_data            = data.template_file.external_onboard.rendered
}
