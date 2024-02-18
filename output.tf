
output "application-name"{
    description = "name of the application"
    value = var.application_name
}

output "environment"{
    description = "Dev Val Prod"
    value = var.environment
}

output "app-vpcs-list"{
    description = "id of app vpcs"
    value = module.app-vpcs.app_vpcs_list
}

output "fe_vpc"{
    value = module.app-vpcs.app_fe_vpc_id
}
output "be_vpc"{
    value = module.app-vpcs.app_be_vpc_id
}

output "public-subnet"{
    value = module.app-vpcs.app-public-subnet-id
}

output "private-subnet"{
    value = module.app-vpcs.app-private-subnet-id
}

output "frontend-nodes-id" {
    description = "list of front end nodes private IP addresses"
    value = module.app-instances.frontend-nodes-id
}
output "backend-nodes-id" {
    description = "list of back end nodes private IP addresses"
    value = module.app-instances.backend-nodes-id
} 

output "frontend-nodes-private-ips" {
    description = "list of front end nodes private IP addresses"
    value = module.app-instances.frontend-nodes-private-ips
}
output "backend-nodes-private-ips" {
    description = "list of back end nodes private IP addresses"
    value = module.app-instances.backend-nodes-private-ips
}

output "frontend-nodes-public-ips" {
    description = "list of front end nodes private IP addresses"
    value = module.app-instances.frontend-nodes-public-ips
}
output "backend-nodes-public-ips" {
    description = "list of back end nodes private IP addresses"
    value = module.app-instances.backend-nodes-public-ips

}

output "transit-gateway-id"{
    description = "id of the tgw of the application in use "
    value = module.app-tgw.transit-gateway-id
}


#output userdata {
#  value = "\n${data.template_file.cloud-init-frontent.yaml.rendered}"
#}