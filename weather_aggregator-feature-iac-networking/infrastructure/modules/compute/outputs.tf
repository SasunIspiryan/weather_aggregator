output "alb_dns_name" {
  # Human-readable description of exported ALB DNS value.
  description = "The DNS name of the load balancer"
  # Expose ALB DNS name to root module.
  value = aws_lb.main.dns_name
}

output "asg_name" {
  # Human-readable description of exported ASG name value.
  description = "The name of the Auto Scaling Group"
  # Expose ASG name to root module.
  value = aws_autoscaling_group.app.name
}
