# Create bastion-nat instance
resource "aws_instance" "bastion_nat" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id
  key_name      = var.bastion_key

  source_dest_check = false

  user_data = templatefile("${path.module}/setup_bastion.sh.tpl", {
    private_key = tls_private_key.generated_key.private_key_pem
  })

  security_groups = [aws_security_group.bastion_nat_sg.id]

  tags = {
    Name = "donik-bastion-nat"
  }
}

# Public instance in public-2 subnet
resource "aws_instance" "public_instance_2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_2.id
  vpc_security_group_ids      = [aws_security_group.public_instance.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.inner_key.key_name

  tags = {
    Name = "donik-public-instance-2"
  }
}

# Private instance in private-1 subnet
resource "aws_instance" "private_instance_1" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.private_instance.id]
  key_name               = aws_key_pair.inner_key.key_name

  tags = {
    Name = "donik-private-instance-1"
  }
}

# Public instance in public-1 subnet
# resource "aws_instance" "public_instance_1" {
#   ami                         = data.aws_ami.amazon_linux_2.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_1.id
#   vpc_security_group_ids      = [aws_security_group.public_instance.id]
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.inner_key.key_name

#   tags = {
#     Name = "donik-public-instance-1"
#   }
# }

# Private instance in private-1 subnet
# resource "aws_instance" "private_instance_2" {
#   ami                    = data.aws_ami.amazon_linux_2.id
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private_2.id
#   vpc_security_group_ids = [aws_security_group.private_instance.id]
#   key_name               = aws_key_pair.inner_key.key_name

#   tags = {
#     Name = "donik-private-instance-2"
#   }
# }