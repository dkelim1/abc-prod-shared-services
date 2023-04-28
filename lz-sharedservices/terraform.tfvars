region_name           = "ap-northeast-1"

master_prefix = "abc"
env_prefix    = "lz"
app_prefix    = "shared-service"

vpc_cidr = "172.29.0.0/23"

# Number prefixes indicate order of subnets in map. Do not change. Change to order lead to replacement of subnet resource
vpc_subnet_list = {
  "vpce" = {
    "a" = "172.29.0.0/26"
    "b" = "172.29.0.64/26"
    "c" = "172.29.0.128/26"
  },
  "ad" = {
    "a" = "172.29.1.0/28"
    "b" = "172.29.1.16/28"
    "c" = "172.29.1.32/28"
  },
  "ad-connector" = {
    "a" = "172.29.1.48/28"
    "b" = "172.29.1.64/28"
    "c" = "172.29.1.80/28"
  }
  "dns" = {
    "a" = "172.29.1.96/28"
    "b" = "172.29.1.112/28"
    "c" = "172.29.1.128/28"
  }
    "tgw" = {
    "a" = "172.29.1.144/28"
    "b" = "172.29.1.160/28"
    "c" = "172.29.1.176/28"
  }
}

tgw_subnet_name              = "tgw"
dns_subnet_name              = "dns"
active_directory_subnet_name = "ad"
ad_connector_subnet_name = "ad-connector"
vpc_endpoint_subnet_name = "vpce"

r53_resolver_outbound_rule_target_ip = ["172.26.1.159", "172.17.1.99","172.27.1.19"]
r53_resolver_outbound_rule_domain_name = "prod-internal.abc.sg"
r53_resolver_outbound_rule_non_prod_target_ip = ["172.31.1.253"]
r53_resolver_outbound_rule_non_prod_domain_name = "uat-internal.abc.sg"

ssm_tgw_id                = "/lz/network/tgw/id"
ssm_abc_inspection_rt_id  = "/lz/network/tgw/inspection_rt/id"
ssm_abc_core_rt_id        = "/lz/network/tgw/core_rt/id"
ssm_abc_prod_rt_id        = "/lz/network/tgw/prod_rt/id"
ssm_abc_idt_rt_id         = "/lz/network/tgw/idt_rt/id"
ssm_abc_uat_rt_id         = "/lz/network/tgw/uat_rt/id"
ssm_abc_dev-sit_rt_id     = "/lz/network/tgw/dev-sit_rt/id"
ssm_network_acc_number    = "/lz/organization/foundation/network/id"

tags = {
  "terraform"                  = true
  "division"                   = "Common"
  "environment"                = "prod"
  "application"                = "shared-services"
  "business-unit"              = "CommonInfra"
  "application-id"             = "Common"
  "project-id"                 = "Common"
  "support-email"              = "ABC_ALARM@abc.sg"
  "cost-center-bau"            = "N1110510"
  "cost-center-project"        = "N1110510-C0000099"
}


vpc_tags = {}
r53_tags = {}

enable_s3_vpc_interface_endpoint = true
vpc_endpoint_services    = ["ssmmessages", "ssm", "ec2messages", "secretsmanager", "git-codecommit", "datasync", "kms", "logs", "sts", "email-smtp"]

ram_tags                               = {}

ssm_org_acc_number = "/aft/account/ct-management/account-id"

tgw_attachment = true

# AD Configuration

aws_ad_domain_name = "abc.aws.internal"

ad_client_instance_type = "t3.medium"

ad_client_ebs_type = "gp3"

ad_client_ebs_vol_size = 30

ssm_org_id_name    = "/lz/organization/id"

hsm_vpc_cidr = "172.29.5.0/24"
hsm_vpc_subnet_list = {
  "hsm" = {
    "a" = "172.29.5.0/27"
    "b" = "172.29.5.32/27"
    "c" = "172.29.5.64/27"
  },
  "tgw" = {
    "a" = "172.29.5.96/28"
    "b" = "172.29.5.112/28"
    "c" = "172.29.5.128/28"
  }
}
hsm_subnet_name         = "hsm"


hsm_vpc_prod_cidr = "172.29.7.0/24"
hsm_vpc_prod_subnet_list = {
  "hsm" = {
    "a" = "172.29.7.0/27"
    "b" = "172.29.7.32/27"
    "c" = "172.29.7.64/27"
  },
  "tgw" = {
    "a" = "172.29.7.96/28"
    "b" = "172.29.7.112/28"
    "c" = "172.29.7.128/28"
  }
}
hsm_subnet_prod_name         = "hsm"

limit_amount        = "1088"
account_owner_email = "SHARED_AWS@abc.sg"


resolver_query_logs_config_id = "rqlc-419c96b12c0a99f1"

xb_public_domain_list = [
  {
    "domainname" = "abcservice.sg"
    "tags" = {
      "environment" = "prod"
      "application" = "def"
    }
  }
]


def_public_domain_list = [
  {
    "domainname" = "def.sg"
    "tags" = {
      "environment" = "prod"
      "application" = "def"
    }
  }
]

xyz_public_domain_list = [
  {
    "domainname" = "abc-xyz.sg"
    "tags" = {
      "environment" = "prod"
      "application" = "xyz"
    }
  }
]