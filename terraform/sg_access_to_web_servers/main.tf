terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_security_group" "access_to_web_servers" {
  vpc_id   = var.vpc_id
  name     = "Access_To_WebServers"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_for_jumpbox" {
  description       = "Allow SSH from the JumpBox"
  security_group_id = aws_security_group.access_to_web_servers.id
  cidr_ipv4         = var.jumpbox_public_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_anywhere" {
  description       = "Allow HTTP from any IP address"
  security_group_id = aws_security_group.access_to_web_servers.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}