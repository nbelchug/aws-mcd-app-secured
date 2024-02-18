# --- root/Terraform_projects/terraform_two_tier_architecture/main.tf

# ************************************************************
# Description: two-tier architecture with terraform
# - file name: main.tf
# - custom VPC
# - 1 public subnets in different AZs for high availability
# - 1 private subnets in different AZs
# - 1 EC2 t2.micro instance in each public subnet
# ************************************************************

# PROVIDER BLOCK

terraform {
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
    #ciscomcd = {
    #  source = "CiscoDevNet/ciscomcd"
    #  version = "0.2.4"
    #}

  }
  required_version = "~> 1.3"
}

provider "aws" {
  region  = "us-east-1"
}

#provider "ciscomcd" {
#  api_key_file = file(var.ciscomcd_api_key_file)
#}


module "app-infra-aws" {
  source = "./modules/app-infra-aws"
}

module "cost-calc"{
  source = "./modules/cost-calc"
}

#module "provision-mcd" {
#  source = "./modules/provision-mcd"
#}
