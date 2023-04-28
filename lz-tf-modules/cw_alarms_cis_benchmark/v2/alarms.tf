# --------------------------------------------------------------------------------------------------
# CloudWatch metrics and alarms defined in the CIS benchmark.
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# 3.1 – Ensure a log metric filter and alarm exist for unauthorized API calls 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  count = var.enabled && var.unauthorized_api_calls_enabled ? 1 : 0

  name           = "cis-monitoring-unauthorized-api-calls"
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-unauthorized-api-calls"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  count = var.enabled && var.unauthorized_api_calls_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-unauthorized-api-calls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.unauthorized_api_calls[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.2 – Ensure a log metric filter and alarm exist for AWS Management Console sign-in without MFA 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "no_mfa_console_signin" {
  count = var.enabled && var.no_mfa_console_signin_enabled ? 1 : 0

  name           = "cis-monitoring-no-mfa-console-signin"
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-no-mfa-console-signin"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "no_mfa_console_signin" {
  count = var.enabled && var.no_mfa_console_signin_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-no-mfa-console-signin"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.no_mfa_console_signin[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for single-factor console logins will increase visibility into accounts that are not protected by MFA."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.3 – Ensure a log metric filter and alarm exist for usage of "root" account 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  count = var.enabled && var.root_usage_enabled ? 1 : 0

  name           = "cis-monitoring-root-usage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-root-usage"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage" {
  count = var.enabled && var.root_usage_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-root-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.root_usage[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for root account logins will provide visibility into the use of a fully privileged account and an opportunity to reduce the use of it."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.4 – Ensure a log metric filter and alarm exist for IAM policy changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "iam_changes" {
  count = var.enabled && var.iam_changes_enabled ? 1 : 0

  name           = "cis-monitoring-iam-changes"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-iam-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_changes" {
  count = var.enabled && var.iam_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-iam-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.iam_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to IAM policies will help ensure authentication and authorization controls remain intact."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.5 – Ensure a log metric filter and alarm exist for CloudTrail configuration changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "cloudtrail_cfg_changes" {
  count = var.enabled && var.cloudtrail_cfg_changes_enabled ? 1 : 0

  name           = "cis-monitoring-cloudtrail-cfg-changes"
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-cloudtrail-cfg-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_cfg_changes" {
  count = var.enabled && var.cloudtrail_cfg_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-cloudtrail-cfg-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.cloudtrail_cfg_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to CloudTrail's configuration will help ensure sustained visibility to activities performed in the AWS account."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------
# 3.6 – Ensure a log metric filter and alarm exist for AWS Management Console authentication failures 
# ---------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "console_signin_failures" {
  count = var.enabled && var.console_signin_failures_enabled ? 1 : 0

  name           = "cis-monitoring-console-signin-failures"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-console-signin-failures"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_failures" {
  count = var.enabled && var.console_signin_failures_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-console-signin-failures"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.console_signin_failures[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------------------
# 3.7 – Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs 
# --------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_cmk" {
  count = var.enabled && var.disable_or_delete_cmk_enabled ? 1 : 0

  name           = "cis-monitoring-disable-or-delete-cmk"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-disable-or-delete-cmk"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "disable_or_delete_cmk" {
  count = var.enabled && var.disable_or_delete_cmk_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-disable-or-delete-cmk"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.disable_or_delete_cmk[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.8 – Ensure a log metric filter and alarm exist for S3 bucket policy changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_changes" {
  count = var.enabled && var.s3_bucket_policy_changes_enabled ? 1 : 0

  name           = "cis-monitoring-s3-bucket-policy-changes"
  pattern        = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-s3-bucket-policy-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_policy_changes" {
  count = var.enabled && var.s3_bucket_policy_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-s3-bucket-policy-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.s3_bucket_policy_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to S3 bucket policies may reduce time to detect and correct permissive policies on sensitive S3 buckets."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.9 – Ensure a log metric filter and alarm exist for AWS Config configuration changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "aws_config_changes" {
  count = var.enabled && var.aws_config_changes_enabled ? 1 : 0

  name           = "cis-monitoring-aws-config-changes"
  pattern        = "{ ($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-aws-config-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_changes" {
  count = var.enabled && var.aws_config_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-aws-config-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.aws_config_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to AWS Config configuration will help ensure sustained visibility of configuration items within the AWS account."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.10 – Ensure a log metric filter and alarm exist for security group changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  count = var.enabled && var.security_group_changes_enabled ? 1 : 0

  name           = "cis-monitoring-security-group-changes"
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-security-group-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_changes" {
  count = var.enabled && var.security_group_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-security-group-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.security_group_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to security group will help ensure that resources and services are not unintentionally exposed."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.11 – Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL) 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "nacl_changes" {
  count = var.enabled && var.nacl_changes_enabled ? 1 : 0

  name           = "cis-monitoring-nacl-changes"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-nacl-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_changes" {
  count = var.enabled && var.nacl_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-nacl-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.nacl_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to NACLs will help ensure that AWS resources and services are not unintentionally exposed."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.12 – Ensure a log metric filter and alarm exist for changes to network gateways 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "network_gw_changes" {
  count = var.enabled && var.network_gw_changes_enabled ? 1 : 0

  name           = "cis-monitoring-network-gw-changes"
  pattern        = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-network-gw-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_gw_changes" {
  count = var.enabled && var.network_gw_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-network-gw-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.network_gw_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to network gateways will help ensure that all ingress/egress traffic traverses the VPC border via a controlled path."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.13 – Ensure a log metric filter and alarm exist for route table changes
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "route_table_changes" {
  count = var.enabled && var.route_table_changes_enabled ? 1 : 0

  name           = "cis-monitoring-route-table-changes"
  pattern        = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-route-table-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_changes" {
  count = var.enabled && var.route_table_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-route-table-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.route_table_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to route tables will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3.14 – Ensure a log metric filter and alarm exist for VPC changes 
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "vpc_changes" {
  count = var.enabled && var.vpc_changes_enabled ? 1 : 0

  name           = "cis-monitoring-vpc-changes"
  pattern        = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name      = "cis-monitoring-vpc-changes"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_changes" {
  count = var.enabled && var.vpc_changes_enabled ? 1 : 0

  alarm_name                = "cis-monitoring-vpc-changes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.vpc_changes[0].id
  namespace                 = var.metric_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to VPC will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = [aws_sns_topic.cw_alarms_sns_topic.arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}
