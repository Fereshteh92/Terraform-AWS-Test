module "security_groups" {
  source = "./security_groups"
}
module "vpc" {
  source = "./vpc"
}

resource "aws_lb" "web_server_lb" {
  name = "web_server_lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.security_groups.frontend_lb_sg.id] 

  subnets = module.vpc.public_subnet_ids

  access_logs {
    bucket  = "my-alb-logs"
    prefix  = "web_server_lb"
    enabled = true
  }

  tags = {
    Name = "Frontend Load Balancer"
  }
}

#create a lb target group
resource "aws_lb_target_group" "web_server_tg" {
  name_prefix      = "web_server_tg_"
  port             = 80
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = var.vpc_id
  health_check {
    path = "/health"
  }
}

resource "aws_lb_listener" "web_server_listener" {
  load_balancer_arn = aws_lb.web_server_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }

  depends_on = [
    aws_lb.web_server_lb,
    aws_lb_target_group.web_server_tg
  ]
}

resource "aws_launch_configuration" "web_server_lc" {
  name_prefix   = "web_server_lc_"
  image_id      = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my-keypair"

  security_groups = [
    aws_security_group.web_server_sg.id,
  ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
}


resource "aws_autoscaling_group" "web_server_asg" {
  name  = "web_server_asg"
  max_size  = 2
  min_size  = 2
  desired_capacity = 2
  launch_configuration = aws_launch_configuration.web_server_lc.name
  target_group_arns  = [aws_lb_target_group.web_server_tg.arn]

  vpc_zone_identifier = module.vpc.public_subnets_ids

  tags = {
    Name = "Web Server Autoscaling Group"
  }
}

#create an internal load balancer for api server
resource "aws_lb" "api_server_lb" {
  name  = "api_server_lb"
  internal = true
  load_balancer_type = "application"
  security_groups  = [module.security_groups.frontend_lb_sg.id] 
  subnets = module.vpc.private_subnet_ids

  tags = {
    Name = "Internal Load Balancer"
  }
}

#create a lb target group
resource "aws_lb_target_group" "api_server_tg" {
  name_prefix = "api_server_tg_"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval = 30
    path = "/"
    port = "80"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "api_server_listener" {
  load_balancer_arn = aws_lb.api_server_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.api_server_lb.arn
    type = "forward"
  }
}

