# --- root/Terraform_projects/terraform_two_tier_architecture/main.tf

# ************************************************************
# Description: two-tier architecture with terraform
# - file name: main.tf
# - custom VPC
# - 1 public subnets in different AZs for high availability
# - 1 private subnets in different AZs
# - 1 EC2 t2.micro instance in each public subnet
# ************************************************************

# PROVIDER BLOCK

# VPC BLOCK
# creating VPC

resource "aws_vpc" "custom_vpc_fe" {
   cidr_block       = var.vpc_cidr_frontend

   enable_dns_hostnames = true
   enable_dns_support   = true

   tags = {
      Name = "mcd-demo-teashop-frontend"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment
   }
}

resource "aws_vpc" "custom_vpc_be" {
   cidr_block       = var.vpc_cidr_backend

   enable_dns_hostnames = true
   enable_dns_support   = true

   tags = {
      Name = "mcd-demo-teashop-backend"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment

   }
}
# -----------------------------------------------
# SUBNETS - PUBLIC SUBNET IN FE VPC
# public subnet 
resource "aws_subnet" "public_subnet" {   
   vpc_id            = aws_vpc.custom_vpc_fe.id
   cidr_block        = var.public_subnet
   availability_zone = var.az1

   tags = {
      Name = "mcd-demo-teashop-frontend-subnet"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment

   }
}
# -----------------------------------------------
# SUBNETS - PRIVATE SUBNET IN BE VPC
# private subnet
resource "aws_subnet" "private_subnet" {   
   vpc_id            = aws_vpc.custom_vpc_be.id
   cidr_block        = var.private_subnet
   availability_zone = var.az1

   tags = {
      Name = "mcd-demo-teashop-backend-subnet"
      Tier = "back-end"
      Application = var.application_name
      Environment = var.environment

   }
}

# ------------------------------------------------------  
# INTERNET GATEWAYS
# creating internet gateway for Front End
resource "aws_internet_gateway" "igw_fe" {
   vpc_id = aws_vpc.custom_vpc_fe.id

   tags = {
      Name = "mcd-demo-teashop-frontend-igw"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment

   }
} 

# creating internet gateway for Back End
resource "aws_internet_gateway" "igw_be" {
   vpc_id = aws_vpc.custom_vpc_be.id

   tags = {
      Name = "mcd-demo-teashop-backend-igw"
      Tier = "back-end"
      Application = var.application_name
      Environment = var.environment

   }
} 

# ---------------------------------------------
# ROUTE TABLES - FRONTEND
# creating route table for Front End - Allow 0/0 in as it needs to be provisioned by TF
resource "aws_route_table" "rt_fe" {
   vpc_id = aws_vpc.custom_vpc_fe.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw_fe.id
  }


   tags = {
      Name = "mcd-demo-teashop-fe-to-tgw-and-igw-rt"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment

  }
}
# ---------------------------------------------------
# ROUTE TABLES - BACKEND
# creating route table for Back End - Allow 0/0 in as it needs to be provisioned by TF
resource "aws_route_table" "rt_be" {
   vpc_id = aws_vpc.custom_vpc_be.id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw_be.id
  }
 
   
   tags = {
      Name = "mcd-demo-teashop-be-to-tgw-and-igw-rt"
      Tier = "back-end"
      Application = var.application_name
      Environment = var.environment

  }
}

# ---------------------------------------------------
# ROUTE TABLE ASSOCIATIONS
# associate route table to the public subnet
resource "aws_route_table_association" "public_rt" {
   subnet_id      = aws_subnet.public_subnet.id
   route_table_id = aws_route_table.rt_fe.id

}

# associate route table to the private subnet 1
resource "aws_route_table_association" "private_rt" {
   subnet_id      = aws_subnet.private_subnet.id
   route_table_id = aws_route_table.rt_be.id

}



