module "pricing_example_pricing-terraform-state-and-plan" {
  source  = "terraform-aws-modules/pricing/aws//examples/pricing-terraform-state-and-plan"
  version = "2.0.2"
}

data "local_file" "local_plan" {
  filename = "${path.module}/app-infra-plan.json"
}



