include .env
export

format:
	terraform fmt -recursive

init-core:
	cd core && terraform init

apply-core:
	cd core && terraform apply -auto-approve

destroy-core:
	cd core && terraform apply -auto-approve

init:
	terraform init \
		-backend-config="bucket=$(BACKEND_BUCKET)" \
		-backend-config="region=$(BACKEND_REGION)"

plan:
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve