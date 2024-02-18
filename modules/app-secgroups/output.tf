
output "frontend_sg"{
    value = [aws_security_group.frontend_sg.id]

}

output "backend_sg"{
    value = [aws_security_group.backend_sg.id]
}