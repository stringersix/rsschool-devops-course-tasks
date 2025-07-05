# Create bastion-nat instance
resource "aws_instance" "bastion_nat" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id
  key_name      = var.bastion_key

  source_dest_check = false

  user_data = templatefile("${path.module}/bash/setup-bastion.sh.tpl", {
    private_key = tls_private_key.generated_key.private_key_pem
    master_ip   = aws_instance.master.private_ip
  })

  security_groups = [aws_security_group.bastion_nat_sg.id]

  tags = {
    Name = "donik-bastion-nat"
  }
  depends_on = [aws_instance.master]
}

# Public instance in public-2 subnet
# resource "aws_instance" "public_instance_2" {
#   ami                         = data.aws_ami.amazon_linux_2.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_2.id
#   vpc_security_group_ids      = [aws_security_group.public_instance.id]
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.inner_key.key_name

#   user_data = file("${path.module}/bash/setup-webserver.sh")

#   tags = {
#     Name = "donik-public-instance-2"
#   }
# }

# Private instance in private-1 subnet
resource "aws_instance" "master" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.private_instance.id]
  key_name               = aws_key_pair.inner_key.key_name
  user_data              =  templatefile("${path.module}/bash/setup-k3s-master.sh.tpl", {
    region          = var.aws_region
    ssm_token_param = "/k3s/token"
  })

  iam_instance_profile   = aws_iam_instance_profile.k3s_master_instance_profile.name
  tags = {
    Name = "donik-private-instance-master"
  }
}

# Private instance in private-1 subnet
resource "aws_instance" "agent" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.private_instance.id]
  key_name               = aws_key_pair.inner_key.key_name
  depends_on             = [aws_instance.master]

  user_data = templatefile("${path.module}/bash/setup-k3s-agent.sh.tpl", {
    master_ip       = aws_instance.master.private_ip
    ssm_token_param = "/k3s/token"
    region          = var.aws_region
  })

  iam_instance_profile   = aws_iam_instance_profile.k3s_agent_instance_profile.name
  tags = {
    Name = "donik-private-instance-agent"
  }
}