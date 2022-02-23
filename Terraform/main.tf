provider "aws" {

  # which region
  region = var.app_region
}

resource "aws_instance" "tudor_tf1_app" {

  # which AMI to use
  ami = var.app_ami_id

  # what type of instance
  instance_type = var.app_instance_type

  # associate pem file with ec2 instance on launch
  key_name = var.app_key_name

  # do you want public IP
  associate_public_ip_address = var.app_associate_public_ip

  # specify security group id (if launch on own vpc)
  vpc_security_group_ids = ["sg-0ea75fee7a5d01a78"]

  # specify subnet id (if launch on own vpc)
  subnet_id = "subnet-0e4f2d6ef561a1d7e"

  # what is the name of your instance
  tags = {
    Name = var.app_name_tag
  }
}
