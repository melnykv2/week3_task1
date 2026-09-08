resource "aws_vpc" "nodejs-demo-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "nodejs-demo-igw" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "${local.name_prefix}-private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  cidr_block = "10.0.22.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "${local.name_prefix}-private-subnet-c"
  }
}

resource "aws_nat_gateway" "nodejs-nat" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  availability_mode = "regional"

  tags = {
    Name = "${local.name_prefix}-nat"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nodejs-nat.id
    }
  ]
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.nodejs-demo-igw.id
    }
  ]
}

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
