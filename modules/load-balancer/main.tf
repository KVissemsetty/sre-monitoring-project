resource "aws_lb" "lb" {
  name = "${var.name}-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = var.security_groups
  subnets = var.subnets
}
resource "aws_lb_target_group" "lb_target_group" {
  name = "${var.name}-tg"
  port = var.app_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = var.health_check_path
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
}
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}