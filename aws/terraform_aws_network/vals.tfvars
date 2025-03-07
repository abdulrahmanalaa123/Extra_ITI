vpc_cidr = "10.0.0.0/16"

subnets = [{
  name   = "public_subnet"
  cidr   = "10.0.0.0/24"
  public = true
  az     = 0
  }, {
  name   = "public_subnet2"
  cidr   = "10.0.2.0/24"
  public = true
  az     = 1
  }, {
  name   = "private_subnet"
  cidr   = "10.0.3.0/24"
  public = false
  az     = 0
  }, {
  name   = "private_subnet2"
  cidr   = "10.0.1.0/24"
  public = false
  az     = 1
  }
]

default_egress = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

instances = [


]

