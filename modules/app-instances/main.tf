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


terraform {
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }


  }
  required_version = "~> 1.3"
}



      #-----------------------------------------------------------------
      # INSTANCES OF EC2 VIRTUAL MACHINES - BACKEND FIRST
      # 1st ec2 instance on private subnet 1 - REGISTRY & DB
      resource "aws_instance" "ec2_backend" {
         ami                     = var.ec2_instance_ami
         instance_type           = var.ec2_instance_type
         availability_zone       = var.az1
         subnet_id               = myapp_private_subnet_id 
      
         key_name                = var.keyname
         associate_public_ip_address = true

         vpc_security_group_ids  = mybackend_sg
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

         provisioner "remote-exec"{
                     inline = ["echo 'connected!'"]
         }
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
               inline = ["sudo chmod 777 /tmp/backend.sh",
                        "sudo /tmp/backend.sh",]

         }
         connection {
               type        = "ssh"
               user        = "ubuntu"
               private_key = "${file("~/.ssh/${var.keyname}.pem")}"
               host        = aws_instance.ec2_backend.public_ip

            }
      
      }



      #----------------------------------------------------------------------------------
      # INSTANCES BLOCK - EC2 FOR FRONTEND 
      resource "aws_instance" "ec2_frontend" {
         ami                     = var.ec2_instance_ami
         instance_type           = var.ec2_instance_type
         availability_zone       = var.az1
         subnet_id               = myapp_public_subnet_id
         key_name                = var.keyname

         private_dns_name_options {
         hostname_type = "resource-name"
         }

         associate_public_ip_address = true
         vpc_security_group_ids  = myfrontend_sg
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
            user        = "ubuntu"
            private_key = "${file("~/.ssh/${var.keyname}.pem")}"
            host        = aws_instance.ec2_frontend.public_ip

         }
      }
