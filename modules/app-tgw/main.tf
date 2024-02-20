# TRANSIT GATEWAY MODULE 


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
         description                     = "Transit Gateway between FE and BE for app"
         default_route_table_association = "enable"
         default_route_table_propagation = "enable"

         tags                           = {
            Name = format("mcd-demo-%s-tgw-%s",var.application_name,var.tfrun_identifier)
            #Name                         = "mcd-demo-teashop-fe-be-tgw"
            Application                  = var.application_name
            Environment                  = var.environment
            ResourceGroup = var.tfrun_identifier

         }
      }



      #----------------------------------------
      # TRANSIT GATEWAYS ATTACHMENT BETWEEN FE AND TGW
      resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-fe" {
         subnet_ids         = [var.app_public_subnet_id]
         transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
         vpc_id             = var.app_fe_vpc_id
         transit_gateway_default_route_table_association = true
         transit_gateway_default_route_table_propagation = true

         tags               = {
            Name = format("mcd-demo-%s-tgw-att-vpc-fe-%s",var.application_name,var.tfrun_identifier)
            #Name             = "mcd-demo-tgw-att-vpc-fe"
            Application   = var.application_name
            Tier          = "frontend"
            ResourceGroup = var.tfrun_identifier

      }
      depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
      }
      #----------------------------------------
      # TRANSIT GATEWAYS ATTACHMENT BETWEEN BE AND TGW
      resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-be" {
         subnet_ids         = [var.app_private_subnet_id]
         transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
         vpc_id             = var.app_be_vpc_id
         transit_gateway_default_route_table_association = true
         transit_gateway_default_route_table_propagation = true
         tags               = {
               Name = format("mcd-demo-%s-tgw-att-vpc-be-%s",var.application_name,var.tfrun_identifier)
               #Name             = "mcd-demo-tgw-att-vpc-be"
               Application   = var.application_name
               Tier          = "backend"
         }
         depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
      }

