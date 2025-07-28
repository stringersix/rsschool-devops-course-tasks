include .env
export

format:
	terraform fmt -recursive

init-core:
	cd core && terraform init

apply-core:
	cd core && terraform apply -auto-approve \
				-var="bucket_name=$(BACKEND_BUCKET)" \
				-var="github_org=$(GITHUB_ORG)" \
				-var="github_repo=$(GITHUB_REPO)" \
				-var="github_actions_role=$(GITHUB_ACTIONS_ROLE)" \
				-var="region=$(AWS_REGION)"	

destroy-core:
	cd core && terraform destroy -auto-approve \
				-var="bucket_name=$(BACKEND_BUCKET)" \
				-var="github_org=$(GITHUB_ORG)" \
				-var="github_repo=$(GITHUB_REPO)" \
				-var="github_actions_role=$(GITHUB_ACTIONS_ROLE)" \
				-var="region=$(AWS_REGION)"	

init:
	terraform init \
		-backend-config="bucket=$(BACKEND_BUCKET)" \
		-backend-config="region=$(AWS_REGION)"

plan:
	terraform plan

apply:
	terraform apply -auto-approve \
		-var="aws_region=$(AWS_REGION)" \
		-var='azs=$(AZS)' \
		-var="bastion_key=$(BASTION_KEY)" \
		-var="allowed_ip=$(ALLOWED_IP)"

destroy:
	terraform destroy -auto-approve \
		-var="aws_region=$(AWS_REGION)" \
		-var='azs=$(AZS)' \
		-var="bastion_key=$(BASTION_KEY)" \
		-var="allowed_ip=$(ALLOWED_IP)"


# MONITORING
setup-monitoring:
	@echo "🔧 Installing $(RELEASE) in $(NAMESPACE)..."
	helm upgrade --install $(RELEASE) $(CHART) \
		--namespace $(NAMESPACE) --create-namespace \
		-f monitoring/helm/values.yaml

	@echo "🔐 Generate Alert Manager config from template and create secret..."
	@export SMTP_EMAIL=$(SMTP_EMAIL) SMTP_PASS=$(SMTP_PASS); \
	envsubst < monitoring/alerts/alertmanager.yml.tpl | \
	kubectl create secret generic alertmanager-config \
    	--from-file=alertmanager.yaml=/dev/stdin \
    	-n $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

	@echo "🔐 Creating Grafana admin secret..."
	kubectl create secret generic $(SECRET_NAME) \
		--from-literal=admin-user=admin \
		--from-literal=admin-password=admin123 \
		-n $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

	@echo "📊 Creating Grafana dashboard configmap..."
	kubectl create configmap jenkins-dashboard \
		--from-file=dashboard.json=monitoring/dashboard.json \
		-n $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl label configmap jenkins-dashboard grafana_dashboard=1 -n $(NAMESPACE) --overwrite

	@echo "📋 Creating Prometheus alert rules ConfigMap..."
	kubectl apply -f monitoring/alerts/rules.yaml -n $(NAMESPACE)

	@echo "✅ Monitoring stack deployed successfully!"


uninstall-monitoring:
	@echo "🗑️ Uninstalling $(RELEASE) from $(NAMESPACE)..."
	helm uninstall $(RELEASE) -n $(NAMESPACE)
	kubectl delete secret $(SECRET_NAME) -n $(NAMESPACE) --ignore-not-found
	kubectl delete secret alertmanager-config -n $(NAMESPACE) --ignore-not-found
	kubectl delete configmap jenkins-dashboard -n $(NAMESPACE) --ignore-not-found
	kubectl delete configmap prometheus-alert-rules -n $(NAMESPACE) --ignore-not-found


stress:
	@JENKINS_NODE=$$(kubectl get pod -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].spec.nodeName}') && \
	echo "🧠 Launching stress pod on same node: $$JENKINS_NODE" && \
	kubectl run stress-pod --image=polinux/stress --restart=Never \
		--overrides='{"apiVersion":"v1","spec":{"nodeName":"'"$$JENKINS_NODE"'"}}' \
		-- /bin/sh -c "stress --cpu 4 --vm 1 --vm-bytes 256M --timeout 60"

cleanup-stress:
	kubectl delete pod stress-pod --ignore-not-found