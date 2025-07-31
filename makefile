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

# JENKINS
setup-jenkins: 
	kubectl apply -f jenkins/admin-binding.yaml
	helm upgrade --install jenkins jenkins/jenkins -n jenkins --create-namespace -f jenkins/helm/values.yaml \
	  	--set mySecrets.smtpEmail="$(SMTP_EMAIL)" \
  		--set mySecrets.smtpPass="$(SMTP_PASS)" \
  		--set mySecrets.grafanaAdminPass="$(GRAFANA_ADMIN_PASS)" \
		--wait



# MONITORING
setup-monitoring:
	bash ./monitoring/setup.sh

uninstall-monitoring:
	@echo "🗑️ Uninstalling prom-stack from monitoring..."
	helm uninstall prom-stack -n monitoring
	kubectl delete secret grafana-admin-secret -n monitoring --ignore-not-found
	kubectl delete secret smtp-auth-secret -n monitoring --ignore-not-found
	kubectl delete configmap jenkins-dashboard -n monitoring --ignore-not-found
	kubectl delete configmap prometheus-alert-rules -n monitoring --ignore-not-found
	kubectl delete alertmanagerconfig email-config -n monitoring --ignore-not-found


stress:
	@JENKINS_NODE=$$(kubectl get pod -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].spec.nodeName}') && \
	echo "🧠 Launching stress pod on same node: $$JENKINS_NODE" && \
	kubectl run stress-pod --image=polinux/stress --restart=Never \
		--overrides='{"apiVersion":"v1","spec":{"nodeName":"'"$$JENKINS_NODE"'"}}' \
		-- /bin/sh -c "stress --cpu 4 --vm 1 --vm-bytes 256M --timeout 60"

cleanup-stress:
	kubectl delete pod stress-pod --ignore-not-found