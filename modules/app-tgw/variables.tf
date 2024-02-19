# --- root/Terraform_projects/terraform_two_tier_architecture/variables.tf
variable "app_fe_vpc_id" {
    type = string
}
variable "app_be_vpc_id"{
  type = string
}
variable "app_private_subnet_id"{
  type = string
}
variable "app_public_subnet_id "{
  type = string
}
variable "app_fe_cidr_block "{
  type = string
}
variable "app_be_cidr_block "{
  type = string
}


