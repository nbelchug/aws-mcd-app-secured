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
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.33.0"
    # }
    ciscomcd = {
      source  = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }

    # random = {
    #   source  = "hashicorp/random"
    #   version = "3.6.0"
    # }

  }
  required_version = "~> 1.3"
}

# provider "aws" {
#   region = var.aws_region
# }

provider "ciscomcd" {
  api_key_file = file(var.ciscomcd_api_key_file)
}


# resource "random_pet" "tf_run" {
#   keepers = {
#     length = 2
#     # Generate a new pet name each time we switch to a new AMI id
#     start_time = "${timestamp()}"
#   }
# }

# module "application_vpcs" {
#   source            = "./modules/app-vpcs"
#   vpc_cidr_frontend = var.vpc_cidr_frontend
#   vpc_cidr_backend  = var.vpc_cidr_backend
#   application_name  = var.application_name
#   tfrun_identifier  = random_pet.tf_run.id
#   environment       = var.environment
#   az_list           = var.az_list
#   az1               = var.az1
#   az2               = var.az2
#   az3               = var.az3
#   private_subnet    = var.private_subnet
#   public_subnet     = var.public_subnet


# }

# module "application_security_groups" {
#   source = "./modules/app-secgroups"

#   application_name  = var.application_name
#   tfrun_identifier  = random_pet.tf_run.id
#   environment       = var.environment
#   app_fe_vpc_id     = module.application_vpcs.app_fe_vpc_id
#   app_be_vpc_id     = module.application_vpcs.app_be_vpc_id
#   app_fe_cidr_block = module.application_vpcs.app_fe_cidr_block
#   app_be_cidr_block = module.application_vpcs.app_be_cidr_block

#   depends_on = [module.application_vpcs]
# }

# module "application_instances" {
#   source = "./modules/app-instances"

#   application_name        = var.application_name
#   tfrun_identifier        = random_pet.tf_run.id
#   environment             = var.environment
#   ec2_instance_ami        = var.ec2_instance_ami
#   ec2_instance_type       = var.ec2_instance_type
#   az1                     = var.az1
#   az2                     = var.az2
#   az3                     = var.az3
#   keyname                 = var.keyname
#   myapp_private_subnet_id = module.application_vpcs.app_private_subnet_id
#   myapp_public_subnet_id  = module.application_vpcs.app_public_subnet_id
#   myfrontend_sg           = module.application_security_groups.frontend_sg
#   mybackend_sg            = module.application_security_groups.backend_sg

#   depends_on = [module.application_vpcs, module.application_security_groups]
# }

module "mcd-service-vpc" {
  source                   = "./modules/mcd-service-vpc"
  mcd_cloud_account_name   = var.application_name
  aws_availability_zone    = var.az1
  aws_ssh_key_pair_name    = var.keyname
  aws_region               = var.aws_region
  mcd-gateway-policy       = var.mcd-gateway-policy
  csp_account_name_mcd_reg = var.csp_account_name_mcd_reg
  # app_fe_vpc_id     = module.application_vpcs.app_fe_vpc_id
  # app_be_vpc_id     = module.application_vpcs.app_be_vpc_id
  app_fe_vpc_id = var.app_fe_vpc_id
  app_be_vpc_id = var.app_be_vpc_id
  # frontend-nodes-private-ips = module.application_instances.frontend-nodes-private-ips
  # backend-nodes-private-ips = module.application_instances.backend-nodes-private-ips
  frontend-nodes-private-ips = var.frontend-nodes-private-ips
  backend-nodes-private-ips  = var.backend-nodes-private-ips
  # aws_route_table_rt_be = module.application_vpcs.aws_route_table_rt_be
  # aws_route_table_rt_fe = module.application_vpcs.aws_route_table_rt_fe
  aws_route_table_rt_be = var.aws_route_table_rt_be
  aws_route_table_rt_fe = var.aws_route_table_rt_fe

  # depends_on = [module.application_instances, module.application_vpcs]
}
