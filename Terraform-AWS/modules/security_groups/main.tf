module "vpc" {
  source = "./vpc"
}

resource "aws_security_group" "frontend_lb_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  } 

  tags = {
    Name = "Frontend load-balancer sg"
  }
    
}

# Create web server security group
resource "aws_security_group" "web_server_sg" {
  vpc_id = var.vpc_id
 
  # Allow HTTP traffic from the web_server load balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.frontend_lb_sg.id]
  }

   ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.frontend_lb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Web Server Security Group"
  }
}

#I'm not sure if I need a separate security group for my load balancer :-? 
resource "aws_security_group" "internal_lb_sg" {

  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "internal load-balancer sg"
  }
}


# Create API Server Security Group 
resource "aws_security_group" "api_server_sg" {
  vpc_id = var.vpc_id
 
  # Allow traffic from the internal load balancer
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    security_groups = [aws_security_group.internal_lb_sg.id]
  }

  # Allow outgoing traffic to anywhere
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "API Server Security Group"
  }
}


# Create RDS Database Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id

  # Allow incoming traffic from API server security group
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.api_server_sg.id]
  }

  # Allow outgoing traffic to anywhere
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  
  tags = {
    Name = "RDS Database Security Group"
  }
}


