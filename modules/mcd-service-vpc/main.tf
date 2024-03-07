terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
    ciscomcd = {
      source  = "CiscoDevNet/ciscomcd"
      version = "0.2.4"
    }
  }
  required_version = "~> 1.3"
}

resource "ciscomcd_service_vpc" "service_vpc" {
  name             = "mcd-service-vpc"
  csp_account_name = var.csp_account_name_mcd_reg

  availability_zones = [
    var.aws_availability_zone
  ]
  cidr               = "10.100.0.0/16"
  region             = var.aws_region
  transit_gateway_id = var.transit-gateway-id
}

data "aws_key_pair" "aws_ssh_key_pair" {
  key_name = var.aws_ssh_key_pair_name
}

resource "ciscomcd_policy_rule_set" "mcd_egress_rule_set" {
  name = "mcd-egress-policy-ruleset"
}

resource "ciscomcd_policy_rule_set" "mcd_ingress_rule_set" {
  name = "mcd-ingress-policy-ruleset"
}

resource "ciscomcd_gateway" "mcd_gateway_egress" {
  name                   = "mcd-egress-gw-01"
  vpc_id                 = ciscomcd_service_vpc.service_vpc.id
  aws_iam_role_firewall  = "ciscomcd-gateway-role"
  csp_account_name       = var.csp_account_name_mcd_reg
  gateway_image          = "23.10-03" // Via MCD admin portal **Administration** / **System**
  instance_type          = "AWS_M5_LARGE"
  max_instances          = 1
  min_instances          = 1
  mode                   = "HUB"
  policy_rule_set_id     = ciscomcd_policy_rule_set.mcd_egress_rule_set.id
  region                 = var.aws_region
  security_type          = "EGRESS"
  ssh_key_pair           = data.aws_key_pair.aws_ssh_key_pair.key_name
  gateway_state          = "ACTIVE"
  wait_for_gateway_state = true
  depends_on = [
    ciscomcd_service_vpc.service_vpc,
    ciscomcd_policy_rule_set.mcd_egress_rule_set
  ]
}

resource "ciscomcd_gateway" "mcd_gateway_ingress" {
  name                   = "mcd-ingress-gw-01"
  vpc_id                 = ciscomcd_service_vpc.service_vpc.id
  aws_iam_role_firewall  = "ciscomcd-gateway-role"
  csp_account_name       = var.csp_account_name_mcd_reg
  gateway_image          = "23.10-03" // Via MCD admin portal **Administration** / **System**
  instance_type          = "AWS_M5_LARGE"
  max_instances          = 1
  min_instances          = 1
  mode                   = "HUB"
  policy_rule_set_id     = ciscomcd_policy_rule_set.mcd_ingress_rule_set.id
  region                 = var.aws_region
  security_type          = "INGRESS"
  ssh_key_pair           = data.aws_key_pair.aws_ssh_key_pair.key_name
  gateway_state          = "ACTIVE"
  wait_for_gateway_state = true
  depends_on = [
    ciscomcd_service_vpc.service_vpc,
    ciscomcd_policy_rule_set.mcd_ingress_rule_set
  ]
}

output "mcd_service_vpc_id" {
  value = ciscomcd_service_vpc.service_vpc.id
}

data "aws_lb" "mcd-ingress-igw" {
  # name = ciscomcd_gateway.mcd_gateway_ingress.aws_gateway_lb
  tags = { "valtix_gateway":"mcd-ingress-gw-01"}
  depends_on = [
    ciscomcd_gateway.mcd_gateway_ingress
  ]
}

output "mcd-ingress-igw-fqdn"{
  value = data.aws_lb.mcd-ingress-igw.dns_name
}

# Attach fe, be vpc to egress gw
# Attach fe to ingress gw

resource "ciscomcd_spoke_vpc" "mcd_spok_fe" {
  service_vpc_id = ciscomcd_service_vpc.service_vpc.id
  spoke_vpc_id   = var.app_fe_vpc_id
}

resource "ciscomcd_spoke_vpc" "mcd_spoke_be" {
  service_vpc_id = ciscomcd_service_vpc.service_vpc.id
  spoke_vpc_id   = var.app_be_vpc_id
}

resource "ciscomcd_address_object" "tea-shop-fe-rp" {
  name            = "tea-shop-fe-rp"
  description     = "Static tea-shop-fe IP reverse proxy type"
  type            = "STATIC"
  value           = var.frontend-nodes-private-ips
  backend_address = true
}

resource "ciscomcd_address_object" "tea-shop-be-rp" {
  name            = "tea-shop-be-rp"
  description     = "Static tea-shop-fe IP reverse proxy type"
  type            = "STATIC"
  value           = var.backend-nodes-private-ips
  backend_address = true
}

