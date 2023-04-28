# output "vpc_endpoint_dns_entry" {
#   value = aws_vpc_endpoint.vpce.dns_entry
#   description = "DNS Name of the VPC Endpoint"
# }

# output "vpc_endpoint_id" {
#   value = aws_vpc_endpoint.vpce.id
#   description = "VPC Endpoint Id"
# }

output "zone_id" {
  description = "Route 53 Private Hosted Zone Id"
  value = length(aws_route53_zone.dev) > 0 ? aws_route53_zone.dev.zone_id : null
}