
output "transit-gateway-id"{
    description = "id of the tgw of the application in use "
    value = aws_ec2_transit_gateway.fe-be-tgw.id
}
