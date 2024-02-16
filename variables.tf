
variable "appname"{
    description = "name of application to deploy"
    type        = string
    default     = "TEASHOP"
} 

variable "aws-region" {
    description = "aws region to use"
    default = "us-east-1"
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

variable "environment" {
	description ="environmet dev val ref prod for the application"
	type = string
	default= "development"
}


variable "ciscomcd_api_key_file" {
    description = " Key to access cisco MCD"
    type = string
    default = "~/.ssh/TERRAFORM2.json"
    
}
