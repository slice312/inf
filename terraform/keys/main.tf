provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-1"
}

locals {
  key_name   = "main_server_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICChMNNqLJZ+G+JokEVXJCDxMboTlWmYDOpnZEt3Y0v8"
}

resource "aws_key_pair" "main_server_key_east" {
  provider   = aws.us_east
  key_name   = local.key_name
  public_key = local.public_key
}

resource "aws_key_pair" "main_server_key_west" {
  provider   = aws.us_west
  key_name   = local.key_name
  public_key = local.public_key
}