variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "az_count" {
  type        = number
  description = "The number of availability zones to use"
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones to use"
}
