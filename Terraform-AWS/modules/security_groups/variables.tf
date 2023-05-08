variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = module.vpc.vpc_id
}

