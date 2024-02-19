output "app_private_subnet_id"{
    value = aws_subnet.private_subnet
}

output "app_public_subnet_id"{
    value = aws_subnet.public_subnet
}

output "app_fe_vpc_id" {
    value = aws_vpc.custom_vpc_fe.id
}

output "app_be_vpc_id" {
    vaslue = aws_vpc.custom_vpc_be.id
}

output "app_fe_cidr_block"{
    value = aws_vpc.custom_vpc_fe.cidr_block
}

output "app_be_cidr_block"{
    value = aws_vpc.custom_vpc_be.cidr_block
}
