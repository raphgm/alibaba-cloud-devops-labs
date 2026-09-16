# Terraform on Alibaba Cloud: VPC + ECS + SLB
# From: "Terraform on Alibaba Cloud: Infrastructure as Code with the Alicloud Provider"
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply
#
# Auth: ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY env vars, or a RAM role assumption.

terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.230"
    }
  }
}

provider "alicloud" {
  region = "ap-southeast-1"
}

resource "alicloud_vpc" "main" {
  vpc_name   = "app-vpc"
  cidr_block = "10.0.0.0/16"
}

resource "alicloud_vswitch" "private" {
  vpc_id     = alicloud_vpc.main.id
  cidr_block = "10.0.1.0/24"
  zone_id    = "ap-southeast-1a"
}

resource "alicloud_security_group" "app" {
  name   = "app-sg"
  vpc_id = alicloud_vpc.main.id
}

resource "alicloud_security_group" "lb" {
  name   = "lb-sg"
  vpc_id = alicloud_vpc.main.id
}

resource "alicloud_security_group_rule" "allow_lb" {
  type                      = "ingress"
  ip_protocol               = "tcp"
  port_range                = "8080/8080"
  security_group_id         = alicloud_security_group.app.id
  source_security_group_id  = alicloud_security_group.lb.id
}

resource "alicloud_instance" "app" {
  count                      = 2
  instance_name              = "app-${count.index}"
  instance_type              = "ecs.g7.large"
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20240320.vhd"
  vswitch_id                 = alicloud_vswitch.private.id
  security_groups            = [alicloud_security_group.app.id]
  internet_max_bandwidth_out = 0 # no public IP — traffic only via SLB
}

resource "alicloud_slb_load_balancer" "public" {
  load_balancer_name = "app-lb"
  vswitch_id          = alicloud_vswitch.private.id
  address_type        = "internet"
}

output "load_balancer_id" {
  value = alicloud_slb_load_balancer.public.id
}
