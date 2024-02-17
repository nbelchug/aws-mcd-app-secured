
output "application-name"{
    description = "name of the application"
    value = var.application_name
}


output "environment"{
    description = "Dev Val Prod"
    value = var.environment
}

output "frontend-nodes-id" {
    description = "list of front end nodes private IP addresses"
    value = aws_instance.ec2_frontend.id
}
output "backend-nodes-id" {
    description = "list of back end nodes private IP addresses"
    value = aws_instance.ec2_backend.id
} 

output "frontend-nodes" {
    description = "list of front end nodes private IP addresses"
    value = aws_instance.ec2_frontend.private_ip
}
output "backend-nodes" {
    description = "list of back end nodes private IP addresses"
    value = aws_instance.ec2_backend.private_ip
}

output "frontend-nodes-public" {
    description = "list of front end nodes private IP addresses"
    value = aws_instance.ec2_frontend.public_ip
}
output "backend-nodes-public" {
    description = "list of back end nodes private IP addresses"
    value = aws_instance.ec2_backend.public_ip
}



#output userdata {
#  value = "\n${data.template_file.cloud-init-frontent.yaml.rendered}"
#}