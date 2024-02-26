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
    ciscomcd = {
      source  = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }
  }
  required_version = "~> 1.3"
}

provider "ciscomcd" {
  api_key_file = file(var.ciscomcd_api_key_file)
}

module "mcd-service-vpc" {
  source = "./modules/mcd-service-vpc"
  # variables which depend on modules from app's repo
  aws_availability_zone      = var.aws_availability_zone
  aws_ssh_key_pair_name      = var.aws_ssh_key_pair_name
  aws_region                 = var.aws_region
  app_fe_vpc_id              = var.app_fe_vpc_id
  app_be_vpc_id              = var.app_be_vpc_id
  frontend-nodes-private-ips = [var.frontend-nodes-private-ips]
  backend-nodes-private-ips  = [var.backend-nodes-private-ips]
  aws_route_table_rt_be      = var.aws_route_table_rt_be
  aws_route_table_rt_fe      = var.aws_route_table_rt_fe
  transit-gateway-id         = var.transit-gateway-id
  # direct input variables independant from app module's repo
  csp_account_name_mcd_reg = var.csp_account_name_mcd_reg
  mcd-gateway-policy       = var.gateway-policy
}
