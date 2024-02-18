

output "app-vpcs"{
    description = "id of app vpcs"
    value = [aws_vpc.custom_vpc_fe.id, aws_vpc.custom_vpc_be.id]
}
