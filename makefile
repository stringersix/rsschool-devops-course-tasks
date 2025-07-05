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