# ----------------------------------------------------
# SECURITY GROUPS
# FRONTEND SECURITY GROUP - allow SSH, Allow HTTPS HTTP and PORT 8080 as well backend
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow SSH 8080 inbound traffic and all outbound traffic, allow 3306 and 8080 to backend"
  vpc_id      = aws_vpc.custom_vpc_fe.id

  tags = {
    Name = "mcd-demo-teashop-frontend-sg"
    Tier = "front-end"
    Application = var.application_name
   Environment = var.environment

  }
}

# -----------------------------------------------------
# SECURITY GROUP - RULES FOR FE NODES
resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_frontend" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#resource "aws_vpc_security_group_ingress_rule" "allow_in_3306_ipv4_frontend" {
#  security_group_id = aws_security_group.frontend_sg.id
#  cidr_ipv4         = "0.0.0.0/0"
#  from_port         = 3306
#  ip_protocol       = "tcp"
#  to_port           = 3306
#}
resource "aws_vpc_security_group_ingress_rule" "allow_in_8080_ipv4_frontend" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_frontend" {
   security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
   ip_protocol       = "icmp"
   from_port         = -1
   to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_frontend" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#-----------------------------------------------------------------
# SECURITY GROUP - RULES FOR BE NODES
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow  SSH DB 8080 inbound traffic and outbound to public subnet"
  vpc_id      = aws_vpc.custom_vpc_be.id

  tags = {
   Name = "mcd-demo-teashop-backend-sg"
   Tier = "back-end"
   Application = var.application_name
   Environment = var.environment

  }
}

#resource "aws_vpc_security_group_ingress_rule" "allow_in_any_ipv4_backend" {
#  security_group_id = aws_security_group.backend_sg.id
#  cidr_ipv4         = "0.0.0.0/0"
#  ip_protocol       = -1
#}

 resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_in_3306_ipv4_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_ingress_rule" "allow_in_8080_ipv4_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = aws_vpc.custom_vpc_fe.cidr_block
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_backend" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = aws_vpc.custom_vpc_be.cidr_block
  ip_protocol       = "icmp"
   from_port         = -1
   to_port           = -1
}
resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_backend" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#-----------------------------------------------------------------
# INSTANCES OF EC2 VIRTUAL MACHINES - BACKEND FIRST
 # 1st ec2 instance on private subnet 1 - REGISTRY & DB
resource "aws_instance" "ec2_backend" {
   ami                     = var.ec2_instance_ami
   instance_type           = var.ec2_instance_type
   availability_zone       = var.az1
   subnet_id               = aws_subnet.private_subnet.id
   key_name                = "terraform-key-devops-admin"
   associate_public_ip_address = true

   vpc_security_group_ids  = [aws_security_group.backend_sg.id]
   root_block_device {
      volume_size = 30 # in GB 
      volume_type = "gp3"
      encrypted   = false
   } 
   tags = {
      Name = "mcd-demo-teashop-backend"
      Tier = "front-end"
      Application = var.application_name
      Environment = var.environment

   } 

   user_data = file("${path.module}/cloud-init-backend.yaml")

   #connection {
   #   type     = "ssh"
   #   user     = "ec2-user"
   #   private_key = "${file("~/.ssh/terraform-key-devops-admin.pem")}"
   #   host     = self.public_ip
   #}

   #provisioner "file"{
   #   source = "${path.module}/backend.sh"
   #   destination = "/tmp/backend.sh"
   #}

   #provisioner "remote-exec" {
   #   inline = [ "export BACKENDIP=${aws_instance.ec2_backend.private_ip}",
   #   "BACKENDIP=${aws_instance.ec2_backend.private_ip}",
   #   "chmod a+x /tmp/backend.sh",
   #   "/tmp/backend.sh"
   #   ]
   #}
}

resource "null_resource" "backend-config"{ 
   triggers = {
      configfile = templatefile (   "${path.module}/backend.sh" , 
                                    {backendip = aws_instance.ec2_backend.private_ip}
      )
   }

   provisioner "file" {
    content     = self.triggers.configfile
    destination = "/tmp/backend.sh"
   }

   provisioner "remote-exec" {
      inline = ["sudo chmod 770 /tmp/backend.sh",
               "/tmp/backend.sh",]

   }
   connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/terraform-key-devops-admin.pem")}"
      host        = aws_instance.ec2_backend.public_ip

   }
}