resource "ciscomcd_address_object" "tea-shop-be" {
  name        = "tea-shop-be"
  description = "Static tea-shop-be IP"
  type        = "STATIC"
  value       = var.backend-nodes-private-ips
}

resource "ciscomcd_address_object" "tea-shop-fe" {
  name        = "tea-shop-fe"
  description = "Static tea-shop-fe IP"
  type        = "STATIC"
  value       = var.frontend-nodes-private-ips
}

resource "ciscomcd_service_object" "tea-shop-fe-ssh" {
  name           = "tea-shop-fe-ssh"
  service_type   = "ReverseProxy"
  protocol       = "TCP"
  transport_mode = "TCP"
  port {
    destination_ports = "8022"
    backend_ports     = "22"
  }
  backend_address_group = ciscomcd_address_object.tea-shop-fe-rp.id
}

resource "ciscomcd_service_object" "tea-shop-be-ssh" {
  name           = "tea-shop-be-ssh"
  service_type   = "ReverseProxy"
  protocol       = "TCP"
  transport_mode = "TCP"
  port {
    destination_ports = "8122"
    backend_ports     = "22"
  }
  backend_address_group = ciscomcd_address_object.tea-shop-be-rp.id
}

resource "ciscomcd_service_object" "tea-shop-fe-services" {
  name           = "tea-shop-fe-services"
  service_type   = "ReverseProxy"
  protocol       = "TCP"
  transport_mode = "TCP"
  port {
    destination_ports = "8080"
    backend_ports     = "8080"
  }
  backend_address_group = ciscomcd_address_object.tea-shop-fe-rp.id
}

resource "ciscomcd_service_object" "tea-shop-be-services-1" {
  name           = "tea-shop-be-services-1"
  service_type   = "Forwarding"
  transport_mode = "HTTP"
  port {
    destination_ports = "10000"
  }
  source_nat = false
}

resource "ciscomcd_service_object" "tea-shop-be-services-2" {
  name           = "tea-shop-be-services-2"
  service_type   = "Forwarding"
  transport_mode = "HTTP"
  port {
    destination_ports = "3306"
  }
  source_nat = false
}

# EGRESS RULES

resource "ciscomcd_policy_rules" "egress_policy_rules" {
  rule_set_id = ciscomcd_policy_rule_set.mcd_egress_rule_set.id
  rule {
    name        = "back-end-services-1"
    state       = "ENABLED"
    action      = "Allow Log"
    destination = ciscomcd_address_object.tea-shop-be.id
    type        = "Forwarding"
    service     = ciscomcd_service_object.tea-shop-be-services-1.id
    source      = ciscomcd_address_object.tea-shop-fe.id
  }
  rule {
    name        = "back-end-services-2"
    state       = "ENABLED"
    action      = "Allow Log"
    destination = ciscomcd_address_object.tea-shop-be.id
    type        = "Forwarding"
    service     = ciscomcd_service_object.tea-shop-be-services-2.id
    source      = ciscomcd_address_object.tea-shop-fe.id
  }
  depends_on = [
    ciscomcd_gateway.mcd_gateway_egress
  ]
}

# INGRESS RULES

resource "ciscomcd_policy_rules" "ingress_policy_rules" {
  rule_set_id = ciscomcd_policy_rule_set.mcd_ingress_rule_set.id
  rule {
    name    = "ssh-front-end"
    state   = "ENABLED"
    action  = "Allow Log"
    type    = "ReverseProxy"
    service = ciscomcd_service_object.tea-shop-fe-ssh.id
  }
  rule {
    name    = "ssh-backend-end"
    state   = "ENABLED"
    action  = "Allow Log"
    type    = "ReverseProxy"
    service = ciscomcd_service_object.tea-shop-be-ssh.id
  }
  rule {
    name    = "ssh-front-end-services"
    state   = "ENABLED"
    action  = "Allow Log"
    type    = "ReverseProxy"
    service = ciscomcd_service_object.tea-shop-fe-services.id
  }
  depends_on = [
    ciscomcd_gateway.mcd_gateway_ingress
  ]
}

# Replace routes of spoke VPC - FE


resource "aws_default_route_table" "app_fe_vpc_rt" {
  default_route_table_id = var.aws_route_table_rt_fe

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.transit-gateway-id
  }
}

# Replace routes of spoke VPC - BE

resource "aws_default_route_table" "app_be_vpc_rt" {
  default_route_table_id = var.aws_route_table_rt_be

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.transit-gateway-id
  }
}
