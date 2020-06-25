data "template_file" "as3_declaration_baseline" {
  template = file("${path.module}/templates/as3/as3.tmpl")

  vars = {
    virtualAddress	        = "0.0.0.0/0"
    allowedVlan	        = "internal"
  }
}

resource "bigip_as3"  "external_bigip_az1" {
     depends_on = [
        bigip_do.external_bigip_az1,
        bigip_do.external_bigip_az2,
        null_resource.cfe-internal-az1,
        null_resource.cfe-internal-az2
     ]
     provider = bigip.external_bigip_az1
     as3_json =  templatefile("${path.module}/templates/as3/as3.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal"
    })
 }

 resource "bigip_as3"  "internal_bigip_az1" {
     depends_on = [
        bigip_do.internal_bigip_az1,
        bigip_do.internal_bigip_az2,
        null_resource.cfe-internal-az1,
        null_resource.cfe-internal-az2
     ]
     provider = bigip.internal_bigip_az1
     as3_json =  templatefile("${path.module}/templates/as3/as3.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal"
    })
 }
