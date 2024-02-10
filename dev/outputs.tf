// Print nice MAP of InstanceID: PublicIP
#output "server_all" {
#  value = {
#    for server in aws_instance.servers :
#    server.id => server.public_ip // "i-0490f049844513179" = "99.79.58.22"
#  }
#}



output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.ecs.id
}

output "instance_public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.ecs.public_ip
}

output "instance_private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.ecs.private_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_endpoint" {
description = "The DNS resolution endpoint of the VPC"
value       = aws_vpc.main.dhcp_options_id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = aws_subnet.main.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.my_webserver.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.my_webserver.name
}