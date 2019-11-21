
provider "aws" {
  access_key="${var.access}"
  secret_key="${var.secret}"
  region = "ap-southeast-1"
}


data "aws_ami" "packer_exam" {
 owners           = ["self"]
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["Packer-Ansible"]
  }

  most_recent = true
}
resource "aws_instance" "ansible_host" {
  ami                         = "${data.aws_ami.packer_exam.id}"
  #key_name                    = "${aws_key_pair.ansiblehost_key.key_name}"
  key_name                    = "xxxxx"
  instance_type               = "t2.micro"
  security_groups             = ["app-securitygrp"]
  associate_public_ip_address = true
  tags ={
  Name = "buildhost"
  }

}
