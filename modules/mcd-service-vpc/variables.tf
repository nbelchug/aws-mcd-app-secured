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

variable "aws_region"{
  type= string
  description = "CSP Account Name"
}

variable "csp_account_name_mcd_reg" {
  description = "The CSP Account name (configured in Multicloud Defense) where the Service VPC/VNet will be deployed"
}

variable "transit-gateway-id" {
  type = string
}

# dev env

variable "dev-app-fe-vpc-id" {
  type = string
}

variable "dev-app-be-vpc-id" {
  type = string
}

variable "dev-frontend-nodes-private-ips" {
  type = string
}

variable "dev-backend-nodes-private-ips" {
  type = string
}

variable "dev-aws-route-table-rt-be" {
  type = string
}

variable "dev-aws-route-table-rt-fe" {
  type = string
}

# val env

variable "val-app-fe-vpc-id" {
  type = string
}

variable "val-app-be-vpc-id" {
  type = string
}

variable "val-frontend-nodes-private-ips" {
  type = string
}

variable "val-backend-nodes-private-ips" {
  type = string
}

variable "val-aws-route-table-rt-be" {
  type = string
}

variable "val-aws-route-table-rt-fe" {
  type = string
}

# pro env

variable "pro-app-fe-vpc-id" {
  type = string
}

variable "pro-app-be-vpc-id" {
  type = string
}

variable "pro-frontend-nodes-private-ips" {
  type = string
}

variable "pro-backend-nodes-private-ips" {
  type = string
}

variable "pro-aws-route-table-rt-be" {
  type = string
}

variable "pro-aws-route-table-rt-fe" {
  type = string
}