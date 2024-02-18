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

# VPC BLOCK
# creating VPC


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



      #----------------------------------------
      # TRANSIT GATEWAYS ACROSS FE AND BE VPCs
      resource "aws_ec2_transit_gateway" "fe-be-tgw" {
         count = (var.skip_tgw == false ? 1 : 0)
      description                     = "Transit Gateway between FE and BE for app"
      default_route_table_association = "enable"
      default_route_table_propagation = "enable"

      tags                           = {
         Name                         = "mcd-demo-teashop-fe-be-tgw"
         Application                  = var.application_name
         Environment                  = var.environment
      }
      }



      #----------------------------------------
      # TRANSIT GATEWAYS ATTACHMENT BETWEEN FE AND TGW
      resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-fe" {
         subnet_ids         = [module.app_vpcs.public_subnet]
         transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
         vpc_id             = aws_vpc.custom_vpc_fe.id
         transit_gateway_default_route_table_association = true
         transit_gateway_default_route_table_propagation = true
         tags               = {
            Name             = "mcd-demo-tgw-att-vpc-fe"
            Application   = var.application_name
            Tier          = "front-end"
      }
      depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
      }
      #----------------------------------------
      # TRANSIT GATEWAYS ATTACHMENT BETWEEN BE AND TGW
      resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-be" {
      subnet_ids         = [module.app_vpcs.private_subnet]
      transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
      vpc_id             = aws_vpc.custom_vpc_be.id
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      tags               = {
            Name             = "mcd-demo-tgw-att-vpc-be"
            Application   = var.application_name
            Tier          = "back-end"
      }
      depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
      }

