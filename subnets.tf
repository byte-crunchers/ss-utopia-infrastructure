# Create Public Subnets

resource "aws_subnet" "terra-utopia-public-1a" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "terra-utopia Public Subnet - 1A"
    Terraform   = "True"
  }
}
resource "aws_subnet" "terra-utopia-public-1b" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "terra-utopia Public Subnet - 1B"
    Terraform   = "True"
  }
}


# Create Private Subnets


resource "aws_subnet" "terra-utopia-private-1a" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "terra-utopia Private Subnet - 1A"
    Terraform   = "True"
  }
}

resource "aws_subnet" "terra-utopia-private-1b" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "terra-utopia Private Subnet - 1B"
    Terraform   = "True"
  }
}