
output "application-name"{
    description = "name of the application"
    value = var.application_name
}

output "environment"{
    description = "Dev Val Prod"
    value = var.environment
}

output "app-vpcs"{
    description = "id of app vpcs"
    value = module.app-vpcs.app_vpcs
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
    value = module.app-tgw.fe-be-tgw.id
}


#output userdata {
#  value = "\n${data.template_file.cloud-init-frontent.yaml.rendered}"
#}