resource "aws_default_security_group" "item" {
  vpc_id = aws_vpc.item.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  # Let's disable allow-all egress by default. For security, it's better to
  # explicitly define which networks a service should be able to access.
  # 
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = merge(
    { "Name" = "${var.vpc_name}-default" }
  )
}
