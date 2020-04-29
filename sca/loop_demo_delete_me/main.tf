variable bigip_map {}

locals {
  external_bigips = flatten([
    for environment, bigips in var.bigip_map.value : [
      for key, bigip in bigips : {
        id : key
        subnets : {
          for subnet, data in bigip : subnet => {
            private_ip : data.private_ip
          }
        }
      }
    ] if(environment == "external")
  ])
}


output external_bigips {
  value = local.external_bigips
}
