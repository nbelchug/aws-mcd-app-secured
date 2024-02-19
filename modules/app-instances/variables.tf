variable "application_name"{
    type = string
}
variable "environment"{
    type = string
}


variable "ec2_instance_ami"{
    type = string
}
variable "ec2_instance_type"{
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

variable "keyname"{
    type = string
}

variable "myapp_private_subnet_id" {
    type = string
}

variable "myapp_public_subnet_id" {
    type = string
}
variable "myfrontend_sg" {
    type = string
}
variable "mybackend_sg" {
    type = string
}