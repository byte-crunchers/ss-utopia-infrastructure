data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    # values = ["amzn2-ami-hvm-2.0.20211001.1-x86_64-gp2"]
  }
}

resource "random_id" "utopia_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "utopia_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "utopia_node" {
  count         = var.instance_count # 1
  instance_type = var.instance_type  # t3.micro
  ami           = data.aws_ami.server_ami.id
  tags = {
    Name = "utopia-terra-node-${random_id.utopia_node_id[count.index].dec}"
  }


  key_name               = aws_key_pair.utopia_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  #user_data = ""
  root_block_device {
    volume_size = var.vol_size #10
  }
}