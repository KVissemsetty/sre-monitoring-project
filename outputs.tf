output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}