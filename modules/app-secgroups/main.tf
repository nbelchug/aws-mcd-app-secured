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

      # ----------------------------------------------------
      # SECURITY GROUPS
      # FRONTEND SECURITY GROUP - allow SSH, Allow HTTPS HTTP and PORT 8080 as well backend
      resource "aws_security_group" "frontend_sg" {
      name        = "frontend_sg"
      description = "Allow SSH 8080 inbound traffic and all outbound traffic, allow 3306 and 8080 to backend"
      vpc_id      = module.app-vpcs.app_be_vpc_id 

      tags = {
         Name = "mcd-demo-teashop-frontend-sg"
         Tier = "front-end"
         Application = var.application_name
         Environment = var.environment

      }
      }

      # -----------------------------------------------------
      # SECURITY GROUP - RULES FOR FE NODES
      resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_frontend" {
      security_group_id = aws_security_group.frontend_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 22
      ip_protocol       = "tcp"
      to_port           = 22
      }

      #resource "aws_vpc_security_group_ingress_rule" "allow_in_3306_ipv4_frontend" {
      #  security_group_id = aws_security_group.frontend_sg.id
      #  cidr_ipv4         = "0.0.0.0/0"
      #  from_port         = 3306
      #  ip_protocol       = "tcp"
      #  to_port           = 3306
      #}
      resource "aws_vpc_security_group_ingress_rule" "allow_in_8080_ipv4_frontend" {
      security_group_id = aws_security_group.frontend_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 8080
      ip_protocol       = "tcp"
      to_port           = 8080
      }

      resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_frontend" {
         security_group_id = aws_security_group.frontend_sg.id
         cidr_ipv4         = module.app-vpcs.app_fe_vpc_cidr_block
         ip_protocol       = "icmp"
         from_port         = -1
         to_port           = -1
      }

      resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_frontend" {
      security_group_id = aws_security_group.frontend_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      ip_protocol       = "-1" # semantically equivalent to all ports
      }

      #-----------------------------------------------------------------
      # SECURITY GROUP - RULES FOR BE NODES
      resource "aws_security_group" "backend_sg" {
      name        = "backend_sg"
      description = "Allow  SSH DB 8080 inbound traffic and outbound to public subnet"
      vpc_id      = module.app-vpcs.app_fe_vpc_id

      tags = {
         Name = "mcd-demo-teashop-backend-sg"
         Tier = "back-end"
         Application = var.application_name
         Environment = var.environment

      }
      }

      #resource "aws_vpc_security_group_ingress_rule" "allow_in_any_ipv4_backend" {
      #  security_group_id = aws_security_group.backend_sg.id
      #  cidr_ipv4         = "0.0.0.0/0"
      #  ip_protocol       = -1
      #}

      resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_backend" {
      security_group_id = aws_security_group.backend_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 22
      ip_protocol       = "tcp"
      to_port           = 22
      }
      resource "aws_vpc_security_group_ingress_rule" "allow_in_3306_ipv4_backend" {
      security_group_id = aws_security_group.backend_sg.id
      cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
      from_port         = 3306
      ip_protocol       = "tcp"
      to_port           = 3306
      }
      resource "aws_vpc_security_group_ingress_rule" "allow_in_8080_ipv4_backend" {
      security_group_id = aws_security_group.backend_sg.id
      cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
      from_port         = 8080
      ip_protocol       = "tcp"
      to_port           = 8080
      }


      resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_backend" {
      security_group_id = aws_security_group.backend_sg.id
      cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
      ip_protocol       = "icmp"
         from_port         = -1
         to_port           = -1
      }
      resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_backend" {
      security_group_id = aws_security_group.backend_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      ip_protocol       = "-1" # semantically equivalent to all ports
      }
