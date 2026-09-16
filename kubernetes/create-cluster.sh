#!/usr/bin/env bash
# From: "Kubernetes on Alibaba Cloud: ACK vs. Self-Managed, and When to Choose Which"
# Provisions an ACK Managed cluster with Cloud Monitor enabled on every node.
set -euo pipefail

aliyun cs CreateCluster --body '{
  "name": "prod-cluster",
  "cluster_type": "ManagedKubernetes",
  "region_id": "ap-southeast-1",
  "kubernetes_version": "1.28.3-aliyun.1",
  "vpcid": "vpc-xxxxxxxxxxxx",
  "vswitch_ids": ["vsw-xxxxxxxxxxxx"],
  "num_of_nodes": 3,
  "worker_instance_types": ["ecs.g7.xlarge"],
  "worker_system_disk_category": "cloud_essd",
  "cloud_monitor_flags": true
}'
