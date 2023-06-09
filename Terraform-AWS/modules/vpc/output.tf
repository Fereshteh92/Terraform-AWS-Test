output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID of the public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "ID of the private subnets"
  value       = aws_subnet.private.*.id
}

output "internet_gateway_id" {
  description = "ID of the IG"
  value       = aws_internet_gateway.main.id
}

