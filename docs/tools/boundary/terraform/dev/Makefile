DIR = $(notdir $(shell pwd))

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

.PHONY: cmd-exists-%

cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || \
		(echo "ERROR: '$(*)' must be installed and available on your PATH."; exit 1)

fmt: cmd-exists-terraform
	terraform fmt

init: cmd-exists-terraform fmt
	terraform init

init-remote: cmd-exists-terraform
	terraform init \
		-backend-config="storage_account_name=$(TF_STATE_BLOB_ACCOUNT_NAME)" \
		-backend-config="container_name=$(TF_STATE_BLOB_CONTAINER_NAME)" \
		-backend-config="key=$(TF_STATE_BLOB_FILE)" \
		-backend-config="sas_token=$(TF_STATE_BLOB_SAS_TOKEN)"

plan: cmd-exists-terraform fmt
	terraform plan -out "$(DIR).tfplan"

apply: cmd-exists-terraform
	terraform apply

apply-plan: cmd-exists-terraform
	terraform apply "$(DIR).tfplan"

refresh: cmd-exists-terraform
	terraform apply -refresh-only

destroy: cmd-exists-terraform
	terraform destroy
