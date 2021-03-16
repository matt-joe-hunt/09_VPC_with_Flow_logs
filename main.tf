provider "aws" {
  region = var.region-master
}

module "VPC" {
  source   = "./VPC"
  vpc-name = var.vpc-name
}
