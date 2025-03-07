resource "aws_security_group" "public_subnet_sg" {
  vpc_id = aws_vpc.main_vpc.id
  egress = [
    merge({
      description      = "allow_out_all"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    self = false }, var.default_egress)
  ]
}
resource "aws_security_group" "private_subnet_sg" {
  vpc_id = aws_vpc.main_vpc.id
  egress = [
    merge({
      description      = "allow_out_all"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    self = false }, var.default_egress)
  ]
}
resource "aws_security_group" "public_lb_sg" {
  vpc_id = aws_vpc.main_vpc.id
  egress = [
    merge({
      description      = "allow_out_all"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    self = false }, var.default_egress)
  ]

}
resource "aws_security_group" "private_lb_sg" {
  vpc_id = aws_vpc.main_vpc.id
  egress = [
    merge({
      description      = "allow_out_all"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    self = false }, var.default_egress)
  ]
}

