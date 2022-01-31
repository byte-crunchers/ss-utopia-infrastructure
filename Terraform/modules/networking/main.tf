data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "utopia_vpc" {
  cidr_block = var.vpc_cidr_block
  #   enable_dns_hostnames = true
  #   enable_dns_support = true
  
  tags = {
    Name : "utopia__terra_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utopia_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.utopia_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "utopia_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "utopia_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.utopia_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.utopia_public_rt.id
}

resource "aws_subnet" "utopia_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.utopia_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "utopia_private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "utopia_internet_gateway" {
  vpc_id = aws_vpc.utopia_vpc.id

  tags = {
    Name = "utopia_igw"
  }
}

resource "aws_route_table" "utopia_public_rt" {
  vpc_id = aws_vpc.utopia_vpc.id

  tags = {
    Name = "utopia_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.utopia_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.utopia_internet_gateway.id
}

resource "aws_default_route_table" "utopia_private_rt" {
  default_route_table_id = aws_vpc.utopia_vpc.default_route_table_id

  tags = {
    Name = "utopia_private"
  }
}

resource "aws_security_group" "utopia_security_group" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.utopia_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "utopia_rds_subnet_group" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "utopia_rds_subnet_group"
  subnet_ids = aws_subnet.utopia_private_subnet.*.id
  tags = {
    Name = "utopia_rds_subnet_group"
  }
}