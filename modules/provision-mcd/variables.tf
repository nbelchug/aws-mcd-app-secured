variable "service_vpc_subnet" {
    description = "subnet used in Service VPC"
    type = string 
    default = "10.254.0.0/24"

}

variable "csp_account_name"{
    type = string
}


variable "app_vpcs" {
    description = "List of VPCs to import in MCD"   
    default = ["1","2"]
}

