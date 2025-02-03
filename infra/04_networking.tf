resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "ecommerce-vpc"
  }
}

resource "aws_default_security_group" "vpc_sg" {
  vpc_id = aws_vpc.vpc.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["177.80.67.158/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet_a" {
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "ecommerce subnet"
  }
}

resource "aws_subnet" "subnet_b" {
  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  vpc_id            = aws_vpc.vpc.id

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    Name = "ecommerce subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ecommerce-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ecommerce-route-table"
  }
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "ecommerce subnet group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    Name = "ecommerce subnet group"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  count = 1

  private_dns_enabled = false
  security_group_ids  = [aws_default_security_group.vpc_sg.id]
  service_name        = "com.amazonaws.us-east-1.lambda"
  subnet_ids          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.vpc.id
}



resource "aws_security_group" "vpc_endpoint_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lambdas_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpce-sm-lambdas"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.secretsmanager"
  subnet_ids          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}