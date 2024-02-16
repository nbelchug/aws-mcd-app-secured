
variable "appname"{
    description = "name of application to deploy"
    type        = string
    default     = "TEASHOP"
} 

variable "environment" {
	description ="enviromnet dev val ref prod for the application"
	type = string
	default= "dev"
}


variable "ciscomcd_api_key_file" {
    description = " Key to access cisco MCD"
    type = string
    default = "~/.ssh/TERRAFORM2.json"
    
}
