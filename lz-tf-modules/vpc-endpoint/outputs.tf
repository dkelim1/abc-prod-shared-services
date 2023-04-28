output "vpc_endpoint_dns_entry" {
  value = aws_vpc_endpoint.vpce.dns_entry
  description = "DNS Name of the VPC Endpoint"
}

output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.vpce.id
  description = "VPC Endpoint Id"
}

output "r53_zone_id" {
  value = aws_route53_zone.phz_vpc_endpoints.zone_id
  description = "Route 53 Private Hosted Zone Id for the VPC Endpoint"
}
