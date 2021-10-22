variable "db_storage" {
  type = number
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_subnet_group_name" {

}

variable "vpc_security_group_ids" {

}

variable "db_identifier" {

}

variable "skip_final_snapshot" {
  type = bool
}