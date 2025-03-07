region      = "us-east-1"
vpc_cidr    = "10.0.0.0/16"
public_cidr = "0.0.0.0/0"
subnets = [{
  name   = "prod_public_subnet"
  cidr   = "10.0.1.0/24"
  public = true
  az     = 0
  }, {
  name   = "prod_private_subnet"
  cidr   = "10.0.2.0/24"
  public = false
  az     = 0
  },
]
default_egress = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
instances = [
  {
    name          = "prod_bastion_host"
    public        = true
    ami           = "ami-07eef52105e8a2059"
    instance_type = "t2.micro"
    subnet        = "public-subnet"
  },
  {
    name          = "prod_private_host"
    public        = false
    ami           = "ami-07eef52105e8a2059"
    instance_type = "t2.micro"
    subnet        = "private-subnet"
  }
]
# instance_counts = length(instances)

# #ubuntu ami
# default_ami = "ami-07eef52105e8a2059"

# defualt_instance_type = "t2.micro"

default_volume_config = {
  delete_on_termination = true
  volume_size           = 8
  volume_type           = "gp3"
}
