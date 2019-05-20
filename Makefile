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

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


.PHONY: bootstrap
bootstrap: ## bootstrap the development environment
	pip install -U "pip ~= 19.1"
	pip install -U "setuptools ~= 41.0"
	pip install -r requirements/requirements.txt \
		-r requirements/requirements_setup.txt \
		-r requirements/requirements_test.txt
	pip install --editable .


.PHONY: test
test: ## run tests
	python setup.py test

.PHONY: install
install: ## install the package
	python setup.py install

.PHONY: script
script:
	ci-runner $(shell cat enabled_modules)


.PHONY: plan
plan:  ## run terraform plan on the all modules
	@for module in $(shell cat enabled_modules); \
	do \
		echo $$module ; \
		make -C "terraform/$$module" plan ; \
	done
