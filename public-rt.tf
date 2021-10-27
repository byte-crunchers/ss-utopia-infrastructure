# Create a public route table for Public Subnets
 
resource "aws_route_table" "terra-utopia-public" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-utopia-igw.id
  }
  tags = {
    Name        = "terra-utopia Public Route Table"
    Terraform   = "true"
    }
}
 
# Attach a public route table to Public Subnets
 
resource "aws_route_table_association" "terra-utopia-public-1a-association" {
  subnet_id = aws_subnet.terra-utopia-public-1a.id
  route_table_id = aws_route_table.terra-utopia-public.id
}
 
resource "aws_route_table_association" "terra-utopia-public-1b-association" {
  subnet_id = aws_subnet.terra-utopia-public-1b.id
  route_table_id = aws_route_table.terra-utopia-public.id
}