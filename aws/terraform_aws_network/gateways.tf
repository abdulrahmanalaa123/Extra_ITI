
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "iti_igw"
  }
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.subnets["public_subnet"].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.main_igw]
}