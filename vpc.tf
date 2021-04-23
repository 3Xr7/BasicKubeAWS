resource "aws_vpc" "nat" {
  cidr_block = "172.24.0.0/16"

  enable_dns_hostnames = true

  tags = {
    Name = "vpc-nat"
  }
}

resource "aws_subnet" "public-nat-1" {
  vpc_id = aws_vpc.nat.id

  cidr_block = "172.24.2.0/24"
  
  map_public_ip_on_launch = true

  availability_zone = var.zones["a"]

  tags = {
    Name = "public-nat-1"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_subnet" "public-nat-2" {
  vpc_id = aws_vpc.nat.id

  cidr_block = "172.24.3.0/24"

  map_public_ip_on_launch = true

  availability_zone = var.zones["b"]

  tags = {
    Name = "public-nat-2"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "nat" {
  vpc_id = aws_vpc.nat.id

  tags = {
    Name = "vpc-nat-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.nat.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public-rt-1" {
  subnet_id = aws_subnet.public-nat-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rt-2" {
  subnet_id = aws_subnet.public-nat-2.id
  route_table_id = aws_route_table.public-rt.id
}
