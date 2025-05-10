variable "region" {
  description = "AWS Region"
}

variable "profile" {
  description = "profile name"
}

variable "environment" {
  description = "Environment name"
}

variable "account_name" {
  description = "aws account name"
}

#variable for ingress vpc

variable "azs_ingress" {
  type        = list(any)
  description = "list of availibility for ingress vpc "
}

variable "ingress_vpc_cidr" {
  type        = string
  description = "cidr range for main inpecion/egress vpc"
}

variable "ingress_public_subnet_cidr" {
  type        = list(any)
  description = "cidr range for all public subnets "
}

#for s3:
variable bucket_name {
  description = "Name of the bucket that is going to be created"
}

variable "s3_logging_bucket" {
  description = "The name of the acme corp logging bucket"
  default = "acme-s3-logging-bucket"
}

variable "cost_centre" {
  description = "The cost centre code for the bucket"
}
variable "acme_s3_logging_bucket" {
  description = "The s3 logging bucket"
  default = "acme-s3-access-bucket"
}