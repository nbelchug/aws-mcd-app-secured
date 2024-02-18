# fe_nodes = module.app-infra-aws.fe-fe_nodes.value
# be_nodes =module.app-infra-aws.fe-be_nodes.value 


resource "ciscomcd_service_vpc" "aws_service_vpc" {
  name               = "aws-service-vpc"
  csp_account_name   = "aws-account1"
  region             = "us-east-1"
  cidr               = var.service-vpc-subnet
  availability_zones = [var.az1]
  transit_gateway_id = "tgw-12345678912345678"
  use_nat_gateway    = true
}
    

