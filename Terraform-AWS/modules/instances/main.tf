module "vpc" {
  source = "./vpc"  
}

module "security_groups" {
  source = "./security_groups"
}

module "load_balancer" {
  source = "./load_balancer"
}

module "SSM" {
  source = "./SSM"
}

data "template_file" "startup" {
 template = file("ssm-agent-installer.sh")
}
# Create the web server instances, I think this should place each EC2 instance in one public subnet :-?
resource "aws_instance" "web_server" {
  for_each = module.vpc.public_subnets_ids
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = var.default_instance_type
  iam_instance_profile = aws_iam_instance_profile.EC2_iam_profile.name[0]
  subnet_id     = each.value
  vpc_security_group_ids = [module.security_groups.web_server_sg_id]

  tags = {
    Name = "web-server-${each.value}"
  }
 
  user_data = data.template_file.startup.rendered
}

# Create the API server instances
resource "aws_instance" "api_server" {
  for_each = module.vpc.private_subnets_ids
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = var.default_instance_type
  iam_instance_profile = aws_iam_instance_profile.EC2_iam_profile.name[1]
  subnet_id     = each.value
  vpc_security_group_ids = [module.security_groups.api_server_sg_id]

  tags = {
    Name = "api-server-${each.value}"
  }

  user_data = data.template_file.startup.rendered
}


#connecting EC2 instances to load balancers
resource "aws_lb_target_group_attachment" "attach_web_server"{
    count = length(aws_instance.web_server.*.id)
    target_group_arn = module.load_balancer.frontend_load_balancer_arn
    target_id = aws_instance.web_server.*.id[count.index]
    port = 80
}


resource "aws_lb_target_group_attachment" "attach_api_server"{
    count = length(aws_instance.api_server.*.id)
    target_group_arn = module.load_balancer.internal_load_balancer_arn
    target_id = aws_instance.api_server.*.id[count.index]
    port = 80
}