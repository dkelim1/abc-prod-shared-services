data "aws_region" "current" {}


resource "aws_security_group" "vpc_endpoint_sec_group" {
  name        = format("%s-%s-%s-vpc-endpoint-%s", var.master_prefix, var.env_prefix, var.app_prefix, var.vpc_endpoint_service_name)
  description = format("Security Group for VPC Endpoint com.amazonaws.%s.%s", data.aws_region.current.name, var.vpc_endpoint_service_name)
  vpc_id      = var.vpc_id

  egress {
    description = "Outbound to vpc endpoints"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.21.0.0/16","172.23.0.0/16"]
  }
  ingress {
    description = "Inbound to vpc endpoints"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.21.0.0/16","172.23.0.0/16"]
  }
    provider          = aws.sharedservices
}

resource "aws_vpc_endpoint" "vpce" {
  vpc_id              = var.vpc_id
  service_name        = format("com.amazonaws.%s.%s", data.aws_region.current.name, var.vpc_endpoint_service_name)
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sec_group.id]
  subnet_ids          = var.vpc_endpoint_subnet_ids
  private_dns_enabled = false
  tags = merge(
    {
      "Name" = format("%s-%s-%s-vpce-%s", var.master_prefix, var.env_prefix, var.app_prefix, var.vpc_endpoint_service_name)
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

resource "aws_route53_zone" "phz_vpc_endpoints" {
  #checkov:skip=CKV2_AWS_38:Skip the check for Private Hosted Zone
  #checkov:skip=CKV2_AWS_39:Skip the check as we have enabled query log in the VPC level
  name    = format("%s.%s.amazonaws.com", var.vpc_endpoint_dns_name, data.aws_region.current.name)
  comment = format("Private hosted zone for VPC Endpoint %s.%s.amazonaws.com", var.vpc_endpoint_service_name, data.aws_region.current.name)
  vpc {
    vpc_id = var.vpc_id
  }
  tags = merge(
    {
      "Name" = format("%s-%s-%s-vpce-%s", var.master_prefix, var.env_prefix, var.app_prefix, var.vpc_endpoint_service_name)
    },
    var.tags, var.vpc_tags
  )
  lifecycle {
    ignore_changes = [
      # The private hosted zone will be attached to multiple VPCs. 
      # These associations must be retained. Hence ignore changes to the vpc argument. If removed will cause drift and lead to disassociing the VPC
      vpc
    ]
  }
    provider          = aws.sharedservices
}

resource "aws_route53_record" "r53_alias_vpc_endpoint" {
  zone_id = aws_route53_zone.phz_vpc_endpoints.zone_id
  name    = format("%s.%s.amazonaws.com", var.vpc_endpoint_dns_name, data.aws_region.current.name)
  type    = "A"
  alias {
    name                   = aws_vpc_endpoint.vpce.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.vpce.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
    provider          = aws.sharedservices
}

# resource "aws_route53_record" "r53_alias_vpc_endpoint" {
#   zone_id = aws_route53_zone.phz_vpc_endpoints.zone_id
#   name    = format("%s.%s.amazonaws.com", var.vpc_endpoint_service_name, data.aws_region.current.name)
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_vpc_endpoint.vpce.dns_entry[0]["dns_name"]]
# }
