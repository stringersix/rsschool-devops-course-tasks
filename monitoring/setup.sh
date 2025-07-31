#!/bin/bash
echo "🌐 Create namespace for monitoring..."
kubectl create namespace monitoring || true
      
echo "🔐 Creating Grafana admin secret..."
kubectl create secret generic grafana-admin-secret \
--from-literal=admin-user=admin \
--from-literal=admin-password="$GRAFANA_ADMIN_PASS" \
-n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "📊 Creating Grafana dashboard configmap..."
kubectl create configmap jenkins-dashboard \
--from-file=dashboard.json=monitoring/dashboard.json \
-n monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl label configmap jenkins-dashboard grafana_dashboard=1 -n monitoring --overwrite

envsubst < monitoring/configs/notifications.tpl.yaml | \
kubectl create secret generic notification-config \
  --from-file=alertmanager.yaml=/dev/stdin \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "📋 Creating Prometheus alert rules ConfigMap..."
kubectl apply -f monitoring/configs/rules.yaml -n monitoring
  
echo "🔧 Installing prom-stack in monitoring..."
helm upgrade --install "prom-stack" prometheus-community/kube-prometheus-stack \
--namespace monitoring \
-f monitoring/helm/values.yaml \
--wait

echo "✅ Monitoring stack deployed successfully!"