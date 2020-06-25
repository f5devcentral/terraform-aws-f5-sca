locals {
  ext_self_ip_extNic_az1 = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : data.attachment[0].device_index => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "external_az1")
  ])
  ext_self_ip_extNic_az2 = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : data.attachment[0].device_index => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "external_az2")
  ])
  int_self_ip_intNic_az1 = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : data.attachment[0].device_index => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "internal_az1")
  ])
  int_self_ip_intNic_az2 = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : data.attachment[0].device_index => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "internal_az2")
  ])
}

# Template files for CFE declarations
data "template_file" "cfe_declaration_ext_tier" {
  template = file("${path.module}/templates/cloudFailoverExtension/cfe.json")

  vars = {
    label	        = var.cfe_bucket_external.value.tags.f5_cloud_failover_label
    labelRouteTable = var.CFE_route_tables.value.internet
    range         = "192.168.100.0/24"
    local_selfip    = local.ext_self_ip_extNic_az1[0].subnets[1].private_ip
    remote_selfip    = local.ext_self_ip_extNic_az2[0].subnets[1].private_ip
  }
}
data "template_file" "cfe_declaration_int_tier" {
  template = file("${path.module}/templates/cloudFailoverExtension/cfe.json")

  vars = {
    label	        = var.cfe_bucket_internal.value.tags.f5_cloud_failover_label
    labelRouteTable = var.CFE_route_tables.value.internal
    range         = "0.0.0.0/0"
    local_selfip    = local.int_self_ip_intNic_az1[0].subnets[3].private_ip
    remote_selfip    = local.int_self_ip_intNic_az2[0].subnets[3].private_ip
  }
}

resource "local_file" "ext_cfe_json" {
  content     = data.template_file.cfe_declaration_ext_tier.rendered
  filename    = "${path.module}/ext_cfe_json.json"
}
resource "local_file" "int_cfe_json" {
  content     = data.template_file.cfe_declaration_int_tier.rendered
  filename    = "${path.module}/int_cfe_json.json"
}

resource "null_resource" "cfe-external-az1" {
  depends_on = [
    bigip_do.external_bigip_az1,
    bigip_do.external_bigip_az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.external_az1[0]}/mgmt/shared/cloud-failover/info -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.external_az1[0]}/mgmt/shared/cloud-failover/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/ext_cfe_json.json
    EOF
  }
}

resource "null_resource" "cfe-external-az2" {
  depends_on = [
    bigip_do.external_bigip_az1,
    bigip_do.external_bigip_az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.external_az2[0]}/mgmt/shared/cloud-failover/info -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.external_az2[0]}/mgmt/shared/cloud-failover/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/ext_cfe_json.json
    EOF
  }
}

resource "null_resource" "cfe-internal-az1" {
  depends_on = [
    bigip_do.internal_bigip_az1,
    bigip_do.internal_bigip_az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.internal_az1[0]}/mgmt/shared/cloud-failover/info -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.internal_az1[0]}/mgmt/shared/cloud-failover/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/int_cfe_json.json
      sleep 25
    EOF
  }
}

resource "null_resource" "cfe-internal-az2" {
  depends_on = [
    bigip_do.internal_bigip_az1,
    bigip_do.internal_bigip_az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.internal_az2[0]}/mgmt/shared/cloud-failover/info -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.internal_az2[0]}/mgmt/shared/cloud-failover/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/int_cfe_json.json
      sleep 25
    EOF
  }
}