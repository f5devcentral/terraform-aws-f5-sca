locals {
  external_bigip_map_az1 = {
    "0" = {
      "network_interfaces" = {
        "us-west-1a:management:0" = {
          "device_index"      = "0"
          "interface_type"    = "management"
          "cloudfailover_tag" = ""
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
          "cloudfailover_tag" = format( "%s-internal-%s", var.project.value, var.random_id.value )
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
          "cloudfailover_tag" = ""
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
          "cloudfailover_tag" = ""
          "private_ips_count" = 0
          "public_ip"         = false
          "subnet_id"         = var.subnets.value.az1.security.dmz_outside
          "subnet_security_group_ids" = [
            var.security_groups.value.private
          ]
        }
      }
    }
  }
}
locals {
    external_bigip_map_az2 = {
    "0" = {
      "network_interfaces" = {
        "us-west-1b:management:0" = {
          "device_index"      = "0"
          "interface_type"    = "management"
          "cloudfailover_tag" = ""
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
          "cloudfailover_tag" = format( "%s-internal-%s", var.project.value, var.random_id.value )
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
          "cloudfailover_tag" = ""
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
          "cloudfailover_tag" = ""
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
data "template_file" "external_onboard_az1" {
  template = "${file("${path.root}/templates/bigip_onboard.tmpl")}"

  vars = {
    doVersion   = var.atc_versions.doVersion
    as3Version  = var.atc_versions.as3Version
    tsVersion   = var.atc_versions.tsVersion
    cfVersion   = var.atc_versions.cfVersion
    fastVersion = var.atc_versions.fastVersion
    onboard_log = "/var/log/startup-script.log"
    secret_id   = var.secrets_manager_name.value
    # gateways
    applicationGateway =  var.aws_cidr_ips.value.az1.security.application_region
    dmzOutsideGateway  =  var.aws_cidr_ips.value.az1.security.dmz_outside
    externalGateway    =  var.aws_cidr_ips.value.az1.security.internet
    # networks
    applicationNetwork =  var.subnet_cidrs.value.az1.security.application_region
    dmzOutsideNetwork  =  var.subnet_cidrs.value.az1.security.dmz_outside
    externalNetwork    =  var.subnet_cidrs.value.az1.security.internet
    # sync must be other az
    syncNetwork        = var.subnet_cidrs.value.az2.security.application_region
  }
}
data "template_file" "external_onboard_az2" {
  template = "${file("${path.root}/templates/bigip_onboard.tmpl")}"

  vars = {
    doVersion   = var.atc_versions.doVersion
    as3Version  = var.atc_versions.as3Version
    tsVersion   = var.atc_versions.tsVersion
    cfVersion   = var.atc_versions.cfVersion
    fastVersion = var.atc_versions.fastVersion
    onboard_log = "/var/log/startup-script.log"
    secret_id   = var.secrets_manager_name.value
    # gateways
    applicationGateway =  var.aws_cidr_ips.value.az2.security.application_region
    dmzOutsideGateway  =  var.aws_cidr_ips.value.az2.security.dmz_outside
    externalGateway    =  var.aws_cidr_ips.value.az2.security.internet
    # networks
    applicationNetwork =  var.subnet_cidrs.value.az2.security.application_region
    dmzOutsideNetwork  =  var.subnet_cidrs.value.az2.security.dmz_outside
    externalNetwork    =  var.subnet_cidrs.value.az2.security.internet
    # sync must be other az
    syncNetwork        = var.subnet_cidrs.value.az1.security.application_region
  }
}
#
# Create BIG-IP
#
module external_az1 {
  source = "github.com/f5devcentral/terraform-aws-bigip?ref=develop"

  prefix = format(
    "%s-bigip_with_new_vpc_external-%s",
    var.project.value,
    var.random_id.value
  )
  ec2_instance_type           = var.ec2_instance_type
  ec2_key_name                = var.ec2_key_name
  aws_secretmanager_secret_id = var.secrets_manager_name.value
  bigip_map                   = local.external_bigip_map_az1
  iam_instance_profile        = var.iam_instance_profile_name.value
  custom_user_data            = data.template_file.external_onboard_az1.rendered
}
module external_az2 {
  source = "github.com/f5devcentral/terraform-aws-bigip?ref=develop"

  prefix = format(
    "%s-bigip_with_new_vpc_external-%s",
    var.project.value,
    var.random_id.value
  )
  ec2_instance_type           = var.ec2_instance_type
  ec2_key_name                = var.ec2_key_name
  aws_secretmanager_secret_id = var.secrets_manager_name.value
  bigip_map                   = local.external_bigip_map_az2
  iam_instance_profile        = var.iam_instance_profile_name.value
  custom_user_data            = data.template_file.external_onboard_az2.rendered
}