#----------------------------------------------------------------------------------
# INSTANCES BLOCK - EC2 and DATABASE
resource "aws_instance" "ec2_frontend" {
   ami                     = var.ec2_instance_ami
   instance_type           = var.ec2_instance_type
   availability_zone       = var.az1
   subnet_id               = aws_subnet.public_subnet.id
   key_name                = "terraform-key-devops-admin"

   private_dns_name_options {
    hostname_type = "resource-name"
   }

   associate_public_ip_address = true
   vpc_security_group_ids  = [aws_security_group.frontend_sg.id]
   root_block_device {
      volume_size = 30 # in GB 
       volume_type = "gp3"
      encrypted   = false
   } 
   tags = {
      Name = "mcd-demo-teashop-frontend"
      Tier = "back-end"
      Application = var.application_name
      Environment = var.environment

   }


   user_data = file("${path.module}/cloud-init-frontend.yaml")

#   connection {
#      type     = "ssh"
#      user     = "ec2-user"
#      private_key = "${file("~/.ssh/terraform-key-devops-admin.pem")}"
#      host     = self.public_ip
#   }

#   provisioner "file"{
#      source = "${path.module}/frontend.sh"
#      destination = "/tmp/frontend.sh"
#
#   }

#   provisioner "remote-exec" {
#      inline = [ "export BACKENDIP=${aws_instance.ec2_backend.private_ip}",
#      "BACKENDIP=${aws_instance.ec2_backend.private_ip}",
#      "chmod a+x /tmp/frontend.sh",
#      "/tmp/frontend.sh"
#      ]
#   } 

}

resource "null_resource" "frontend-config"{
   triggers = {
      configfile = templatefile (   "${path.module}/frontend.sh" , 
                                    {backendip = aws_instance.ec2_backend.private_ip
                                    ownip = aws_instance.ec2_frontend.private_ip}
      )
   }

   provisioner "file" {
    content     = self.triggers.configfile
    destination = "/tmp/frontend.sh"
   }
   provisioner "remote-exec" {
      inline = ["chmod a+x /tmp/frontend.sh",
               "echo 'COMMAND: /tmp/frontend.sh ${aws_instance.ec2_backend.private_ip}'",
               "/tmp/frontend.sh ${aws_instance.ec2_backend.private_ip}",]

   }

   connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/terraform-key-devops-admin.pem")}"
      host        = aws_instance.ec2_frontend.public_ip

   }
}


#----------------------------------------
# TRANSIT GATEWAYS ACROSS FE AND BE VPCs
resource "aws_ec2_transit_gateway" "fe-be-tgw" {
  description                     = "Transit Gateway between FE and BE for app"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags                           = {
    Name                         = "mcd-demo-teashop-fe-be-tgw"
    Application                  = var.application_name
    Environment                  = var.environment
  }
}
#----------------------------------------
# TRANSIT GATEWAYS ATTACHMENT BETWEEN FE AND TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-fe" {
   subnet_ids         = [aws_subnet.public_subnet.id]
   transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
   vpc_id             = aws_vpc.custom_vpc_fe.id
   transit_gateway_default_route_table_association = true
   transit_gateway_default_route_table_propagation = true
   tags               = {
      Name             = "mcd-demo-tgw-att-vpc-fe"
      Application   = var.application_name
      Tier          = "front-end"
  }
  depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
}
#----------------------------------------
# TRANSIT GATEWAYS ATTACHMENT BETWEEN BE AND TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-be" {
  subnet_ids         = [aws_subnet.private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.fe-be-tgw.id
  vpc_id             = aws_vpc.custom_vpc_be.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags               = {
      Name             = "mcd-demo-tgw-att-vpc-be"
      Application   = var.application_name
      Tier          = "back-end"
  }
  depends_on = [aws_ec2_transit_gateway.fe-be-tgw]
}





#