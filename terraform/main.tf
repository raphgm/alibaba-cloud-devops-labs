# Terraform on Alibaba Cloud: VPC + ECS + SLB
# From: "Terraform on Alibaba Cloud: Infrastructure as Code with the Alicloud Provider"
#
# Usage:
#   terraform init
#   terraform plan -var-file=environments/staging.tfvars
#   terraform apply -var-file=environments/staging.tfvars
#
# Auth: ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY env vars, or a RAM role assumption.

terraform {
  required_version = ">= 1.5"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.230"
    }
  }
}

provider "alicloud" {
  region = var.region
}

locals {
  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "alibaba-cloud-devops-labs"
  }
}

resource "alicloud_vpc" "main" {
  vpc_name   = "app-vpc-${var.environment}"
  cidr_block = "10.0.0.0/16"
  tags       = local.tags
}

resource "alicloud_vswitch" "private" {
  vpc_id     = alicloud_vpc.main.id
  cidr_block = "10.0.1.0/24"
  zone_id    = var.zone
}

resource "alicloud_security_group" "app" {
  name   = "app-sg-${var.environment}"
  vpc_id = alicloud_vpc.main.id
}

resource "alicloud_security_group" "lb" {
  name   = "lb-sg-${var.environment}"
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
  count                      = var.instance_count
  instance_name              = "app-${var.environment}-${count.index}"
  instance_type              = var.instance_type
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20240320.vhd"
  vswitch_id                 = alicloud_vswitch.private.id
  security_groups            = [alicloud_security_group.app.id]
  internet_max_bandwidth_out = 0 # no public IP — traffic only via SLB
  tags                       = local.tags

  # Installs Docker and runs the sample app from ../app on boot.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y docker.io
    systemctl enable --now docker
  EOF
  )
}

resource "alicloud_slb_load_balancer" "public" {
  load_balancer_name = "app-lb-${var.environment}"
  vswitch_id          = alicloud_vswitch.private.id
  address_type        = "internet"
  tags                = local.tags
}

resource "alicloud_slb_server_group" "app" {
  load_balancer_id = alicloud_slb_load_balancer.public.id
  name             = "app-backend-${var.environment}"

  dynamic "servers" {
    for_each = alicloud_instance.app
    content {
      server_id = servers.value.id
      port      = 8080
      weight    = 100
    }
  }
}

resource "alicloud_slb_listener" "http" {
  load_balancer_id  = alicloud_slb_load_balancer.public.id
  server_group_id   = alicloud_slb_server_group.app.id
  frontend_port     = 80
  protocol          = "http"
  bandwidth         = -1
  health_check      = "on"
  health_check_uri  = "/health"
  health_check_type = "http"
}
