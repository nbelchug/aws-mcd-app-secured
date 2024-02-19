

variable "tags" {
  description = "Tags to set on the application."
  type        = map(string)
  default     = {}
}

variable "csp_account_name"{
    type = string
}

variable "aws_region"{
    type= string
}

variable "app_fe_vpc_id"{
    type = string
}
variable "app_be_vpc_id"{
    type = string 
}
variable "tgw_id"{
    type = string
}

variable "service_vpc_subnet" {
    description = "subnet used in Service VPC"
    type = string 
    default = "10.254.0.0/24"

}
variable "application_name"{
    type = string
}
variable "environment"{
    type = string
}

variable "az1"{
    type = string
}
variable "az2"{
    type = string
}
variable "az3"{
    type = string
}
variable "tags"{

}