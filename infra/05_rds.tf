resource "aws_secretsmanager_secret" "db_password" {
  name = "rds-password"
}

resource "random_password" "random_db_password" {
  length           = 20
  special         = true
  override_special = "!@#$%^&*()-_+="
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({ 
    password = random_password.random_db_password.result 
    username = "admin"
    endpoint = aws_db_instance.rds-ecommerce.endpoint,
    database = "ecommerce",
    port = 3306
    })
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc.id
  name        = "rds-security-group"
  description = "Allow inbound MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["177.80.67.158/32"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }
}

resource "aws_db_instance" "rds-ecommerce" {
  identifier        = "ecommerce-rds"
  engine           = "mysql"
  instance_class   = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  username         = "admin"
  password         = random_password.random_db_password.result
  parameter_group_name = "default.mysql8.0"

  publicly_accessible = true
  skip_final_snapshot = true
  backup_retention_period = 0
  monitoring_interval = 0

  apply_immediately = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name


}
