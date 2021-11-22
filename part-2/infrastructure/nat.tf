# nat gw
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "wave-nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-a.id
  depends_on    = [aws_internet_gateway.wave-gw]
}

# VPC setup for NAT
resource "aws_route_table" "private-subnet-route" {
  vpc_id = aws_vpc.wave-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wave-nat-gw.id
  }

  tags = {
    Name = "private-subnet-nat-route"
  }
}

# route associations private
resource "aws_route_table_association" "private-subnet-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-subnet-route.id
}

resource "aws_route_table_association" "private-subnet-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-subnet-route.id
}
