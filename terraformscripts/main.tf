provider "aws" {
  access_key="${var.access}"
  secret_key="${var.secret}"
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MyCustomVpc"
  }
}

#Subnet A 

resource "aws_subnet" "main"{

vpc_id = "${aws_vpc.main.id}"
cidr_block = "192.168.16.0/20"
availability_zone ="ap-southeast-1a"
tags = {
   Name = "SubnetA"
   }
 }
 
#Creating internetgateway

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "ig-gateway"
  }
}

#Adding route to the routing table

resource "aws_route_table" "route" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

}


#Association of subnet to the route table

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.route.id}"
}

#Creating a security group.

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh  traffic"
  vpc_id  = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
  tags = {
    Name = "ssh"
  }
}

