output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "VPC ID"
}

output "subnet_list" {
  value = aws_subnet.subnets.*
  description = "List of subnets"
}

output "route_table_list" {
  value = aws_route_table.route_table.*
  description = "List of subnet route tables"
}

output "tgw_attachment_id" {
  value = var.tgw_attachment ? aws_ec2_transit_gateway_vpc_attachment.tgw_attach_vpc[0].id : null
  description = "Transit Gateway Attachment ID"
}
