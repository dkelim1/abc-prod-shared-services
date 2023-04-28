#terraform {
#  required_version = ">= 0.12"
#}


data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "subnet" {
  count  = length(var.subnets)
  id     = var.subnets[count.index]
  vpc_id = data.aws_vpc.vpc.id
  // map_public_ip_on_launch = false
  // availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}




resource "aws_cloudhsm_v2_cluster" "cloudhsm_cluster" {
 depends_on = [data.aws_subnet.subnet]
  count      = var.create_cluster ? 1 : 0
  hsm_type   = "hsm1.medium"
  subnet_ids = data.aws_subnet.subnet.*.id

  tags = {
   "Product"       = var.product
   "Cost Center"   = var.cost_center
   "Description"   = var.description
  }
     provider          = aws.sharedservices
}

data "aws_cloudhsm_v2_cluster" "cluster" {
 depends_on = [aws_cloudhsm_v2_cluster.cloudhsm_cluster]
  cluster_id = var.create_cluster ? aws_cloudhsm_v2_cluster.cloudhsm_cluster[0].cluster_id : var.cluster_id
}

#resource "aws_cloudhsm_v2_hsm" "hsm1" {
# depends_on = [data.aws_subnet.subnet]
#  subnet_id  = "${element(var.subnets, 0)}"
#  cluster_id = data.aws_cloudhsm_v2_cluster.cluster.cluster_id 
#}

resource "aws_cloudhsm_v2_hsm" "hsm1" {
  count = var.multi_instance ? 2 : 1
  depends_on = [data.aws_subnet.subnet]
  subnet_id  = "${element(var.subnets, count.index)}"
  cluster_id = data.aws_cloudhsm_v2_cluster.cluster.cluster_id 
     provider          = aws.sharedservices
}
