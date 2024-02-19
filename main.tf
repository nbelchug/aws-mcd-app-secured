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
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }

  }
  required_version = "~> 1.3"
}

provider "aws" {
  region  = "us-east-1"
}

#provider "ciscomcd" {
#  api_key_file = file(var.ciscomcd_api_key_file)
#}


module "application_vpcs" {
  source = "./modules/app-vpcs"
  vpc_cidr_frontend = var.vpc_cidr_frontend
  vpc_cidr_backend = var.vpc_cidr_backend
  application_name = var.application_name
  environment = var.environment
  

}

module "application_security_groups" {
  source = "./modules/app-secgroups"
  app_fe_vpc_id = module.application_vpcs.app_fe_vpc_id 
  app_be_vpc_id = module.application_vpcs.app_be_vpc_id 
  app_fe_cidr_block = module.application_vpcs.app_fe_vpc_cidr_block
  app_be_cidr_block = module.application_vpcs.app_be_vpc_cidr_block

    depends_on = [module.application_vpcs]
}

module "application_instances" {
  source = "./modules/app-instances"

  myapp_private_subnet_id =   module.application_vpcs.app_private_subnet_id
  myapp_public_subnet_id  =   module.application_vpcs.app_public_subnet_id
  myfrontend_sg           =   module.application_security_groups.frontend_sg
  mybackend_sg            =   module.application_security_groups.backend_sg

    depends_on = [module.application_vpcs, module.application_security_groups]
}


module "application_transitgateway" {
  source = "./modules/app-tgw"
  app_fe_vpc_id         =   module.application_vpcs.app_fe_vpc_id 
  app_be_vpc_id         =   module.application_vpcs.app_be_vpc_id 
  app_private_subnet_id =   module.application_vpcs.app_private_subnet_id
  app_public_subnet_id  =   module.application_vpcs.app_public_subnet_id
  app_fe_cidr_block     =   module.application_vpcs.app_fe_vpc_cidr_block
  app_be_cidr_block     =   module.application_vpcs.app_be_vpc_cidr_block

    depends_on = [module.application_vpcs]

}



#module "cost-calc"{
#  source = "./modules/cost-calc"
#}

#module "provision-mcd" {
#  source = "./modules/provision-mcd"
#}
