output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_port" {
  value = aws_db_instance.rds.port
}

output "db_password" {
    description = "RDS instance password"
    value = aws_db_instance.rds.password

}

output "db_username" {
    description = "RDS instance username"
    value = aws_db_instance.rds.username

}