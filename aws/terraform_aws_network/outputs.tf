output "public_lb_ip" {
    description = "the public dns of my public load balancer"
    value = aws_lb.public_lb.dns_name
}
output "nat_public_ip" {
    description = "the public ip fo my nat gateway"
  value = aws_nat_gateway.public_nat.public_ip
}
