variable "vpc_cidr_frontend"{
    type = string
}
variable "vpc_cidr_backend"{
    type = string
}

variable "application_name"{
    type = string
}

variable "environment"{
    type = string
}

variable "az_list"{
    type = list(string)
}
variable "public_subnet"{
        type = string
}
variable "private_subnet"{
        type = string
}