data "aws_region" "current" {}

resource "aws_route53_zone" "dev" {
  #checkov:skip=CKV2_AWS_38:Skip the check for Private Hosted Zone
  #checkov:skip=CKV2_AWS_39:Skip the check as we have enabled query log in the VPC level
  name = var.domainname
  tags = var.tags
    provider          = aws.sharedservices
}

