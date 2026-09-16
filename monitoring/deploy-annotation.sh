#!/usr/bin/env bash
# From: "Monitoring and Observability on Alibaba Cloud with CloudMonitor and ARMS"
# Routes an alarm to a Message Service queue instead of raw SMS.
set -euo pipefail

aliyun cms PutMetricRuleTargets \
  --RuleId rule-xxxxxxxxxxxx \
  --Targets.1.Id target-1 \
  --Targets.1.Arn "acs:mns:ap-southeast-1:xxxx:queue/alerts"
