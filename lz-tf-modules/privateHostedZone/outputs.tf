# Copyright © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved. This AWS Content is provided subject to the terms of the AWS Customer Agreement available at http://aws.amazon.com/agreement or other written agreement between Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both."

# ------------------------------------------------------------------------------
# ROUTE53 MODULE OUTPUTS
# ------------------------------------------------------------------------------
output "zone_id" {
  value       = var.zone_id != "" ? "" : (join("", aws_route53_zone.private.*.zone_id))
  description = "The Hosted Zone ID. This can be referenced by zone records."
}