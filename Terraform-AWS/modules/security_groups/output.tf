output "web_server_sg_id" {
  value = aws_security_group.web_server_sg.id
}

output "api_server_sg_id" {
  value = aws_security_group.api_server_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "internal_lb_sg_id" {
  value = aws_security_group.internal_lb_sg.id
}

output "frontend_lb_sg_id" {
  value = aws_security_group.frontend_lb_sg.id
}