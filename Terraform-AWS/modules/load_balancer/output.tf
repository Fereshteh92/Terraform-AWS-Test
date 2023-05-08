output "frontend_load_balancer_dns_name" {
  description = "The DNS name of the frontend load balancer"
  value =  aws_lb.web_server_lb.dns_name
}

output "frontend_load_balancer_arn" {
  description = "The ARN of the frontend load balancer"
  value = aws_lb.web_server_lb.arn
}

output "internal_load_balancer_dns_name" {
  description = "The DNS name of the internal load balancer"
  value =  aws_lb.api_server_lb.dns_name
}

output "internal_load_balancer_arn" {
  description = "The ARN of the internal load balancer"
  value = aws_lb.api_server_lb.arn
}
