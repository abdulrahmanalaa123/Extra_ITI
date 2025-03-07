resource "aws_launch_template" "apache_template" {
  name = "apache_private_template"

  image_id = "ami-0b74f796d330ab49c"

  instance_initiated_shutdown_behavior = "stop"

  instance_type = "t2.micro"

  key_name = "key_name"

#   network_interfaces {
#     associate_public_ip_address = false
#   }

  vpc_security_group_ids = [aws_security_group.private_subnet_sg.id]

  user_data = filebase64("apache.sh")
}

resource "local_file" "nginx_template_file" {
  content = templatefile("nginx.tftpl",{
    PRIVATE_DNS = aws_lb.private_lb.dns_name
  })
  filename = "nginx_temp.sh"
  depends_on = [ aws_lb.private_lb ]
}

resource "aws_launch_template" "nginx_template" {
  name = "nginx_public_template"

  image_id = "ami-0b74f796d330ab49c"

  instance_initiated_shutdown_behavior = "stop"

  instance_type = "t2.micro"

  key_name = "key_name"

#   network_interfaces {
#     associate_public_ip_address = true
#   }
  vpc_security_group_ids = [aws_security_group.public_subnet_sg.id]

  user_data = local_file.nginx_template_file.content_base64sha256
  depends_on = [ local_file.nginx_template_file ]
}
