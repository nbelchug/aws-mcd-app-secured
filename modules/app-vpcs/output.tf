

output "app_vpcs"{
    description = "id of app vpcs"
    value = [aws_vpc.custom_vpc_fe.id, aws_vpc.custom_vpc_be.id]
}


output "app-public-subnet-id"{
    description = "ids of app frontend subnets in front end vpc"
    value = aws_vpc.public_subnet.id
}

output "app-private-subnet-id"{
    description = "ids of app backend subnets in backend end vpc"
    value = aws_vpc.private_subnet.id
}
