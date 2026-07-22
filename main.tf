provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  name = "sre-monitoring"
  azs = ["us-east-1a","us-east-1b"]
  private_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

resource "aws_security_group" "security_group" {
  name = "sre-monitoring-app-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = var.app_port
    to_port = var.app_port
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "compute" {
  source = "./modules/compute"
  name   = "sre-monitoring"

  image_id                = "ami-0b6d9d3d33ba97d99"
  vpc_security_group_ids  = [aws_security_group.security_group.id]
  subnet_ids              = module.vpc.private_subnet_ids

  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
}
resource "aws_security_group" "alb_sg" {
  name   = "sre-monitoring-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "load_balancer" {
  source = "./modules/load-balancer"
  name = "sre-monitoring-lb"
  vpc_id = module.vpc.vpc_id
  security_groups = [aws_security_group.alb_sg.id]
  app_port = var.app_port
  subnets = module.vpc.public_subnet_ids
}
resource "aws_sns_topic" "alerts" {
  name = "sre-monitoring-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

module "monitoring" {
  source = "./modules/monitoring"
  name   = "sre-monitoring"

  alarms = {
    high_cpu = {
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      threshold           = 70
      comparison_operator = "GreaterThanThreshold"
      alarm_actions       = []
    }
    unhealthy_hosts = {
      metric_name         = "UnHealthyHostCount"
      namespace           = "AWS/ApplicationELB"
      threshold           = 0
      comparison_operator = "GreaterThanThreshold"
      alarm_actions       = [aws_sns_topic.alerts.arn]
    }
  }
}