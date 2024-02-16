# fe_nodes = module.app-infra-aws.fe-fe_nodes.value
# be_nodes =module.app-infra-aws.fe-be_nodes.value 


resource "ciscomcd_service_vpc" "aws_mcd_demo_teashop_service_vpc" {
  name               = "aws-mcd_demo_teashop_service-vpc"
  csp_account_name   = "aws-account1"
  region             = "us-east-1"
  cidr               = "10.0.0.0/23"
  availability_zones = ["us-east-1a", "us-east-1b"]
  transit_gateway_id = "tgw-12345678912345678"
  use_nat_gateway    = true
}


    

