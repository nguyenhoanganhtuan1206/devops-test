resource "aws_vpc" "devops_test_vpc" {
  cidr_block           = "192.168.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Internet gateway
resource "aws_internet_gateway" "devops_test_igw" {
  vpc_id = aws_vpc.devops_test_vpc.id
}

# Subnet 1
resource "aws_subnet" "devops-test_subnet-1" {
  vpc_id            = aws_vpc.devops_test_vpc.id
  cidr_block        = "192.168.0.0/25"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "devops-test_subnet-2" {
  vpc_id            = aws_vpc.devops_test_vpc.id
  cidr_block        = "192.168.0.128/25"
  availability_zone = "${var.aws_region}b"
}

# Route Table
resource "aws_route_table" "devops_test_rtb" {
  vpc_id = aws_vpc.devops_test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_test_igw.id
  }
}

# Route table association with 2 public subnets
resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.devops-test_subnet-1.id
  route_table_id = aws_route_table.devops_test_rtb.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.devops-test_subnet-2.id
  route_table_id = aws_route_table.devops_test_rtb.id
}
