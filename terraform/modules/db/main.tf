data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.secret_name
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_db_instance" "rds_db" {
  allocated_storage    = 15
  identifier           = "demo3-db"
  db_name              = local.db_creds.DbName
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       =  var.instance_class
  username             = local.db_creds.DbUsername
  password             = local.db_creds.DbPassword
  
  skip_final_snapshot  = false
  final_snapshot_identifier = "final-snapshot"
  db_subnet_group_name = var.db_subnet_group_id
  vpc_security_group_ids = [var.security_group_db_id]
}