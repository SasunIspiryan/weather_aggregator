# HW19 Terraform Apply Log

Date: 2026-05-18
Branch: hw19

## Run Summary

Planned resources for deployment:
- Multi-AZ private subnets for DB subnet group
- RDS PostgreSQL instance in private subnets
- EC2 application host in public subnet
- App/DB security groups with least-privileged DB ingress

Local checks completed in this workspace:
- terraform fmt
- terraform init -backend=false
- terraform validate (Success)

## Verification Notes

After terraform apply, verify:
1. EC2 public IP responds in browser on port 80.
2. API health endpoint is reachable.
3. Application can read/write data through RDS endpoint.

## Command Log Placeholder

Paste the key terraform apply output lines here (resource creation and outputs).

Example headings to include:
- aws_db_instance.weather_db: Creation complete
- aws_instance.app: Creation complete
- Outputs: app_public_ip, rds_endpoint
