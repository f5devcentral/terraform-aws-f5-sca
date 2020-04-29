locals {
  external_bigips = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : data.attachment[0].device_index => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "external")
  ])
}
#retrieve secret from AWS to use in DO
data "aws_secretsmanager_secret_version" "secret" {
  secret_id = var.secrets_manager_name.value
}

data "template_file" "vm01_do_json" {
  template = file("${path.module}/templates/declarativeOnboarding/externalClusterPayg.json")

  vars = {
    #Uncomment the following line for BYOL
    #local_sku	    = "${var.license1}"

    host1	        = var.ext0_host1
    host2	        = var.ext0_host2
    local_host      = var.ext0_local_host
#    local_selfip    = var.ext0_local_selfip
    local_selfip    = local.external_bigips[0].subnets.0.private_ip
    local_selfip2   = var.ext0_local_selfip2
    local_selfip3   = var.ext0_local_selfip3
    remote_host	    = var.ext0_remote_host
    remote_selfip   = var.ext0_remote_selfip
    gateway	        = var.ext0_gateway
    dns_server	    = var.dns_server
    ntp_server	    = var.ntp_server
    timezone	    = var.timezone
    admin_user      = var.uname
    admin_password  = data.aws_secretsmanager_secret_version.secret.secret_string
  }
}

resource "local_file" "vm02_do_file" {
  content     = "${data.template_file.vm01_do_json.rendered}"
  filename    = "${path.module}/vm01_do_data.json"
}
