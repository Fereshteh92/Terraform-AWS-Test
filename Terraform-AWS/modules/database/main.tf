module "security_groups" {
  source = "../security_groups"
}
module "vpc" {
  source = "./vpc"
}

#generate a random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


# Create RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = var.db_username
  password             = random_password.password.result
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [module.security_groups.rds_sg_id]

  
  subnet_group_name = aws_db_subnet_group.rds

  tags = {
    Name = " RDS Instance"
  }

}

# Create DB subnet group, at least 2 subnets in different availability zones
resource "aws_db_subnet_group" "rds" {
  name       = "rds_subnet_group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "RDS Subnet Group"
  }
}


# add some configs to RDS instance
resource "aws_db_parameter_group" "rds" {
  name_prefix = "rds_param_"

  parameter {
    name  = "time_zone"
    value = "UTC"
  }
}
