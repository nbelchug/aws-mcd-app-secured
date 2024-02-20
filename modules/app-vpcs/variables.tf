
variable "application_name"{
    type = string
}

variable "environment"{
    type = string
}
variable "tfrun_identifier"{
    type = string
}

variable "az_list"{
    type = list(string)
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
variable "public_subnet"{
        type = string
}
variable "private_subnet"{
        type = string
}

variable "vpc_cidr_frontend"{
    type = string
}
variable "vpc_cidr_backend"{
    type = string
}
