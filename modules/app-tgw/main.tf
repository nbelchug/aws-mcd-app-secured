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


      data "aws_caller_identity" "current" {}

      resource "aws_vpc_peering_connection" "fe-be-peering"{

         vpc_id = var.app_fe_vpc_id
         peer_vpc_id = var.app_be_vpc_id
         peer_owner_id =  data.aws_caller_identity.current.account_id
      }

      resource "aws_vpc_peering_connection_accepter" "accepter"{
         provider                   = aws.accepter
         vpc_peering_connection_id  = "${aws_vpc_peering_connection-owner.id}"
         auto_accept                = true
      }


      resource "aws_route_rable" "fe_routetable"{
         vpc_id = var.app_fe_vpc_id

      }

      resource "aws_route" "fe-to-be-route" {
         route_table_id            = aws_route_table.fe_routetable.id
         destination_cidr_block    = var.app_be_cidr_block
         vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
      }
   
      resource "aws_route" "be-to-fe-route" {
         route_table_id            = aws_route_table.be_routetable.id
         destination_cidr_block    = var.app_fe_cidr_block
         vpc_peering_connection_id = aws_vpc_peering_connection.fe-be-peering.id
      }