#
# Create a random id
#
resource "random_id" "id" {
  byte_length = 2
}

#
# Deploy the base AWS infrastructure
#
module core {
  source = "../../modules/awsInfrastructure"

  aws_region  = var.aws_region
  project     = var.project
  region-az-1 = var.region-az-1
  region-az-2 = var.region-az-2
  cidr-1      = var.cidr-1
  cidr-2      = var.cidr-2
  cidr-3      = var.cidr-3
}
