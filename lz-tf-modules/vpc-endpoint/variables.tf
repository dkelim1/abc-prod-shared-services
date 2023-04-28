variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_endpoint_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids where the VPC Interface Endpoints will be created"
}

variable "vpc_endpoint_service_name" {
  type        = string
  description = "AWS Service name for creating the VPC Endpoint"
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
  default     = {}
}
