variable bigip_mgmt_ips {}
variable project {}
variable random_id {}

variable "aws_region" {}

# DO variables for each BIG-IP tier
## Ext tier
variable "bigip_map" {}
variable "ext0_gateway" {
    default = "10.100.0.1"
}
variable "ext1_gateway" {
    default = "10.100.10.1"
}
variable "ips0_gateway" {
    default = "10.100.6.1"
}
variable "ips1_gateway" {
    default = "10.100.16.1"
}
variable "int0_gateway" {
    default = "10.0.7.1"
}
variable "int1_gateway" {
    default = "10.0.17.1"
}



# DO variables common across all tiers
variable ntp_server {
    default = "0.us.pool.ntp.org"
}
variable dns_server {
    default = "8.8.8.8"
}
variable timezone {
    default = "UTC"
}
variable uname {
    default = "admin"
}
variable secrets_manager_name {}

variable cfe_bucket_external {}
variable cfe_bucket_internal {}
variable CFE_route_tables {}
