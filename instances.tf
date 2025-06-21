resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  key_name                    = var.bastion_key
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  tags = {
    Name = "danik-bastion-host"
  }
}