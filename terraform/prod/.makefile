include ../../.makefile

plan: init ## Run terraform plan
	terraform get -update=true -no-color
	terraform plan -var-file=../../global_variables.tfvars -var-file=../../terraform.tfvars -no-color


apply: init ## Run terraform apply
	terraform get -update=true
	terraform apply -var-file=../../global_variables.tfvars -var-file=../../terraform.tfvars -input=false -auto-approve
