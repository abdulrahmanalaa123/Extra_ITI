
resource "aws_vpc_security_group_ingress_rule" "allow_public_http" {
  security_group_id = aws_security_group.public_lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_public_ssh" {
  security_group_id = aws_security_group.public_lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_subnet_public_lb_http" {
  security_group_id            = aws_security_group.public_subnet_sg.id
  referenced_security_group_id = aws_security_group.public_lb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_subnet_public_lb_ssh" {
  security_group_id            = aws_security_group.public_subnet_sg.id
  referenced_security_group_id = aws_security_group.public_lb_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_private_lb_public_subnet_http" {
  security_group_id            = aws_security_group.private_lb_sg.id
  referenced_security_group_id = aws_security_group.public_subnet_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_private_lb_public_subnet_ssh" {
  security_group_id            = aws_security_group.private_lb_sg.id
  referenced_security_group_id = aws_security_group.public_subnet_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_subnet_private_lb_http" {
  security_group_id            = aws_security_group.private_subnet_sg.id
  referenced_security_group_id = aws_security_group.private_lb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_subnet_private_lb_ssh" {
  security_group_id            = aws_security_group.private_subnet_sg.id
  referenced_security_group_id = aws_security_group.private_lb_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
