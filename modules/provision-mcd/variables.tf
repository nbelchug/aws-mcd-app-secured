
variable "ciscomcd_api_key_file"{
    type = string
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

variable "tags" {
    type = map(string)
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
