module "instances" {
  source = "./instance"
}

resource "aws_iam_instance_profile" "EC2_iam_profile" {
    name = var.iam_profile_name
    role = aws_iam_role.EC2_iam_role.name

}

resource "aws_iam_role" "EC2_iam_role" {
    name = "EC2-ssm-role"
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": {
            "Effect": "Allow",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }
    }
    EOF

    tags = {
        stack = "test"
    }

}

resource "aws_iam_role_policy_attachment" "EC2_ssm_policy" {
    role = aws_iam_role.EC2_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
