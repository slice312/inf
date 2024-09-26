output "servers_ips" {
  value = {
    (aws_instance.jump_box.tags["Name"])     = aws_instance.jump_box.public_ip,
    (aws_instance.web_server_1.tags["Name"]) = aws_instance.web_server_1.public_ip,
    (aws_instance.web_server_2.tags["Name"]) = aws_instance.web_server_2.public_ip
  }
}