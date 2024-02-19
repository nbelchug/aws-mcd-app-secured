# fe_nodes = module.app-infra-aws.fe-fe_nodes.value
# be_nodes =module.app-infra-aws.fe-be_nodes.value 

terraform {
   required_providers {

    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }
   }
}


resource "ciscomcd_service_vpc" "aws_service_vpc" {
  name               = "aws-service-vpc"
  csp_account_name   = var.csp_account_name
  region             = var.aws_region
  cidr               = var.service_vpc_subnet
  availability_zones = [var.az1]
  transit_gateway_id = module.app-infra-aws.app-tgw-id
  use_nat_gateway    = true

   tags = {
      Name = "mcd-demo-teashop-servicevpc"
      Tier = "service-vpc"
      Application = var.application_name
      Environment = var.environment
   }
}

resource "ciscomcd_spoke_vpc" "ciscomcd_spoke_" {
  count = var.app_vpcs.length
  service_vpc_id = ciscomcd_service_vpc.aws_service_vpc.id
  spoke_vpc_id   = var.app_fe_vpc_id
}


