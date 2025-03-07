resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}
# the default route for the vpc cidr = local is created by default so it doesnt need to be specified
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "association" {
  for_each       = aws_subnet.subnets
  route_table_id = each.value.map_public_ip_on_launch ? aws_route_table.public_route_table.id : aws_route_table.private_route_table.id
  subnet_id      = each.value.id
}