resource "aws_db_instance" "utopia_terra_db" {
  allocated_storage      = var.db_storage
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.db_identifier
  #   parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot = var.skip_final_snapshot
  tags = {
    Name = "utopia_terra_db"
  }
}