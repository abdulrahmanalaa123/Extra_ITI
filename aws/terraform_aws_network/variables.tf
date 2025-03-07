variable "default_egress" {
  type = object({
    from_port = number
    to_port   = number
    # remvoing quotations on string undefines egress which doesnt make sense
    protocol    = string
    cidr_blocks = list(string)
  })
}
variable "instances" {
  type = list(object({
    name          = string
    public        = bool
    ami           = string
    instance_type = string
    subnet        = string
  }))
}

variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  type = string
}
variable "subnets" {
  type = list(object({
    name   = string
    cidr   = string
    public = bool
    az     = number
  }))

}
