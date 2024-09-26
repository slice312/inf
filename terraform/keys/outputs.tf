output "name_us_east" {
  value = aws_key_pair.main_server_key_east.key_name
}

output "name_us_west" {
  value = aws_key_pair.main_server_key_west.key_name
}