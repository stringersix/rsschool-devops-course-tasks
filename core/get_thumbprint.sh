#!/bin/bash
set -e
FINGERPRINT=$(openssl s_client -servername token.actions.githubusercontent.com -connect token.actions.githubusercontent.com:443 </dev/null 2>/dev/null \
  | openssl x509 -fingerprint -sha1 -noout \
  | cut -d'=' -f2 \
  | tr -d ':' \
  | tr '[:upper:]' '[:lower:]')

echo "{\"thumbprint\": \"${FINGERPRINT}\"}"