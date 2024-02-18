

output "app_vpcs_list"{
    description = "id of app vpcs"
    value = [aws_vpc.custom_vpc_fe.id, aws_vpc.custom_vpc_be.id]
}

output "app_fe_vpc_id"{
    value = aws_vpc.custom_vpc_fe.id
}

output "app_be_vpc_id"{
    value =aws_vpc.custom_vpc_be.id
}

output "app-public-subnet-id"{
    description = "ids of app frontend subnets in front end vpc"
    value = aws_vpc.public_subnet.id
}

output "app-private-subnet-id"{
    description = "ids of app backend subnets in backend end vpc"
    value = aws_vpc.private_subnet.id
}

output "app_fe_vpc_cidr_block"{
    value = aws_vpc.custom_vpc_fe.cidr_block
}
output "app_be_vpc_cidr_block"{
    value = aws_vpc.custom_vpc_be.cidr_block
}
