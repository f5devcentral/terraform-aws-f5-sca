resource "local_file" "cfe" {
  content  = data.template_file.cfe.rendered
  filename = "cfe.json"
}

data "template_file" "cfe" {
  template = file("templates/cloudFailoverExtension/cfe.json")
  vars = {
    label       = format( "%s-external-%s", var.project.value, var.random_id.value )
    local_selfip = local.external_bigip_az1[0].subnets.1.private_ip
    remote_selfip =  local.external_bigip_az2[0].subnets.1.private_ip
  }
}

