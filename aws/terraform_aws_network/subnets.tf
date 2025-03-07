resource "aws_subnet" "subnets" {
  for_each   = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = each.value.cidr
  tags = {
    Name = each.value.name
  }
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = each.value.public == true ? each.value.public : false
}
