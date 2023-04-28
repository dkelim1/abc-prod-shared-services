variable "region_name" {
  type = string
}

variable "vpc_subnet_list" {
  type = map(map(string))
  description = "Map of subnet information with subnet CIDR, name and AZ"
}

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "tgw_id" {
  type = string
  default = ""
  description = "Transit Gateway ID to attach the VPC to"
}

variable "tgw_subnet_name" {
  type = string
  description = "The name of the subnet(s) which will be used too place the Tranist Gateway attachment"
}

variable "vpc_flowlog_bucket_arn" {
  type = string
  description = "ARN of the S3 bucket used to store VPC Flow Logs"
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
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for VPC resources"
  type        = map(string)
}

variable "tgw_attachment" {
  description = "flag to indicate attachment to TGW"
}

variable "tgw_dest_prefix_list" {
  type = string
}

