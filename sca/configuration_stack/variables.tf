variable "aws_region" {}

# DO variables for each BIG-IP tier
## Ext tier
variable "bigip_map" {}
variable "ext0_host1" {
    default = "10.0.0.1"
}
variable "ext0_host2" {
    default = "10.0.0.1"
}
variable "ext0_localhost" {
    default = "10.0.0.1"
}
variable "ext0_local_selfip" {
    default = "10.0.0.1"
}
variable "ext0_local_selfip2" {
    default = "10.0.0.1"
}
variable "ext0_local_selfip3" {
    default = "10.0.0.1"
}
variable "ext0_remote_host" {
    default = "10.0.0.1"
}
variable "ext0_remote_selfip" {
    default = "10.0.0.1"
}
variable "ext0_gateway" {
    default = "10.0.0.1"
}
variable "ext0_local_host" {
    default = "10.0.0.1"
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