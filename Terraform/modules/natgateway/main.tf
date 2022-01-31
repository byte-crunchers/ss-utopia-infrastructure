# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY

  resource "aws_eip" "utopia-terra-nat1" {
}
  resource "aws_eip" "utopia-terra-nat2" {
}
  

# CREATE NAT GATEWAY in "us-east-1a"

  resource "aws_nat_gateway" "utopia-terra-nat-gateway-1a" {
  allocation_id = aws_eip.utopia-terra-nat1
  subnet_id     = aws_subnet.utopia-terra-public-1a.id

  tags = {
    Name        = "Nat Gateway-1a"
    Terraform   = "True"
  }
}

# CREATE NAT GATEWAY in "us-east-1b"

resource "aws_nat_gateway" "utopia-terra-nat-gateway-1b" {
  allocation_id = aws_eip.utopia-terra-nat2.id
  subnet_id     = aws_subnet.utopia-terra-public-1b.id

  tags = {
    Name        = "Nat Gateway-1b"
    Terraform   = "True"
  }
}