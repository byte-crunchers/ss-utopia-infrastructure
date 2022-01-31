# Create Bastion Host Security Group

resource "aws_security_group" "utopia-terra_bastion_sg" {
  vpc_id = aws_vpc.dfsc_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "utopia-terra Bastion Security Group"
    Terraform   = "true"
    } 
}


# CREATE BASTION HOST IN "us-east-1a" PUBLIC SUBNET

resource "aws_instance" "utopia-terra_bastion_host-1a" {
  ami = "ami-0b4b2d87bdd32212a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.dfsc_bastion_sg.id]
  subnet_id = aws_subnet.dfsc-public-1a.id
  tags = {
    Name = "utopia-terra Bastion Host - 1A"
    Terraform = true
  }
}

# CREATE BASTION HOST IN "us-east-1b" PUBLIC SUBNET

resource "aws_instance" "utopia-terra_bastion_host-1b" {
  ami = "ami-0b4b2d87bdd32212a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.utopia-terra_bastion_sg.id]
  subnet_id = aws_subnet.utopia-terra-public-1b.id
  tags = {
    Name = "utopia-terra Bastion Host - 1B"
    Terraform = true
  }
}