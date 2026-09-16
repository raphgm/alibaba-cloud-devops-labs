# Alibaba Cloud DevOps Labs

Runnable companion code for the Alibaba Cloud articles on [Dumka Esaenwi's technical blog](https://dumkaesaenwi.pages.dev). Each folder maps to one article — copy, adapt the placeholder values, and run against your own account.

## Contents

| Folder | Article |
| --- | --- |
| [`terraform/`](terraform) | Terraform on Alibaba Cloud: Infrastructure as Code with the Alicloud Provider — VPC + ECS + SLB module |
| [`github-actions/`](github-actions) | Building a CI/CD Pipeline to Alibaba Cloud with GitHub Actions — build, push to ACR, deploy to ACK |
| [`kubernetes/`](kubernetes) | Kubernetes on Alibaba Cloud: ACK vs. Self-Managed — StorageClass and cluster provisioning |
| [`oss/`](oss) | Object Storage Service (OSS) Patterns — lifecycle rules, signed URLs, multipart upload |
| [`monitoring/`](monitoring) | Monitoring and Observability with CloudMonitor and ARMS — alert rule and dashboard queries |

## Prerequisites

- [Alibaba Cloud CLI](https://www.alibabacloud.com/help/en/cli/) (`aliyun`), configured: `aliyun configure`
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5 with the `aliyun/alicloud` provider
- `kubectl`, for the Kubernetes examples
- Python 3 with `oss2` installed, for the OSS signed-URL example

## Usage

Each folder is self-contained. See the comments at the top of each file for the exact `aliyun`/`terraform`/`kubectl` command to run it. None of this provisions anything on its own — it's reference code to run deliberately against your own account.
