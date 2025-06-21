# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "donik-network"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "donik-igw"
  }
}


# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.azs[0]

  tags = {
    Name = "donik-subnet-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.azs[1]

  tags = {
    Name = "donik-subnet-private-2"
  }
}

# Private route table (local)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.bastion_nat.id
  }

  tags = {
    Name = "donik-private-rt"
  }
}

# Attach private route table to subnets
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}


# Attach NACL to private subnets
resource "aws_network_acl_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  network_acl_id = aws_network_acl.main.id
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "donik-subnet-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "donik-subnet-public-2"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "donik-public-rt"
  }
}

# Attach public route table to subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Attach NACL to public subnets
resource "aws_network_acl_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  network_acl_id = aws_network_acl.main.id
}

