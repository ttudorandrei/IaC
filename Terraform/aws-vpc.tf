resource "aws_vpc" "tf_tudor_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eng103a_tudor_terraform_vpc"
  }
}

resource "aws_subnet" "tudor-tf-public-subnet" {
  vpc_id                  = "vpc-0863ae82df2ea687b"
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "tudor-public-subnet"
  }
}

resource "aws_subnet" "tudor-tf-public-subnet-2" {
  vpc_id                  = "vpc-0863ae82df2ea687b"
  cidr_block              = "10.0.42.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "tudor-public-subnet-2"
  }
}

resource "aws_internet_gateway" "tudor-tf-internet-gateway" {
  vpc_id = "vpc-0863ae82df2ea687b"
  tags = {
    Name = "tudor-tf-internet-gateway"
  }
}

resource "aws_route_table" "tudor-tf-route-table" {
  vpc_id = "vpc-0863ae82df2ea687b"

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.tudor-tf-internet-gateway.id
  }

  tags = {
    Name = "tudor-tf-route-table"
  }
}

resource "aws_security_group" "tudor-tf-security-group" {
  vpc_id = "vpc-0863ae82df2ea687b"

  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "allow acces from anywhere"
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "ssh access from anywhere"
    from_port        = 22
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "http access from anywhere"
      from_port        = 80
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "allow access on port 3000 from anywhere"
      from_port        = 3000
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3000
  }]

  tags = {
    Name = "eng103a_tudor_tf_sg"
  }
}
