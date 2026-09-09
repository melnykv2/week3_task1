resource "aws_vpc" "nodejs-demo-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "nodejs-vpc"
  }
}

resource "aws_internet_gateway" "nodejs-demo-igw" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  tags = {
    Name = "nodejs-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nodejs-nat" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  availability_mode = "regional"

  tags = {
    Name = "nodejs-nat"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  route {
    cidr_block       = "0.0.0.0/0"
    nat_gateway_id   = aws_nat_gateway.nodejs-nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nodejs-demo-igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = 2

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count = 2

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
}

/*
resource "aws_route_table_association" "public-route-table-association-a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-route-table-association-c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-route-table-association-a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-route-table-association-c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private-route-table.id
}
*/
resource "aws_security_group" "launch-template-sg" {
  name = "launch-template-sg"
  description = "Allow SSH and HTTP access"
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
  description = "Allow ALB access on port 80"
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
