.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
    match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
    if match:
        target, help = match.groups()
        print("%-40s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

TF_VARS ?= ../../.env/terraform.tfvars
TF_GLOBAL_VARS ?= ../global_variables.tfvars
TF_LOCAL_VARS ?= /dev/null

MAKEFILE_PATH ?= .makefile

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_PATH)

.PHONY: init
init:  ## Run terraform init
	terraform init -no-color


plan: init ## Run terraform plan
	terraform get -update=true -no-color
	terraform plan -var-file=$(TF_GLOBAL_VARS) -var-file=$(TF_VARS) -var-file=$(TF_LOCAL_VARS) -no-color


apply: init ## Run terraform apply
	terraform get -update=true -no-color
	terraform apply -var-file=$(TF_GLOBAL_VARS) -var-file=$(TF_VARS) -var-file=$(TF_LOCAL_VARS) -input=false -auto-approve

