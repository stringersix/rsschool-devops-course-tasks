#!/bin/bash
set -e

curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -

sleep 10
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

aws ssm put-parameter \
  --name "/k3s/token" \
  --type "SecureString" \
  --value "$TOKEN" \
  --overwrite \
  --region us-east-1