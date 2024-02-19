#Transit Gateway Module - Variables passed from ROOT module
variable "application_name"{
    type = string
}
variable "environment"{
    type = string
}
variable "app_fe_vpc_id" {
    type = string
}
variable "app_be_vpc_id" {
  type = string
}
variable "app_private_subnet_id" {
  type = string
}
variable "app_public_subnet_id" {
  type = string
}
variable "app_fe_cidr_block" {
  type = string
}
variable "app_be_cidr_block" {
  type = string
}


