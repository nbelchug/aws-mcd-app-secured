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
  # direct input variables independant from app module's repo
  aws_availability_zone    = var.aws_availability_zone
  aws_ssh_key_pair_name    = var.aws_ssh_key_pair_name
  aws_region               = var.aws_region
  csp_account_name_mcd_reg = var.csp_account_name_mcd_reg
  # variables which depend on modules from app's repo
  transit-gateway-id = var.transit-gateway-id
  ## dev env
  dev-app-be-vpc-id              = var.DEV-app_be_vpc_id
  dev-app-fe-vpc-id              = var.DEV-app_fe_vpc_id
  dev-frontend-nodes-private-ips = var.DEV-frontend-nodes-private-ips
  dev-backend-nodes-private-ips  = var.DEV-backend-nodes-private-ips
  dev-aws-route-table-rt-be      = var.DEV-aws_route_table_rt_be
  dev-aws-route-table-rt-fe      = var.DEV-aws_route_table_rt_fe
  ## val env
  val-app-be-vpc-id              = var.VAL-app_be_vpc_id
  val-app-fe-vpc-id              = var.VAL-app_fe_vpc_id
  val-frontend-nodes-private-ips = var.VAL-frontend-nodes-private-ips
  val-backend-nodes-private-ips  = var.VAL-backend-nodes-private-ips
  val-aws-route-table-rt-be      = var.VAL-aws_route_table_rt_be
  val-aws-route-table-rt-fe      = var.VAL-aws_route_table_rt_fe
  ## prod env
  pro-app-be-vpc-id              = var.PRO-app_be_vpc_id
  pro-app-fe-vpc-id              = var.PRO-app_fe_vpc_id
  pro-frontend-nodes-private-ips = var.PRO-frontend-nodes-private-ips
  pro-backend-nodes-private-ips  = var.PRO-backend-nodes-private-ips
  pro-aws-route-table-rt-be      = var.PRO-aws_route_table_rt_be
  pro-aws-route-table-rt-fe      = var.PRO-aws_route_table_rt_fe
}
