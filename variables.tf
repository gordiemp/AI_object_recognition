variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

variable "ami" {
  description = "The id of the machine image (AMI) to use for the instance"
  default     = "ami-0faab6bdbac9486fb"
}

variable "instance_type" {
  description = "The type of the instance to create"
  default     = "t2.micro"
}