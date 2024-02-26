# variable "mcd_cloud_account_name" {
#   description = "Name used to represent the AWS Account in the MCD Dashboard."
# }

variable "aws_availability_zone" {
  description = "AWS availability zone in which to create the Service VPC Transit Gateway instance."
  type        = string
}

variable "aws_ssh_key_pair_name" {
  description = "SSH Keypair ID used for App EC2 Instances."
}

variable "csp_account_name_mcd_reg" {
  description = "The CSP Account name (configured in Multicloud Defense) where the Service VPC/VNet will be deployed"
}

variable "aws_region"{
  type= string
  description = "CSP Account Name"
}

variable "mcd-gateway-policy"{
  type=string
  description = "MCD Gateway Policy Name"
}

variable "app_fe_vpc_id"{
  type=string
}

variable "app_be_vpc_id"{
  type=string
}

variable "backend-nodes-private-ips"{
  type=list
}

variable "frontend-nodes-private-ips"{
  type=list
}

variable "aws_route_table_rt_be"{
  type=string
}

variable "aws_route_table_rt_fe"{
  type=string
}

variable "transit-gateway-id"{
  type=string
}