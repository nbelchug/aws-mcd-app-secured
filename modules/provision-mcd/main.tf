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

resource "ciscomcd_cloud_account" "aws1" {
  name                     = "aws-account1"
  description              = "AWS Account - 123456789012"
  csp_type                 = "AWS"
  aws_credentials_type     = "AWS_IAM_ROLE"
  aws_iam_role             = "arn:aws:iam::${var.csp_account_name}:role/ciscomcd-controller-role"
  aws_account_number       = var.csp_account_name
  aws_iam_role_external_id = var.external_id
  aws_inventory_iam_role   = "arn:aws:iam::${var.csp_account_name}:role/ciscomcd-inventory-role"
}



resource "ciscomcd_service_vpc" "aws_service_vpc" {
  name               = "aws-service-vpc"
  csp_account_name   = var.csp_account_name
  region             = "us-east-1"
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

resource "ciscomcd_spoke_vpc" "ciscomcd_spoke" {
  count = module.app-infra-aws.app-vpcs.length
  service_vpc_id = ciscomcd_service_vpc.aws_service_vpc.id
  spoke_vpc_id   = module.app-infra-aws.app-vpcs[count.index]
}


