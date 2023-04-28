locals {
  vpc_endpoint_subnet_ids = [for subnet in module.vpc.subnet_list.* : subnet.id if subnet.tags.SubnetName == var.vpc_endpoint_subnet_name]
}

module "vpc_endpoints" {
  count                     = length(var.vpc_endpoint_services)
  source                    = "../lz-tf-modules/vpc-endpoint/"
  vpc_id                    = module.vpc.vpc_id
  vpc_endpoint_subnet_ids   = local.vpc_endpoint_subnet_ids
  vpc_endpoint_service_name = var.vpc_endpoint_services[count.index]
  master_prefix             = var.master_prefix
  env_prefix                = var.env_prefix
  app_prefix                = var.app_prefix
  #tags                      = var.tags
  vpc_tags = var.vpc_tags

      providers = {
      aws = aws.sharedservices
    }
}

# # # Separate VPC endpoint for S3. All spoke VPCs have the option of us S3 Gateway endpoint. This endpoint's primary purpose is to serve on-prem to S3 traffic via Direct Connect
module "s3_vpc_endpoint" {
  count                     = var.enable_s3_vpc_interface_endpoint ? 1 : 0
  source                    = "../lz-tf-modules/vpc-endpoint/"
  vpc_id                    = module.vpc.vpc_id
  vpc_endpoint_subnet_ids   = local.vpc_endpoint_subnet_ids
  vpc_endpoint_service_name = "s3"
  master_prefix             = var.master_prefix
  env_prefix                = var.env_prefix
  app_prefix                = var.app_prefix
  #tags                      = var.tags
  vpc_tags = var.vpc_tags

      providers = {
      aws = aws.sharedservices
    }
}

# #Record to allow s3 virtual-hosted-style URL
resource "aws_route53_record" "s3" {
  zone_id = module.s3_vpc_endpoint[0].r53_zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"
  records = ["s3.${data.aws_region.current.name}.amazonaws.com"]
     provider          = aws.sharedservices
}

module "vpc_endpoints-ecr-api" {
  count                     = length(var.vpc_endpoint_services)
  source                    = "../lz-tf-modules/vpc-endpoint-custom-dns/"
  vpc_id                    = module.vpc.vpc_id
  vpc_endpoint_subnet_ids   = local.vpc_endpoint_subnet_ids
  vpc_endpoint_service_name = "ecr.api"
  vpc_endpoint_dns_name     = "api.ecr"
  master_prefix             = var.master_prefix
  env_prefix                = var.env_prefix
  app_prefix                = var.app_prefix
  #tags                      = var.tags
  vpc_tags = var.vpc_tags

      providers = {
      aws = aws.sharedservices
    }
}

module "vpc_endpoints-ecr-dkr" {
  count                     = length(var.vpc_endpoint_services)
  source                    = "../lz-tf-modules/vpc-endpoint-custom-dns/"
  vpc_id                    = module.vpc.vpc_id
  vpc_endpoint_subnet_ids   = local.vpc_endpoint_subnet_ids
  vpc_endpoint_service_name = "ecr.dkr"
  vpc_endpoint_dns_name     = "dkr.ecr"
  master_prefix             = var.master_prefix
  env_prefix                = var.env_prefix
  app_prefix                = var.app_prefix
  #tags                      = var.tags
  vpc_tags = var.vpc_tags

      providers = {
      aws = aws.sharedservices
    }
}

#Record to allow ekr dkr virtual-hosted-style URL
resource "aws_route53_record" "r53_alias_vpc_endpoint" {
  zone_id = module.vpc_endpoints-ecr-dkr.r53_zone_id
  name    = format("*.dkr.ecr.%s.amazonaws.com", data.aws_region.current.name)
  type    = "CNAME"
  ttl     = "300"
  records = [module.vpc_endpoints-ecr-dkr.vpc_endpoint_dns_entry[0]["dns_name"]]
     provider          = aws.sharedservices
}
