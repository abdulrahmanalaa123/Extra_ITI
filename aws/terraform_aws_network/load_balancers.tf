resource "aws_lb" "public_lb" {
  name               = "public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_lb_sg.id]
  subnets            = [for subnet in var.subnets : subnet.public ? aws_subnet.subnets[subnet.name].id : ""]

  enable_deletion_protection = false

  tags = {
    Name = "public_lb"
  }
}
resource "aws_lb" "private_lb" {
  name               = "private-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_lb_sg.id]
  subnets            = [for subnet in var.subnets : subnet.public ? "" : aws_subnet.subnets[subnet.name].id]

  enable_deletion_protection = false

  tags = {
    Name = "private_lb"
  }
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_group.arn
  }
}

resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_group.arn
  }
}
