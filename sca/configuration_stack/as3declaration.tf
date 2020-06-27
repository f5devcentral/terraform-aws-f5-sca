#baseline AS3 config for routing outbound traffic at each tier
resource "bigip_as3"  "external_bigip_az1" {
     depends_on = [
        bigip_do.external_bigip_az1,
        bigip_do.external_bigip_az2,
        null_resource.cfe-internal-az1,
        null_resource.cfe-internal-az2
     ]
     provider = bigip.external_bigip_az1
     as3_json = templatefile("${path.module}/templates/as3/external_tier.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal"
    })
 }

 resource "bigip_as3" "ips_bigip_az1" {
     depends_on = [
        bigip_do.ips_bigip_az1,
        bigip_do.ips_bigip_az2
     ]
     provider = bigip.ips_bigip_az1
     as3_json = templatefile("${path.module}/templates/as3/ips_tier.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal"
      poolMember1 = local.ext_self_ip_extNic_az1[0].subnets[3].private_ip,
      poolMember2 = local.ext_self_ip_extNic_az2[0].subnets[3].private_ip,
      virtualAddress2 = "0.0.0.0/0",
      allowedVlan2 = "external"
    })
 }

  resource "bigip_as3" "ips_bigip_az2" {
     depends_on = [
        bigip_do.ips_bigip_az1,
        bigip_do.ips_bigip_az2
     ]
     provider = bigip.ips_bigip_az2
     as3_json = templatefile("${path.module}/templates/as3/ips_tier.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal",
      poolMember1 = local.ext_self_ip_extNic_az1[0].subnets[3].private_ip,
      poolMember2 = local.ext_self_ip_extNic_az2[0].subnets[3].private_ip,
      virtualAddress2 = "0.0.0.0/0",
      allowedVlan2 = "external"
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
     as3_json = templatefile("${path.module}/templates/as3/internal_tier.tmpl", {
      virtualAddress = "0.0.0.0/0",
      allowedVlan = "internal",
      poolMember1 = local.ips_self_ip_extNic_az1[0].subnets[3].private_ip,
      poolMember2 = local.ips_self_ip_extNic_az2[0].subnets[3].private_ip
    })
 }
