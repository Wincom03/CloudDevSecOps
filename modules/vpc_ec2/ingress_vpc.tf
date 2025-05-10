resource "aws_vpc" "ingress_vpc" { 
  cidr_block       = var.ingress_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "central-ingress-vpc"
  }
}

resource "aws_subnet" "ingress_vpc_public_subnet" {
  count                   = length(var.azs_ingress)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ingress_vpc.id
  availability_zone       = var.azs_ingress[count.index]
  cidr_block              = element(var.ingress_public_subnet_cidr, count.index)
  depends_on              = [aws_internet_gateway.ingress_vpc_igw]
  tags = {
    Name = "central-ingress-vpc/${var.azs_ingress[count.index]}/public-subnet"
  }
}

resource "aws_internet_gateway" "ingress_vpc_igw" {
  vpc_id = aws_vpc.ingress_vpc.id
  tags = {
    Name = "central-ingress-vpc/internet-gateway"
  }
}

resource "aws_route_table" "ingress_vpc_public_subnet_route_table" {
  count  = length(var.azs_ingress)
  vpc_id = aws_vpc.ingress_vpc.id
  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ingress_vpc_igw.id
  }
  tags = {
    Name = "central-ingress-vpc/${var.azs_ingress[count.index]}/public-subnet-route-table"
  }
}

resource "aws_route_table_association" "ingress_vpc_public_subnet_route_table_association" {
  count          = length(var.azs_ingress)
  route_table_id = aws_route_table.ingress_vpc_public_subnet_route_table[count.index].id
  subnet_id      = aws_subnet.ingress_vpc_public_subnet[count.index].id
}

# Updating the default security group with no inbound and outbound to internet
resource "aws_default_security_group" "ingress_sg" {
  vpc_id     = aws_vpc.ingress_vpc.id
  depends_on = [aws_vpc.ingress_vpc]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP address
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from any IP address
  }
  tags = {
    Name        = substr("ingress-sg-${var.environment}", 0, 64)
    Environment = var.environment
  }
}
