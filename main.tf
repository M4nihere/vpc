# AWS VPC
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Beanstalk-VPC"
 }
}

# Public And Private Subnets 
resource "aws_subnet" "Beanstalk-Public-Subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-2a"
  depends_on = [
    aws_vpc.main
  ]
  tags = {
    Name = "Beanstalk-Public-Subnet1"
  }
}

resource "aws_subnet" "Beanstalk-Private-Subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2a"
  depends_on = [
    aws_vpc.main
  ]
  tags = {
    Name = "Beanstalk-Private-Subnet1"
  }
}

resource "aws_subnet" "Beanstalk-Public-Subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2b"
  depends_on = [
    aws_vpc.main
  ]
  tags = {
    Name = "Beanstalk-Public-Subnet2"
  }
}

resource "aws_subnet" "Beanstalk-Private-Subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-2b"
  depends_on = [
    aws_vpc.main
  ]
  tags = {
    
    Name = "Beanstalk-Private-Subnet2"
  }
}


# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Beanstalk-Public-Route-Table"
  }
}

# Public Route Table Association (for Public Subnets)
resource "aws_route_table_association" "Public_subnet_assoc" {
  subnet_id      = aws_subnet.Beanstalk-Public-Subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "Public_subnet_assoc2" {
  subnet_id      = aws_subnet.Beanstalk-Public-Subnet2.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Beanstalk-Private-Route-Table"
  }
}

# Private Route Table Association (for Private Subnets)
resource "aws_route_table_association" "Private_subnet_assoc" {
  subnet_id      = aws_subnet.Beanstalk-Private-Subnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "Private_subnet_assoc2" {
  subnet_id      = aws_subnet.Beanstalk-Private-Subnet2.id
  route_table_id = aws_route_table.private.id
}



# Internet Gateway (for Public Route Table)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Beanstalk-IG"
  }
}

# Route for Public Route Table (to Internet Gateway)
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block     = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.gw.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "Beanstalk-NAT-EIP"
  }
}

resource "aws_nat_gateway" "Beanstalk_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.Beanstalk-Public-Subnet1.id
  #availability_zone = aws_subnet.Beanstalk-Private-Subnet1.availability_zone

  tags = {
    Name = "Beanstalk-NAT-Gateway"
  }
}
resource "aws_route" "private_route_to_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Beanstalk_nat_gateway.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.Beanstalk_nat_gateway.id
}
