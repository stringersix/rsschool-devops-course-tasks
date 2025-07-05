#!/bin/bash

yum install -y aws-cli

echo "Fetching K3S token from SSM..."
for i in {1..10}; do
  TOKEN=$(aws ssm get-parameter --name "${ssm_token_param}" --with-decryption --region "${region}" --query Parameter.Value --output text) && break
  echo "Token is not available, wait..."
  sleep 6
done

echo "Fetched K3S token: $TOKEN"

if [ -z "$TOKEN" ]; then
  echo "ERROR: K3S token not found in SSM, aborting installation"
  exit 1
fi

aws ssm delete-parameter --name "${ssm_token_param}" --region "${region}"

curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true K3S_URL="https://${master_ip}:6443" K3S_TOKEN="$TOKEN" sh -s - agent