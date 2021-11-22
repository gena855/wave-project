# Internet VPC
resource "aws_vpc" "wave-vpc" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "wave-vpc"
  }
}

# Subnets
resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.wave-vpc.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.wave-vpc.id
  cidr_block              = "10.10.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id                  = aws_vpc.wave-vpc.id
  cidr_block              = "10.10.20.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id                  = aws_vpc.wave-vpc.id
  cidr_block              = "10.10.21.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "private-subnet-b"
  }
}

# Internet GW
resource "aws_internet_gateway" "wave-gw" {
  vpc_id = aws_vpc.wave-vpc.id

  tags = {
    Name = "wave-gw"
  }
}

# route tables
resource "aws_route_table" "public-subnets" {
  vpc_id = aws_vpc.wave-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wave-gw.id
  }

  tags = {
    Name = "public-subnets"
  }
}

# route associations public
resource "aws_route_table_association" "public-subnet-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-subnets.id
}

resource "aws_route_table_association" "public-subnet-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-subnets.id
}
