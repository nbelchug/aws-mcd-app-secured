
output "frontend-nodes-id" {
    description = "list of front end nodes private IP addresses"
    value = [aws_instance.ec2_frontend.id]
}
output "backend-nodes-id" {
    description = "list of back end nodes private IP addresses"
    value = [aws_instance.ec2_backend.id]
} 

output "frontend-nodes-private-ips" {
    description = "list of front end nodes private IP addresses"
    value = [aws_instance.ec2_frontend.private_ip]
}
output "backend-nodes-private-ips" {
    description = "list of back end nodes private IP addresses"
    value = [aws_instance.ec2_backend.private_ip]
}

output "frontend-nodes-public-ips" {
    description = "list of front end nodes private IP addresses"
    value = [aws_instance.ec2_frontend.public_ip]
}
output "backend-nodes-public-ips" {
    description = "list of back end nodes private IP addresses"
    value = [aws_instance.ec2_backend.public_ip]
}

