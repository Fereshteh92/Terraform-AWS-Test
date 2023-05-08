output "web_server_instances_ids" {
  description = "ID of the EC2 instances for web server"
  value       = aws_instance.web_server.*.id
}

output "api_server_instances_ids" {
  description = "ID of the EC2 instances for api server"
  value       = aws_instance.api_server.*.id
}
