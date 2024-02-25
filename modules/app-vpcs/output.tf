output "app_private_subnet_id"{
    value = aws_subnet.private_subnet.id
}

output "app_public_subnet_id"{
    value = aws_subnet.public_subnet.id
}

output "app_fe_vpc_id" {
    value = aws_vpc.custom_vpc_fe.id
}

output "app_be_vpc_id" {
    value = aws_vpc.custom_vpc_be.id
}

output "app_fe_cidr_block"{
    value = aws_vpc.custom_vpc_fe.cidr_block
}

output "app_be_cidr_block"{
    value = aws_vpc.custom_vpc_be.cidr_block
}

output "fe-be-peering-connection-id"{
    value = aws_vpc_peering_connection.fe-be-peering.id
}

output "aws_route_table_rt_be" {
    value = aws_route_table.rt_be.id
}

output "aws_route_table_rt_fe" {
    value = aws_route_table.rt_fe.id
}

