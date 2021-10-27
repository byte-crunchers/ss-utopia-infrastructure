# Create and Attach internet gateway

resource "aws_internet_gateway" "terra-utopia-igw" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  tags = {
    Name        = "terra-utopia Internet Gateway"
    Terraform   = "true"
  }
}