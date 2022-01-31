output "vpc_id" {
  value = aws_vpc.utopia_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.utopia_rds_subnet_group.*.name
}

output "vpc_security_group_ids" {
  value = [aws_security_group.utopia_security_group["rds"].id]
}

output "public_security_group" {
  value = aws_security_group.utopia_security_group["public"].id
}

output "public_subnets" {
  value = aws_subnet.utopia_public_subnet.*.id
}