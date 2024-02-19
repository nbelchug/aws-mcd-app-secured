# VPC MODULE - ONLY USES ROOT MODULE VARIABLES

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

      resource "aws_vpc" "custom_vpc_fe" {
         cidr_block       = var.vpc_cidr_frontend

         enable_dns_hostnames = true
         enable_dns_support   = true

         tags = {
            Name = "mcd-demo-teashop-frontend"
            Tier = "front-end"
            Application = var.application_name
            Environment = var.environment
         }
      }

      resource "aws_vpc" "custom_vpc_be" {
         cidr_block       = var.vpc_cidr_backend

         enable_dns_hostnames = true
         enable_dns_support   = true

         tags = {
            Name = "mcd-demo-teashop-backend"
            Tier = "front-end"
            Application = var.application_name
            Environment = var.environment

         }
      }
      # -----------------------------------------------
      # SUBNETS - PUBLIC SUBNET IN FE VPC
      # public subnet 
      resource "aws_subnet" "public_subnet" {   
         vpc_id            = aws_vpc.custom_vpc_fe.id
         cidr_block        = var.public_subnet
         availability_zone = var.az_list

         tags = {
            Name = "mcd-demo-teashop-frontend-subnet"
            Tier = "front-end"
            Application = var.application_name
            Environment = var.environment

         }
      }
      # -----------------------------------------------
      # SUBNETS - PRIVATE SUBNET IN BE VPC
      # private subnet
      resource "aws_subnet" "private_subnet" {   
         vpc_id            = aws_vpc.custom_vpc_be.id
         cidr_block        = var.private_subnet
         availability_zone = var.az1

         tags = {
            Name = "mcd-demo-teashop-backend-subnet"
            Tier = "back-end"
            Application = var.application_name
            Environment = var.environment

         }
      }

      # ------------------------------------------------------  
      # INTERNET GATEWAYS
      # creating internet gateway for Front End
      resource "aws_internet_gateway" "igw_fe" {
         vpc_id = aws_vpc.custom_vpc_fe.id

         tags = {
            Name = "mcd-demo-teashop-frontend-igw"
            Tier = "front-end"
            Application = var.application_name
            Environment = var.environment

         }
      } 

      # creating internet gateway for Back End
      resource "aws_internet_gateway" "igw_be" {
         vpc_id = aws_vpc.custom_vpc_be.id

         tags = {
            Name = "mcd-demo-teashop-backend-igw"
            Tier = "back-end"
            Application = var.application_name
            Environment = var.environment

         }
      } 

      # ---------------------------------------------
      # ROUTE TABLES - FRONTEND
      # creating route table for Front End - Allow 0/0 in as it needs to be provisioned by TF
      resource "aws_route_table" "rt_fe" {
         vpc_id = aws_vpc.custom_vpc_fe.id

         route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw_fe.id
      }


         tags = {
            Name = "mcd-demo-teashop-fe-to-tgw-and-igw-rt"
            Tier = "front-end"
            Application = var.application_name
            Environment = var.environment

      }
      }
      # ---------------------------------------------------
      # ROUTE TABLES - BACKEND
      # creating route table for Back End - Allow 0/0 in as it needs to be provisioned by TF
      resource "aws_route_table" "rt_be" {
         vpc_id = aws_vpc.custom_vpc_be.id
         route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw_be.id
      }
      
         
         tags = {
            Name = "mcd-demo-teashop-be-to-tgw-and-igw-rt"
            Tier = "back-end"
            Application = var.application_name
            Environment = var.environment

      }
      }

      # ---------------------------------------------------
      # ROUTE TABLE ASSOCIATIONS
      # associate route table to the public subnet
      resource "aws_route_table_association" "public_rt" {
         subnet_id      = aws_subnet.public_subnet.id
         route_table_id = aws_route_table.rt_fe.id

      }

      # associate route table to the private subnet 1
      resource "aws_route_table_association" "private_rt" {
         subnet_id      = aws_subnet.private_subnet.id
         route_table_id = aws_route_table.rt_be.id

      }

