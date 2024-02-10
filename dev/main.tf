# Provider block configures the AWS provider with the required authentication details.
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# This resource block deploys a subnet in the VPC deployed above, it also associates a public IP on every instance that will be launched in this subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true 
}

# This resource block deploys an internet gateway and associates it with the VPC created above
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# This resource block creates a route table in the VPC, it also sets a route to direct all non-local traffic to the internet gateway
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# This resource block associates the route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.r.id
}
