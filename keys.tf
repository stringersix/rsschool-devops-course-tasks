resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "inner_key" {
  key_name   = "inner-key"
  public_key = tls_private_key.generated_key.public_key_openssh
}

output "private_instances_private_ips" {
  value = [

    aws_instance.private_1.private_ip,
  ]
  description = "Private IP addresses of private instances"
}