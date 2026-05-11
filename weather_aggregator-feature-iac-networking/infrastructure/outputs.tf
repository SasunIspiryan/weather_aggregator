output "alb_dns_name" {
  # Human-readable description of exported ALB DNS value.
  description = "DNS name of the application load balancer"
  # Expose ALB DNS from compute module output.
  value = module.compute.alb_dns_name
}

output "vpc_id" {
  # Human-readable description of exported VPC ID value.
  description = "VPC ID from the networking module"
  # Expose VPC ID from networking module output.
  value = module.networking.vpc_id
}
