resource "aws_launch_template" "launch_template" {
  image_id = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-app"
    }
  }
  user_data = base64encode(<<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y nginx
  systemctl start nginx
  systemctl enable nginx
EOF
)
}

resource "aws_autoscaling_group" "asg" {
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = var.target_group_arns
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  health_check_type = "ELB"
  health_check_grace_period = 300
}