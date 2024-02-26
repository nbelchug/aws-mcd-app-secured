variable "csp_account_name" {
  type    = string
  default = "905418156764"
}

variable "ciscomcd_api_key_file" {
  description = " Key to access cisco MCD"
  type        = string
  default     = "~/.ssh/TERRAFORM2.json"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
# variable "application-name" {
#   description = "Name of the application. Must be unique."
#   type        = string
#   default     = "TEA-SHOP"
# }

variable "environment" {
  description = "environmet dev val ref prod for the application"
  type        = string
  default     = "development"
}


variable "skip_mcd" {
  type    = bool
  default = true
}

variable "skip_mcd_service_vpc" {
  type    = bool
  default = true
}

variable "skip_application_instances" {
  type    = bool
  default = false
}

variable "aws_ssh_key_pair_name" {
  description = "name of RSA Key to use to connect Terraform to EC2 instances"
  type        = string
  default     = "terraform-key-devops-admin-ubuntu"
}

variable "tags" {
  description = "Tags to set on the application."
  type        = map(string)
  default     = {}
}

variable "az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
# AZ 1
variable "aws_availability_zone" {
  description = "availability zone"
  type        = string
  default     = "us-east-1a"
}

# custom VPC variable
variable "vpc_cidr" {
  description = "custom vpc CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}
# custom VPC variable
variable "vpc_cidr_frontend" {
  description = "custom vpc CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}
# custom VPC variable
variable "vpc_cidr_backend" {
  description = "custom vpc CIDR notation"
  type        = string
  default     = "10.1.0.0/16"
}

# public subnet 1 variable
variable "public_subnet" {
  description = "public subnet CIDR notation"
  type        = string
  default     = "10.0.1.0/24"
}

# private subnet 1 variable
variable "private_subnet" {
  description = "private subnet CIDR notation"
  type        = string
  default     = "10.1.2.0/24"
}

# ec2 instance ami for Linux
variable "ec2_instance_ami" {
  description = "ec2 instance ami id"
  type        = string
  #default     = "ami-0e731c8a588258d0d"
  default = "ami-0c7217cdde317cfec"

}


# ec2 instance type
variable "ec2_instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.small"
}

variable "nof_frontend_nodes" {
  description = "Front End nodes"
  type        = number
  default     = 1
}

variable "nof_backend_nodes" {
  description = "BackEnd nodes"
  type        = number
  default     = 1
}

variable "gateway-policy" {
  type        = string
  description = "MCD Gateway Policy Name"
  default     = "mcd-gateway-policy"
}

variable "mcd-service-vpc" {
  type        = string
  description = "MCD Service VPC Name"
  default     = "mcd-service-vpc"
}

variable "csp_account_name_mcd_reg" {
  type    = string
}

variable "app_fe_vpc_id"{
  type = string
}

variable "app_be_vpc_id"{
  type = string
}

variable "frontend-nodes-private-ips"{
  type = string
}

variable "backend-nodes-private-ips"{
  type = string
}

variable "aws_route_table_rt_be"{
  type = string
}

variable "aws_route_table_rt_fe"{
  type = string
}

variable "transit-gateway-id"{
  type = string
}