#!/bin/bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo update

echo "🔧 Installing prom-stack in monitoring..."
helm upgrade --install "prom-stack" prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring/helm/values.yaml \
  --wait

echo "🔐 Generate Alert Manager config from template and create secret..."
set +x
export SMTP_EMAIL="$SMTP_EMAIL" SMTP_PASS="$SMTP_PASS"
envsubst < monitoring/alerts/alertmanager.yaml.tpl | \
kubectl create secret generic alertmanager-config \
  --from-file=alertmanager.yaml=/dev/stdin \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -
set -x

echo "🔐 Creating Grafana admin secret..."
kubectl create secret generic grafana-admin-secret \
  --from-literal=admin-user=admin \
  --from-literal=admin-password=admin123 \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "📊 Creating Grafana dashboard configmap..."
kubectl create configmap jenkins-dashboard \
  --from-file=dashboard.json=monitoring/dashboard.json \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl label configmap jenkins-dashboard grafana_dashboard=1 -n monitoring --overwrite

echo "📋 Creating Prometheus alert rules ConfigMap..."
kubectl apply -f monitoring/alerts/rules.yaml -n monitoring

echo "🔐 Creating SMTP secret..."
set +x
kubectl create secret generic smtp-auth-secret \
  --from-literal=password="$SMTP_PASS" \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -
set -x

echo "✅ Monitoring stack deployed successfully!"