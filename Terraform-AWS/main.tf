terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./vpc"  
}

module "load_balancer" {
  source = "./load_balancer"
}

module "security_groups" {
  source = "./security_groups"
}

module "instances" {
  source = "./instance"
}
module "SSM" {
  source = "./SSM"
}

module "database" {
  source = "./database"
}