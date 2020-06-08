# BIG-IP Management Public IP Addresses
output "bigip_mgmt_ips" {
  value = {
    external_az1 = module.external_az1.mgmt_public_ips
    external_az2 = module.external_az2.mgmt_public_ips
    ips_az1      = module.ips_az1.mgmt_public_ips
    ips_az2      = module.ips_az2.mgmt_public_ips
    internal_az1 = module.internal_az1.mgmt_public_ips
    internal_az2 = module.internal_az2.mgmt_public_ips
  }
}

# BIG-IP Management Public DNS Address
output "bigip_mgmt_dns" {
  value = {
    external_az1 = module.external_az1.mgmt_public_dns
    external_az2 = module.external_az2.mgmt_public_dns
    ips_az1      = module.ips_az1.mgmt_public_dns
    ips_az2      = module.ips_az2.mgmt_public_dns
    internal_az1 = module.internal_az1.mgmt_public_dns
    internal_az2 = module.internal_az2.mgmt_public_dns
  }
}

# BIG-IP Management Port
output "bigip_mgmt_port" {
  value = {
    external_az1 = module.external_az1.mgmt_port
    external_az2 = module.external_az2.mgmt_port
    ips_az1      = module.ips_az1.mgmt_port
    ips_az2      = module.ips_az2.mgmt_port
    internal_az1 = module.internal_az1.mgmt_port
    internal_az2 = module.internal_az2.mgmt_port
  }
}

output "mgmt_addresses" {
  description = "List of BIG-IP management addresses"
  value = {
    external_az1 = module.external_az1.mgmt_addresses
    external_az2 = module.external_az2.mgmt_addresses
    ips_az1      = module.ips_az1.mgmt_addresses
    ips_az2      = module.ips_az2.mgmt_addresses
    internal_az1 = module.internal_az1.mgmt_addresses
    internal_az2 = module.internal_az2.mgmt_addresses
  }
}

output "public_addresses" {
  description = "List of BIG-IP public addresses"
  value = {
    external_az1 = module.external_az1.public_addresses
    external_az2 = module.external_az2.public_addresses
    ips_az1      = module.ips_az1.public_addresses
    ips_az2      = module.ips_az2.public_addresses
    internal_az1 = module.internal_az1.public_addresses
    internal_az2 = module.internal_az2.public_addresses
  }
}

output "private_addresses" {
  description = "List of BIG-IP private addresses"
  value = {
    external_az1 = module.external_az1.private_addresses
    external_az2 = module.external_az2.private_addresses
    ips_az1      = module.ips_az1.private_addresses
    ips_az2      = module.ips_az2.private_addresses
    internal_az1 = module.internal_az1.private_addresses
    internal_az2 = module.internal_az2.private_addresses
  }
}

# Public Network Interface
output "public_nic_ids" {
  description = "List of BIG-IP public network interface ids"
  value = {
    external_az1 = module.external_az1.public_nic_ids
    external_az2 = module.external_az2.public_nic_ids
    ips_az1      = module.ips_az1.public_nic_ids
    ips_az2      = module.ips_az2.public_nic_ids
    internal_az1 = module.internal_az1.public_nic_ids
    internal_az2 = module.internal_az2.public_nic_ids
  }
}

# BIG-IP map
output "bigip_map" {
  description = "Map of the deployed BIG-IPs and their network information"
  value = {
    external_az1 = module.external_az1.bigip_map
    external_az2 = module.external_az2.bigip_map
    ips_az1      = module.ips_az1.bigip_map
    ips_az2      = module.ips_az2.bigip_map
    internal_az1 = module.internal_az1.bigip_map
    internal_az2 = module.internal_az2.bigip_map
  }
}

# CFE bucket details
output "cfe_bucket_external" {
  description = "Details of CFE bucket for external tier"
  value = aws_s3_bucket.cfe_external_bucket
}
output "cfe_bucket_internal" {
  description = "Details of CFE bucket for internal tier"
  value = aws_s3_bucket.cfe_internal_bucket
}