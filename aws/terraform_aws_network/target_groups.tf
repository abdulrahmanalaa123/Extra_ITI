resource "aws_lb_target_group" "public_group" {
  name     = "public-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_target_group" "private_group" {
  name     = "private-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}