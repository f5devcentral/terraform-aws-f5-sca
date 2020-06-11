locals {
  external_bigip_map_az1 = {
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
  }
}
locals {
    external_bigip_map_az2 = {
    "0" = {
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
data "template_file" "external_onboard_az1" {
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
    # gateways
    applicationGateway =  var.aws_cidr_ips.value.az1.security.application_region
    dmzInsideGateway   =  var.aws_cidr_ips.value.az1.security.dmz_inside
    dmzOutsideGateway  =  var.aws_cidr_ips.value.az1.security.dmz_outside
    egressCh1Gateway   =  var.aws_cidr_ips.value.az1.security.egress_to_ch1
    egressCh2Gateway   =  var.aws_cidr_ips.value.az1.security.egress_to_ch2
    internalGateway    =  var.aws_cidr_ips.value.az1.security.internal
    externalGateway    =  var.aws_cidr_ips.value.az1.security.internet
    mgmtGateway        =  var.aws_cidr_ips.value.az1.security.mgmt
    peeringGateway     =  var.aws_cidr_ips.value.az1.security.peering
    # networks
    applicationNetwork =  var.subnet_cidrs.value.az1.security.application_region
    dmzInsideNetwork   =  var.subnet_cidrs.value.az1.security.dmz_inside
    dmzOutsideNetwork  =  var.subnet_cidrs.value.az1.security.dmz_outside
    egressCh1Network   =  var.subnet_cidrs.value.az1.security.egress_to_ch1
    egressCh2Network   =  var.subnet_cidrs.value.az1.security.egress_to_ch2
    internalNetwork    =  var.subnet_cidrs.value.az1.security.internal
    externalNetwork    =  var.subnet_cidrs.value.az1.security.internet
    mgmtNetwork        =  var.subnet_cidrs.value.az1.security.mgmt
    peeringNetwork     =  var.subnet_cidrs.value.az1.security.peering
    # sync must be other az
    syncNetwork        = var.subnet_cidrs.value.az2.security.application_region
  }
}
data "template_file" "external_onboard_az2" {
  # Error: expected length of user_data to be in the range (0 - 16384), got #!/bin/bash
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
    # gateways
    applicationGateway =  var.aws_cidr_ips.value.az2.security.application_region
    dmzInsideGateway   =  var.aws_cidr_ips.value.az2.security.dmz_inside
    dmzOutsideGateway  =  var.aws_cidr_ips.value.az2.security.dmz_outside
    egressCh1Gateway   =  var.aws_cidr_ips.value.az2.security.egress_to_ch1
    egressCh2Gateway   =  var.aws_cidr_ips.value.az2.security.egress_to_ch2
    internalGateway    =  var.aws_cidr_ips.value.az2.security.internal
    externalGateway    =  var.aws_cidr_ips.value.az2.security.internet
    mgmtGateway        =  var.aws_cidr_ips.value.az2.security.mgmt
    peeringGateway     =  var.aws_cidr_ips.value.az2.security.peering
    # networks
    applicationNetwork =  var.subnet_cidrs.value.az2.security.application_region
    dmzInsideNetwork   =  var.subnet_cidrs.value.az2.security.dmz_inside
    dmzOutsideNetwork  =  var.subnet_cidrs.value.az2.security.dmz_outside
    egressCh1Network   =  var.subnet_cidrs.value.az2.security.egress_to_ch1
    egressCh2Network   =  var.subnet_cidrs.value.az2.security.egress_to_ch2
    internalNetwork    =  var.subnet_cidrs.value.az2.security.internal
    externalNetwork    =  var.subnet_cidrs.value.az2.security.internet
    mgmtNetwork        =  var.subnet_cidrs.value.az2.security.mgmt
    peeringNetwork     =  var.subnet_cidrs.value.az2.security.peering
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
