variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "env" {
  default = "dev"
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

variable "ami" {
  description = "The id of the machine image (AMI) to use for the instance"
  default     = "data.aws_ssm_parameter.ecs_ami.value"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t2.micro"
  }
}

variable "prod_onwer" {
  default = "Admin user"
}

variable "noprod_owner" {
  default = "Dev user"
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}