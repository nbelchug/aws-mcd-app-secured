output "app_private_subnet_id"{
    value = aws_subnet.private_subnet
}

output "app_public_subnet_id"{
    value = aws_subnet.public_subnet
}