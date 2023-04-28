##################### General Configuration #####################
variable "region_name" {
  type        = string
  description = "AWS Region"
}

variable "guardduty_target_regions" {
  description = "A list of regions to enable Amazon GuardDuty."
  default = [
    #"af-south-1", # Region not enabled by default
    #"ap-east-1", # Region not enabled by default
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-south-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "ca-central-1",
    "eu-central-1",
    "eu-north-1",
    #"eu-south-1", # Region not enabled by default
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    #"me-south-1", # Region not enabled by default
    "sa-east-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]
}

variable "master_prefix" {
  description = "Master Prefix for all AWS Resources"
  type        = string
}

variable "env_prefix" {
  description = "Environment Prefix for all AWS Resources"
  type        = string
}

variable "app_prefix" {
  description = "Application Prefix for all AWS Resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "vpc_tags" {
  description = "Additional tags for VPC resources"
  type        = map(string)
}

##################### VPC Config #####################
variable "vpc_subnet_list" {
  type        = map(map(string))
  description = "Map of subnet information with subnet CIDR, name and AZ for Shared Services VPC"
}

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "vpc_flowlog_bucket_arn" {
  description = "SSM Parameter Name that stores TGW Attachment IDs"
  type        = string
  default     = "/lz/logging/vpc-flow-logs-bucket/arn"
}

variable "tgw_subnet_name" {
  type        = string
  description = "Subnet name where the TGW Attachment will be created"
}

variable "dns_subnet_name" {
  type        = string
  description = "Subnet name where the DNS Inbound & Outbound endpoints will be created"
}

variable "vpc_endpoint_subnet_name" {
  type        = string
  description = "Subnet name where the VPC Endpoints will be created"
}

variable "active_directory_subnet_name" {
  type        = string
  description = "Subnet name for the Active Directory components"
}

variable "ad_connector_subnet_name" {
  type        = string
  description = "Subnet name for the Active Directory connector to be shared with the Management Account"
}

##################### TGW Config #####################

variable "tgw_attachment" {
  description = "flag to indicate attachment to TGW"
}

variable "ssm_network_acc_number" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value for the Network Account ID"
}

variable "ssm_tgw_id" {
  type        = string
  description = "The SSM Parameter name which has the value for the TGW ID"
}

variable "ssm_abc_core_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - Core VPC Spoke"
}

variable "ssm_abc_prod_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - Prod VPC"
}

variable "ssm_abc_idt_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - IDT VPC"
}

variable "ssm_abc_uat_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - UAT VPC"
}

variable "ssm_abc_dev-sit_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - Dev SIT VPC"
}

variable "ssm_abc_inspection_rt_id" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value of Transit Gateway Route Table ID - Inspection VPC"
}

##################### VPC Endpoint Config #####################

variable "vpc_endpoint_services" {
  type        = list(string)
  description = "List of services for which VPC Endpoints nad their Route 53 Private Hosted Zones will be created"
}

variable "r53_resolver_outbound_rule_target_ip" {
  type        = list(string)
  description = "List of outbound rule target DNS IPs"
}

variable "r53_resolver_outbound_rule_domain_name" {
  type        = string
  description = "Domain name of the outbound DNS resolver"
}

variable "r53_resolver_outbound_rule_non_prod_target_ip" {
  type        = list(string)
  description = "List of (NON-PROD) outbound rule target DNS IPs"
}

variable "r53_resolver_outbound_rule_non_prod_domain_name" {
  type        = string
  description = "Domain name of the (NON-PROD) outbound DNS resolver"
}

variable "enable_s3_vpc_interface_endpoint" {
  type        = bool
  default     = true
  description = "Boolean to identify if S3 VPC Interface endpoint will be created"
}

##################### Security Config #####################

variable "metric_namespace" {
  description = "The namespace in which all CIS alarms will be set up."
  default     = "cust-lz-cis-benchmark"
}

variable "cloudtrail_log_group_name" {
  description = "The name of the CloudWatch Logs group to which CloudTrail events are delivered. This is created by default in every AWS Control Tower managed account"
  default     = "aws-controltower/CloudTrailLogs"
}

variable "sns_topic_name" {
  description = "The name of the CloudWatch Logs group to which CloudTrail events are delivered. This is created by default in every AWS Control Tower managed account"
  default     = "abc-lz-notifications-topic"
}

# variable "sns_topic_subscription_email" {
#   description = "The email address that will be subscribed to the LZ Notifications topic wihin the account"
# }

##################### Active Directory Config #####################

variable "ad_client_instance_type" {
  type        = string
  description = "Instance type for the AD EC2 client"
}

variable "ad_client_ebs_type" {
  type        = string
  description = "EBS volume type for the AD EC2 client"
}

variable "ad_client_ebs_vol_size" {
  type        = number
  description = "EBS volume size for the AD EC2 client"
}

