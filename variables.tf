variable "ciscomcd_api_key_file" {
    description = " Key to access cisco MCD"
    type = string
    default = "~/.ssh/TERRAFORM2.json"
}  

variable "aws_availability_zone" {
  description = "availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "aws_ssh_key_pair_name" {
  description = "name of RSA Key to use to connect Terraform to EC2 instances"
  type        = string
  default     = "terraform-key-devops-admin-ubuntu"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "csp_account_name_mcd_reg" {
  type = string
}

variable "transit-gateway-id" {
  type = string
}

# dev env

variable "DEV-app_fe_vpc_id" {
  type = string
}

variable "DEV-app_be_vpc_id" {
  type = string
}

variable "DEV-frontend-nodes-private-ips" {
  type = string
}

variable "DEV-backend-nodes-private-ips" {
  type = string
}

variable "DEV-aws_route_table_rt_be" {
  type = string
}

variable "DEV-aws_route_table_rt_fe" {
  type = string
}

# val env

variable "VAL-app_fe_vpc_id" {
  type = string
}

variable "VAL-app_be_vpc_id" {
  type = string
}

variable "VAL-frontend-nodes-private-ips" {
  type = string
}

variable "VAL-backend-nodes-private-ips" {
  type = string
}

variable "VAL-aws_route_table_rt_be" {
  type = string
}

variable "VAL-aws_route_table_rt_fe" {
  type = string
}

# pro env

variable "PRO-app_fe_vpc_id" {
  type = string
}

variable "PRO-app_be_vpc_id" {
  type = string
}

variable "PRO-frontend-nodes-private-ips" {
  type = string
}

variable "PRO-backend-nodes-private-ips" {
  type = string
}

variable "PRO-aws_route_table_rt_be" {
  type = string
}

variable "PRO-aws_route_table_rt_fe" {
  type = string
}