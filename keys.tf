resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "inner_key" {
  key_name   = "inner-key"
  public_key = tls_private_key.generated_key.public_key_openssh
}