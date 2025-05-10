module "tfsec_vpc" {
  source                     = "./modules/vpc_ec2"
  profile                    = var.profile
  region                     = var.region
  environment                = var.environment
  azs_ingress                = var.azs_ingress
  ingress_vpc_cidr           = var.ingress_vpc_cidr
  ingress_public_subnet_cidr = var.ingress_public_subnet_cidr
}

module "acme_finance_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "financial-reports"
  cost_centre = "SANJ001"

  s3_logging_bucket = var.acme_s3_logging_bucket
}

