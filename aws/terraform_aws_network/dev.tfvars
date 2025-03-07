
region      = "eu-central-1"
vpc_cidr    = "10.0.0.0/16"
public_cidr = "0.0.0.0/0"

subnets = [{
  name   = "public_subnet"
  cidr   = "10.0.2.0/24"
  public = true
  az     = 0
  }, {
  name   = "private_subnet"
  cidr   = "10.0.3.0/24"
  public = false
  az     = 0
  }, {
    name   = "redis_subnet"
    cidr   = "10.0.4.0/24"
    public = false
    az     = 1
    }, {
    name   = "elasticache_subnet"
    cidr   = "10.0.5.0/24"
    public = false
    az     = 2
  }
]
default_egress = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

instances = [
  {
    name          = "bastion_host"
    public        = true
    ami           = "ami-06ee6255945a96aba"
    instance_type = "t2.micro"
    subnet        = "public_subnet"
  },
  {
    name          = "private_host"
    public        = false
    ami           = "ami-06ee6255945a96aba"
    instance_type = "t2.micro"
    subnet        = "private_subnet"
  }
]

# instance_counts = length(instances)

default_volume_config = {
  delete_on_termination = true
  volume_size           = 8
  volume_type           = "gp3"
}
