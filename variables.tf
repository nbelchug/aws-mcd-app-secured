variable "csp_account_name"{
  type = string
  default = "905418156764"
}

variable "ciscomcd_api_key_file" {
    description = " Key to access cisco MCD"
    type = string
    default = "~/.ssh/TERRAFORM2.json"
}    
variable "aws_region"{
  type= string
  default = "us-east-1"
}
variable "application_name" {
  description = "Name of the application. Must be unique."
  type        = string
  default = "TEA-SHOP"
}

variable "environment" {
	description ="environmet dev val ref prod for the application"
	type = string
	default= "development"
}

variable "skip_tgw"{
  type = bool
  default = true
}


variable "keyname"{
  description = "name of RSA Key to use to connect Terraform to EC2 instances"
  type = string
  default = "terraform-key-devops-admin-ubuntu"
}

variable "tags" {
  description = "Tags to set on the application."
  type        = map(string)
  default     = {}
}

variable "az_list"{
  type = list(string)
  default =   ["us-east-1a"]
}
# AZ 1
variable "az1" {
  description = "availability zone 1"
  type        = string
  default     = "us-east-1a"
}

# AZ 2
variable "az2" {
  description = "availability zone 2"
  type        = string
  default     = "us-east-1b"
}

# AZ 3
variable "az3" {
  description = "availability zone c"
  type        = string
  default     = "us-east-1c"
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
  default =     "ami-0c7217cdde317cfec"


}


# ec2 instance type
variable "ec2_instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.small"
}

variable "nof_frontend_nodes"{
  description = "Front End nodes"
  type        = number 
  default     =   1
}

variable "nof_backend_nodes"{
  description = "BackEnd nodes"
  type        = number 
  default     =   1
}

 
