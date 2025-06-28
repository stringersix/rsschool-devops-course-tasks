output "bastion_public_ip" {
  description = "Public Ip for Bastion-NAT instance"
  value       = aws_instance.bastion_nat.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet Ids"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_instance_ips" {
  description = "List of private instances ip"
  value       = [aws_instance.private_instance_1.private_ip]
}

output "public_instance_ips" {
  description = "List of public instances ip"
  value       = [aws_instance.public_instance_2.private_ip]
}

output "public_instance_public_ips" {
  description = "List of public instances public ip"
  value       = [aws_instance.public_instance_2.public_ip]
}