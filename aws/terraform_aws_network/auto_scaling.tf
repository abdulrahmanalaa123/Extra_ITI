resource "aws_autoscaling_group" "public_auto" {
  min_size         = 2
  max_size         = 2
  desired_capacity = 2
  launch_template {
    id   = aws_launch_template.nginx_template.id
  }
  
  vpc_zone_identifier = [for subnet in var.subnets : subnet.public ? aws_subnet.subnets[subnet.name].id : ""]
  target_group_arns   = [aws_lb_target_group.public_group.arn]
}
resource "aws_autoscaling_group" "private_auto" {
  min_size         = 2
  max_size         = 2
  desired_capacity = 2
  launch_template {
    id   = aws_launch_template.apache_template.id
  }
  vpc_zone_identifier = [for subnet in var.subnets : subnet.public ? " " : aws_subnet.subnets[subnet.name].id]
  target_group_arns   = [aws_lb_target_group.private_group.arn]
}
