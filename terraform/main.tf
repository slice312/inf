terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-1"
}


module "key_pairs" {
  source = "./keys"
}


data "aws_vpc" "default_east" {
  provider = aws.us_east
  default  = true
}

data "aws_vpc" "default_west" {
  provider = aws.us_west
  default  = true
}


module "sg_access_to_web_servers_east" {
  source = "./sg_access_to_web_servers"

  providers = {
    aws = aws.us_east
  }
  vpc_id            = data.aws_vpc.default_east.id
  jumpbox_public_ip = "${aws_instance.jump_box.public_ip}/32"
}

module "sg_access_to_web_servers_west" {
  source = "./sg_access_to_web_servers"

  providers = {
    aws = aws.us_west
  }
  vpc_id            = data.aws_vpc.default_west.id
  jumpbox_public_ip = "${aws_instance.jump_box.public_ip}/32"
}


resource "aws_security_group" "access_to_jumpbox" {
  provider = aws.us_east
  vpc_id   = data.aws_vpc.default_east.id
  name     = "Access_To_JumpBox"

  ingress {
    description = "Allow SSH from AWS EC2_INSTANCE_CONNECT Service"
    cidr_blocks = ["18.206.107.24/29"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
}



resource "aws_security_group" "ssh_access_to_web_servers" {
  provider = aws.us_east
  vpc_id   = data.aws_vpc.default_east.id
  name     = "SSH_Access_To_WebServers"

  egress {
    description = ""
    cidr_blocks = ["${aws_instance.web_server_1.public_ip}/32", "${aws_instance.web_server_2.public_ip}/32"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
}


resource "aws_instance" "jump_box" {
  provider                    = aws.us_east
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  security_groups = [
    aws_security_group.access_to_jumpbox.name,
    aws_security_group.ssh_access_to_web_servers.name
  ]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name   = "JumpBox"
    Target = "test-ec2-part1"
  }
}



resource "aws_instance" "web_server_1" {
  provider                    = aws.us_east
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = module.key_pairs.name_us_east

  security_groups = [module.sg_access_to_web_servers_east.name]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name   = "web_server_1"
    Target = "test-ec2-part1"
  }
}




resource "aws_instance" "web_server_2" {
  provider                    = aws.us_west
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = module.key_pairs.name_us_west

  security_groups = [module.sg_access_to_web_servers_west.name]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "web_server_2"
  }
}
