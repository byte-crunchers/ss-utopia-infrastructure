# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY

  resource "aws_eip" "terra-utopia-nat1" {
}
  resource "aws_eip" "terra-utopia-nat2" {
}
  

# CREATE NAT GATEWAY in us-east-1A

  resource "aws_nat_gateway" "terra-utopia-nat-gateway-1a" {
  allocation_id = aws_eip.terra-utopia-nat1.id
  subnet_id     = aws_subnet.terra-utopia-public-1a.id

  tags = {
    Name        = "terra-utopia Nat Gateway-1a"
    Terraform   = "True"
  }
}

# CREATE NAT GATEWAY in us-east-1B

resource "aws_nat_gateway" "terra-utopia-nat-gateway-1b" {
  allocation_id = aws_eip.terra-utopia-nat2.id
  subnet_id     = aws_subnet.terra-utopia-public-1b.id

  tags = {
    Name        = "terra-utopia Nat Gateway-1b"
    Terraform   = "True"
  }
}