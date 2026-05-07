output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.compute.alb_dns_name
}

output "vpc_id" {
  description = "VPC ID from the networking module"
  value       = module.networking.vpc_id
}
