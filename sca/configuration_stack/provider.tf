provider "aws" {
  region = var.aws_region.value
}

provider "bigip" {
  version = "~> 1.2"
  alias = "external_bigip_az1"
  address = "https://${var.bigip_mgmt_ips.value.external_az1[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}

provider "bigip" {
  version = "~> 1.2"
  alias = "external_bigip_az2"
  address = "https://${var.bigip_mgmt_ips.value.external_az2[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}

provider "bigip" {
  version = "~> 1.2"
  alias = "ips_bigip_az1"
  address = "https://${var.bigip_mgmt_ips.value.ips_az1[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}

provider "bigip" {
  version = "~> 1.2"
  alias = "ips_bigip_az2"
  address = "https://${var.bigip_mgmt_ips.value.ips_az2[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}

provider "bigip" {
  version = "~> 1.2"
  alias = "internal_bigip_az1"
  address = "https://${var.bigip_mgmt_ips.value.internal_az1[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}

provider "bigip" {
  version = "~> 1.2"
  alias = "internal_bigip_az2"
  address = "https://${var.bigip_mgmt_ips.value.internal_az2[0]}"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.secret.secret_string
}
