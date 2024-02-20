
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
    value = [module.application_vpcs.app_fe_vpc_id,module.application_vpcs.app_be_vpc_id ]
}

output "fe_vpc"{
    value = module.application_vpcs.app_fe_vpc_id
}
output "be_vpc"{
    value = module.application_vpcs.app_be_vpc_id
}


output "frontend-nodes-id" {
    description = "list of front end nodes private IP addresses"
    value = module.application_instances.frontend-nodes-id
}
output "backend-nodes-id" {
    description = "list of back end nodes private IP addresses"
    value = module.application_instances.backend-nodes-id
} 

output "frontend-nodes-private-ips" {
    description = "list of front end nodes private IP addresses"
    value = module.application_instances.frontend-nodes-private-ips
}
output "backend-nodes-private-ips" {
    description = "list of back end nodes private IP addresses"
    value = module.application_instances.backend-nodes-private-ips
}

output "frontend-nodes-public-ips" {
    description = "list of front end nodes private IP addresses"
    value = module.application_instances.frontend-nodes-public-ips
}
output "backend-nodes-public-ips" {
    description = "list of back end nodes private IP addresses"
    value = module.application_instances.backend-nodes-public-ips

}

output "transit-gateway-id"{
    description = "id of the tgw of the application in use "
    value = "${var.skip_mcd==true ? "" : module.application_transitgateway.transit-gateway-id}"
}


#output userdata {
#  value = "\n${data.template_file.cloud-init-frontent.yaml.rendered}"
#}