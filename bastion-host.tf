# Create Bastion Host Security Group

resource "aws_security_group" "terra_utopia_bastion_sg" {
  vpc_id = aws_vpc.terra_utopia_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "Terra Utopia Bastion Security Group"
    Terraform   = "true"
    } 
}


# CREATE BASTION HOST IN us-east-1A PUBLIC SUBNET

# resource "aws_instance" "terra_utopia_bastion_host-1a" {
#   ami = ""
#   instance_type = "t2.micro"
#   key_name = aws_key_pair.ssh-key.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.terra_utopia_bastion_sg.id]
#   subnet_id = aws_subnet.terra-utopia-public-1a.id
#   tags = {
#     Name = "Terra-Utopia Bastion Host - 1A"
#     Terraform = true
#   }
# }

# CREATE BASTION HOST IN us-east-1B PUBLIC SUBNET

# resource "aws_instance" "terra_utopia_bastion_host-1b" {
#   ami = ""
#   instance_type = "t2.micro"
#   key_name = aws_key_pair.ssh-key.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.terra_utopia_bastion_sg.id]
#   subnet_id = aws_subnet.terra-utopia-public-1b.id
#   tags = {
#     Name = "Terra-Utopia Bastion Host - 1B"
#     Terraform = true
#   }
# }