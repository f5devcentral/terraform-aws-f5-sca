data "template_file" "as3_declaration_baseline" {
  template = file("${path.module}/templates/as3/as3.tmpl")

  vars = {
    virtualAddress	        = "0.0.0.0/0"
    allowedVlan	        = "internal"
  }
}

resource "local_file" "as3_declaration_baseline" {
  content     = data.template_file.as3_declaration_baseline.rendered
  filename    = "${path.module}/as3_declaration_baseline.json"
}

resource "null_resource" "as3-external" {
  depends_on = [
    null_resource.cfe-external-az1,
    null_resource.cfe-external-az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.external_az1[0]}/mgmt/shared/appsvcs/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.external_az1[0]}/mgmt/shared/appsvcs/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/as3_declaration_baseline.json
    EOF
  }
}

resource "null_resource" "as3-internal" {
  depends_on = [
    null_resource.cfe-internal-az1,
    null_resource.cfe-internal-az2
    ]
  # Running CFE REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 15
      curl -k -X GET https://${var.bigip_mgmt_ips.value.internal_az1[0]}/mgmt/shared/appsvcs/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string}
      sleep 10
      curl -k -X POST https://${var.bigip_mgmt_ips.value.internal_az1[0]}/mgmt/shared/appsvcs/declare -u admin:${data.aws_secretsmanager_secret_version.secret.secret_string} -d @${path.module}/as3_declaration_baseline.json
    EOF
  }
}
/*
resource "bigip_as3"  "external_bigip_az1" {
     depends_on = [
        local_file.as3_declaration_baseline,
        null_resource.cfe-internal-az1,
        null_resource.cfe-internal-az2
     ]
     provider = bigip.external_bigip_az1
     as3_json =  file("./as3_declaration_baseline.json")
     tenant_filter = "baseline"
 }

 resource "bigip_as3"  "internal_bigip_az1" {
     depends_on = [
        local_file.as3_declaration_baseline,
        null_resource.cfe-internal-az1,
        null_resource.cfe-internal-az2
     ]
     provider = bigip.internal_bigip_az1
     as3_json =  file("./as3_declaration_baseline.json")
     tenant_filter = "baseline"
 }
 */