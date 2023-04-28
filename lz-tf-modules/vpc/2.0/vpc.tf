data "aws_availability_zones" "available" {}

# data "aws_subnet_ids" "subnets" {
#   depends_on = [
#     aws_subnet.subnets
#   ]
#   vpc_id = aws_vpc.vpc.id
#   filter {
#     name   = "tag:SubnetName"
#     values = [var.tgw_subnet_name]
#   }
# }

locals {
  subnet_full_list = flatten([
    for subnet_name in keys(var.vpc_subnet_list) : [
      for key, value in var.vpc_subnet_list[subnet_name] : {
        # "subnet_name" = substr(subnet_name, 3, -1)
        "subnet_name" = subnet_name
        "cidr"        = value
        "az"          = key
      }
    ]
  ])
  subnet_names_list = keys(var.vpc_subnet_list)
  tgw_subnet_ids = [for subnet in aws_subnet.subnets.* : subnet.id if subnet.tags.SubnetName == var.tgw_subnet_name]
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    {
      "Name" = format("%s-%s-%s-vpc", var.master_prefix, var.env_prefix, var.app_prefix)
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
    provider          = aws.sharedservices
}

resource "aws_subnet" "subnets" {
  count             = length(local.subnet_full_list)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnet_full_list[count.index].cidr
  availability_zone = format("%s%s", var.region_name, local.subnet_full_list[count.index].az)

  tags = merge(
    {
      "Name"       = format("%s-subnet-%s", local.subnet_full_list[count.index].subnet_name, local.subnet_full_list[count.index].az),
      "SubnetName" = local.subnet_full_list[count.index].subnet_name
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

resource "aws_route_table" "route_table" {
  count  = length(local.subnet_names_list)
  vpc_id = aws_vpc.vpc.id
  dynamic "route" {
    for_each = var.tgw_attachment ? [1] : []
    content {
      destination_prefix_list_id = var.tgw_dest_prefix_list
      transit_gateway_id = var.tgw_id
    }
  }
  tags = merge(
    {
      "Name"       = format("rt-%s-%s-%s-%s", var.master_prefix, var.env_prefix, var.app_prefix, local.subnet_names_list[count.index]),
      "SubnetName" = local.subnet_names_list[count.index]
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}


resource "aws_route_table_association" "private_route_table_association_webapp" {
    provider          = aws.sharedservices
  count          = length(aws_subnet.subnets.*)
  subnet_id      = aws_subnet.subnets.* [count.index].id
  route_table_id = aws_route_table.route_table.*.id[index(aws_route_table.route_table.*.tags.SubnetName, aws_subnet.subnets.* [count.index].tags.SubnetName)]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_vpc" {
  count = var.tgw_attachment ? 1 : 0
  subnet_ids         = local.tgw_subnet_ids
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = merge(
    {
      "Name" = format("%s-%s-%s-tgw-attach", var.master_prefix, var.env_prefix, var.app_prefix)
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

// VPC Flow Log (S3)
resource "aws_flow_log" "example" {
  log_destination      = var.vpc_flowlog_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
  tags = merge(
    {
      "Name" = format("%s-%s-%s-flowlog-s3", var.master_prefix, var.env_prefix, var.app_prefix)
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

// VPC Flow Log (CloudWatch LogGroup)
resource "aws_flow_log" "fl" {
  iam_role_arn    = aws_iam_role.vpc_flowlog_role.arn
  log_destination = aws_cloudwatch_log_group.cw_loggroup_for_vpc_flowlog.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
  tags = merge(
    {
      "Name" = format("%s-%s-%s-flowlog-cw", var.master_prefix, var.env_prefix, var.app_prefix)
    },
    var.tags, var.vpc_tags
  )
    provider          = aws.sharedservices
}

resource "aws_cloudwatch_log_group" "cw_loggroup_for_vpc_flowlog" {
  #checkov:skip=CKV_AWS_158:KMS Encryption is not enabled
  name = format("%s-%s-%s-vpc-flowlog", var.master_prefix, var.env_prefix, var.app_prefix)
  retention_in_days = 180
    provider          = aws.sharedservices
}

resource "aws_iam_role" "vpc_flowlog_role" {
  name = format("%s-%s-%s-vpc-flowlog-role", var.master_prefix, var.env_prefix, var.app_prefix)
  provider          = aws.sharedservices
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "vpc-flow-logs.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_flowlog_policy" {
  name = format("%s-%s-%s-vpc-flowlog-policy", var.master_prefix, var.env_prefix, var.app_prefix)
  role = aws_iam_role.vpc_flowlog_role.id
  provider          = aws.sharedservices
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
