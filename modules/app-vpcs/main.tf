# VPC MODULE - ONLY USES ROOT MODULE VARIABLES

terraform {
   required_providers {
    aws-this = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
   aws-peer = {
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
            Name = format("mcd-demo-%s-frontend-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-frontend"
            Tier = "frontend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      }

      resource "aws_vpc" "custom_vpc_be" {
         cidr_block       = var.vpc_cidr_backend

         enable_dns_hostnames = true
         enable_dns_support   = true

         tags = {
            Name = format("mcd-demo-%s-backend-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-backend"
            Tier = "backend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      }
      # -----------------------------------------------
      # SUBNETS - PUBLIC SUBNET IN FE VPC
      # public subnet 
      resource "aws_subnet" "public_subnet" {   
         vpc_id            = aws_vpc.custom_vpc_fe.id
         cidr_block        = var.public_subnet
         availability_zone = var.az1

         tags = {
            Name = format("mcd-demo-%s-frontend-subnet-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-frontend-subnet"
            Tier = "frontend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier


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
            Name = format("mcd-demo-%s-backend-subnet-%s",var.application_name,var.tfrun_identifier)

            #Name = "mcd-demo-teashop-backend-subnet"
            Tier = "backend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      }

      # ------------------------------------------------------  
      # INTERNET GATEWAYS
      # creating internet gateway for Front End
      resource "aws_internet_gateway" "igw_fe" {
         vpc_id = aws_vpc.custom_vpc_fe.id

         tags = {
            Name = format("mcd-demo-%s-frontend-igw-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-frontend-igw"
            Tier = "frontend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      } 

      # creating internet gateway for Back End
      resource "aws_internet_gateway" "igw_be" {
         vpc_id = aws_vpc.custom_vpc_be.id

         tags = {
            Name = format("mcd-demo-%s-backend-igw-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-backend-igw"
            Tier = "backend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      } 
   
      resource "aws_vpc_peering_connection" "fe-be-peering"{
         vpc_id = aws_vpc.custom_vpc_fe.id
         peer_vpc_id =aws_vpc.custom_vpc_be.id
      #   peer_owner_id =  data.aws_caller_identity.current.account_id
      }

      #resource "aws_vpc_peering_connection_accepter" "accepter"{
      #   provider                   = aws.accepter
      #   vpc_peering_connection_id  = "${aws_vpc_peering_connection-owner.id}"
      #   auto_accept                = true
      #}


      #resource "aws_route_table" "fe_routetable"{
      #   vpc_id = var.app_fe_vpc_id
      #}
      #resource "aws_route_table" "be_routetable"{
      #   vpc_id = var.app_be_vpc_id
      #}
      #resource "aws_route" "fe-to-be-route" {
      #   route_table_id            = 
      #   destination_cidr_block    = var.vpc_cidr_backend
      #   vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
      #}
   
      #resource "aws_route" "be-to-fe-route" {
      #   route_table_id            =    
      #   destination_cidr_block    = var.vpc_cidr_frontend
      #   vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
      #}

      # ---------------------------------------------
      # ROUTE TABLES - FRONTEND
      # creating route table for Front End - Allow 0/0 in as it needs to be provisioned by TF
      resource "aws_route_table" "rt_fe" {
         vpc_id = aws_vpc.custom_vpc_fe.id

         route          {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw_fe.id
         }
         route          {
            cidr_block = = var.vpc_cidr_backend 
            vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
         }
      


         tags = {
            Name = format("mcd-demo-%s-fe-to-igw-rt-%s",var.application_name,var.tfrun_identifier)
            #Name = "mcd-demo-teashop-fe-to-igw-rt"
            Tier = "frontend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

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

         route          {
            cidr_block = = var.vpc_cidr_frontend 
            vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
         }
      
         
         tags = {
            Name = format("mcd-demo-%s-be-to-igw-rt-%s",var.application_name,var.tfrun_identifier)

            #Name = "mcd-demo-teashop-be-to-tgw-and-igw-rt"
            Tier = "backend"
            Application = var.application_name
            Environment = var.environment
            ResourceGroup = var.tfrun_identifier

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

