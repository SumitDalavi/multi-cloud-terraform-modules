resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  # Secure by default
  storage_encrypted       = true
  multi_az                = var.multi_az
  publicly_accessible     = false
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = 7
  deletion_protection     = true

  tags = merge(var.tags, { ManagedBy = "terraform-module-registry" })
}

variable "identifier" { type = string }
variable "engine_version" {
  type    = string
  default = "15.4"
}
variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "max_allocated_storage" {
  type    = number
  default = 100
}
variable "database_name" { type = string }
variable "master_username" { type = string }
variable "master_password" {
  type      = string
  sensitive = true
}
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "multi_az" {
  type    = bool
  default = true
}
variable "skip_final_snapshot" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}

output "endpoint" { value = aws_db_instance.this.endpoint }
output "arn" { value = aws_db_instance.this.arn }
