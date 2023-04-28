
# ------------------------------------------------------------------------------
# PRIVATE HOSTED ZONES
# ------------------------------------------------------------------------------
resource "aws_route53_zone" "private" {
  #checkov:skip=CKV2_AWS_38:Skip the check for Private Hosted Zone
  #checkov:skip=CKV2_AWS_39:Skip the check as we have enabled query log in the VPC level
  count         = var.private_enabled ? 1 : 0
  name          = var.domain_name
  comment       = var.comment
  force_destroy = var.force_destroy

  vpc {
    vpc_id     = var.vpc_id
  }
    provider          = aws.sharedservices
}

# ------------------------------------------------------------------------------
# ROUTE53 RECORDS
# ------------------------------------------------------------------------------
resource "aws_route53_record" "default" {
  count                            = var.record_enabled && length(var.ttls) > 0 ? length(var.ttls) : 0
  zone_id                          = var.zone_id != "" ? var.zone_id : (var.private_enabled ? aws_route53_zone.private.*.zone_id[0] : "")
  name                             = element(var.names, count.index)
  type                             = element(var.types, count.index)
  ttl                              = element(var.ttls, count.index)
  records                          = split(",", element(var.values, count.index))
  set_identifier                   = length(var.set_identifiers) > 0 ? element(var.set_identifiers, count.index) : ""
  health_check_id                  = length(aws_route53_health_check.failover[*].id) > 0 ? element(aws_route53_health_check.failover.*.id, count.index) : ""
  multivalue_answer_routing_policy = length(var.multivalue_answer_routing_policies) > 0 ? element(var.multivalue_answer_routing_policies, count.index) : null
  allow_overwrite                  = length(var.allow_overwrites) > 0 ? element(var.allow_overwrites, count.index) : false
  failover_routing_policy {
    type       = element(var.failover_routing_policies, count.index)
      provider          = aws.sharedservices
  }
}
resource "aws_route53_record" "alias" {
  count                            = var.record_enabled && length(var.alias) > 0 && length(var.alias["names"]) > 0 ? length(var.alias["names"]) : 0
  zone_id                          = var.zone_id
  name                             = element(var.names, count.index)
  type                             = element(var.types, count.index)
  set_identifier                   = length(var.set_identifiers) > 0 ? element(var.set_identifiers, count.index) : ""
  health_check_id                  = length(aws_route53_health_check.failover[*].id) > 0 ? element(aws_route53_health_check.failover[count.index].*.id, count.index) : ""
  multivalue_answer_routing_policy = length(var.multivalue_answer_routing_policies) > 0 ? element(var.multivalue_answer_routing_policies, count.index) : null
  allow_overwrite                  = length(var.allow_overwrites) > 0 ? element(var.allow_overwrites, count.index) : false
  alias {
    name                   = length(var.alias) > 0 ? element(var.alias["names"], count.index) : ""
    zone_id                = length(var.alias) > 0 ? element(var.alias["zone_ids"], count.index) : ""
    evaluate_target_health = length(var.alias) > 0 ? element(var.alias["evaluate_target_healths"], count.index) : false
      provider          = aws.sharedservices
  }
}

# resource "aws_route53_zone_association" "default" {
#   count   = var.enabled ? 1 : 0
#   zone_id = var.private_enabled ? aws_route53_zone.private.*.zone_id[0] : ""
#   vpc_id  = var.secondary_vpc_id
# }

# ------------------------------------------------------------------------------
# ROUTE53 HEALTH CHECK
# ------------------------------------------------------------------------------

resource "aws_route53_health_check" "failover" {
  fqdn              = var.domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = var.health_check_path
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval
  measure_latency   = true
  count             = var.disable ? 0 : 1

  tags = {
    Environment = var.environment
  }
    provider          = aws.sharedservices
}