variable "aws_ad_domain_name" {
  type = string
  description = "value of the AWS Managed AD domain name"
}

##################### Other Config #####################

variable "ram_tags" {
  description = "Additional tags for VPC resources"
  type        = map(string)
}

variable "r53_tags" {
  description = "Additional tags for VPC resources"
  type        = map(string)
}

variable "ssm_org_acc_number" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value for the AWS Organization Management Account ID"
}

#### aws_config_rule_tag_compliance.tf ####
# variable "required_tags_resource_types" {
#   type        = list(string)
#   description = "List of resources that AWS Config will monitor for tag compliance"
#   default = ["AWS::AutoScaling::AutoScalingGroup",
#     "AWS::DynamoDB::Table",
#     "AWS::EC2::Instance",
#     #    "AWS::EC2::SecurityGroup", // Enable based on requirements
#     "AWS::EC2::Volume",
#     "AWS::ElasticLoadBalancing::LoadBalancer",
#     "AWS::ElasticLoadBalancingV2::LoadBalancer",
#     "AWS::RDS::DBInstance",
#     #    "AWS::RDS::DBSecurityGroup", // Enable based on requirements
#     "AWS::RDS::DBSnapshot",
#     "AWS::S3::Bucket"
#   ]
# }

variable "mandatory_tags" {
  type        = map(string)
  description = "List of tags that are classified as mandatory. Max 6 tag key value pairs"
  default = {
    tag1Key   = "Name"
    tag2Key   = "application"
    tag3Key   = "environment"
    tag3Value = "development,test,sit,uat,pre-production,staging,production"
    tag4Key   = "business-unit"
    tag5Key   = "system-tier-classification"
    tag5Value = "tier-1,tier-2,tier-3,tier-4,tier-5"
  }
}

variable "governance_tags" {
  type        = map(string)
  description = "List of tags that are classified as Governance tags. Max 6 tag key value pairs"
  default = {
    tag1Key   = "application-id"
    tag2Key   = "project-id"
    tag3Key   = "cost-center"
    tag3Value = "110123,110456,110789,110111,110112,110113,110114,110115"
    tag4Key   = "pl-code"
    tag4Value = "62317,61118,61119"
    tag5Key   = "cost-pool"
    tag6Key   = "data-classification"
    tag6Value = "restricted,confidential,public,internal"
  }
}

variable "operations_tags" {
  type        = map(string)
  description = "List of tags that are classified as Operations tags. Max 6 tag key value pairs"
  default = {
    tag1Key = "support-team"
    #tag2Key = "uptime"
  }
}

variable "ssm_org_id_name" {
  type        = string
  description = "SSM Parameter Store parameter name which has the value for the AWS Organization ID"
}

#### Cloud HSM VPC ####
variable "hsm_vpc_subnet_list" {
  type        = map(map(string))
  description = "Map of subnet information with subnet CIDR, name and AZ for Shared Services VPC"
}

variable "hsm_vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "hsm_subnet_name" {
  type        = string
  description = "Subnet name where the DNS Inbound & Outbound endpoints will be created"
}

#### Cloud HSM Prod VPC ####
variable "hsm_vpc_prod_subnet_list" {
  type        = map(map(string))
  description = "Map of subnet information with subnet CIDR, name and AZ for Shared Services VPC"
}

variable "hsm_vpc_prod_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "hsm_subnet_prod_name" {
  type        = string
  description = "Subnet name where the DNS Inbound & Outbound endpoints will be created"
}

variable "sns_topic_subscription_email" {
  type = string
  description = "SNS Topic Subscription email"
  default     = "SECTEAM_AWS@abc.sg"
}

### Budget Variables
variable "budget_name" {
  description = "The name of a budget. Unique within accounts."
  type        = string
  default     = "abc"
}

variable "budget_type" {
  description = "Whether this budget tracks monetary cost or usage."
  type        = string
  default     = "COST"
}

variable "limit_amount" {
  description = "The amount of cost or usage being measured for a budget."
  type        = string
}

variable "account_owner_email" {
  description = "The email address of the account owner for internal accountability"
  type        = string
}

variable "resolver_query_logs_config_id" {
  description = "Query Log Config ID"
  type        = string
}

# variable "hsm_security_group_id" {
#   description = "HSM Security Group ID"
#   type        = string
#   default = "sg-0df07566bb0ca999999"
# }

#####Public Hosted Zone for Cross border #####
variable "abc_public_domain_list" {
  description = "ABC Public Hosted Zone List"
  type        = list(any)
}

#####Public Hosted Zone for DEF #####
variable "def_public_domain_list" {
  description = "DEF Public Hosted Zone List"
  type        = list(any)
}


variable "xyz_public_domain_list" {
  description = "XYZ Public Hosted Zone List"
  type        = list(any)
}
