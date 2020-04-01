provider "aws" {
  region = var.aws_region
}

# Deploy the base AWS infrastructure
module aws_infrastructure {
  source = "./modules/aws_infrastructure"

  aws_region  = var.aws_region
  project     = var.project
  region-az-1 = var.region-az-1
  region-az-2 = var.region-az-2
}
