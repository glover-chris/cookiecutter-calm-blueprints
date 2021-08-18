## CALM_ENVIRONMENT default is what was entered when answering the cookiecutter questions.  If you wish to override, pass in the appropriate site, i.e., make init-dsl-config CALM_ENVIRONMENT=oswald.
CALM_ENVIRONMENT ?= {{cookiecutter.calm_environment}}
export CALM_ENVIRONMENT

CALM_ENVIRONMENT_LOWER := $(shell echo ${CALM_ENVIRONMENT} | tr '[:upper:]' '[:lower:]')
CALM_PROJECT ?= {{cookiecutter.calm_project}}

PC_USER := $$(cat .local/${CALM_ENVIRONMENT}/calm_dsl_user)
PC_PASS := $$(cat .local/${CALM_ENVIRONMENT}/calm_dsl_pass)
PC_CRED := $(PC_USER):$(PC_PASS)
PC_PORT ?= 9440
PC_IP_ADDRESS ?= {{cookiecutter.prism_central_ip_address}}
export

DSL_INIT_PARAMS ?=
ifneq (,$(filter $(CALM_ENVIRONMENT),PHX phx))
	# initialize prism central for GSO Phoenix Lab
	PC_IP_ADDRESS = 10.48.108.12
	DSL_INIT_PARAMS = --ip $(PC_IP_ADDRESS) --port ${PC_PORT} --username ${PC_USER} --password ${PC_PASS}
else
	ifneq (,$(filter $(CALM_ENVIRONMENT),AMS ams))
		# initialize prism central for GSO Amsterdam Lab
		PC_IP_ADDRESS = 10.68.97.150
		DSL_INIT_PARAMS = --ip $(PC_IP_ADDRESS) --port ${PC_PORT} --username ${PC_USER} --password ${PC_PASS}
	else
		# initialize prism central based on manually supplied calm dsl init params supplied at runtime.
		DSL_INIT_PARAMS = --ip $(PC_IP_ADDRESS) --project $(CALM_PROJECT) --port ${PC_PORT} --username ${PC_USER} --password ${PC_PASS}
	endif
endif

## Blueprint file location variables.
BLUEPRINT_COOKIECUTTER_FILE_SUFFFIX := {{cookiecutter.blueprintname}}
BLUEPRINT_COOKIECUTTER_IPAM_SOLUTION := {{cookiecutter.ipam_solution}}

## Blueprint naming variables.
BLUEPRINT_SUFFIX_NAME := ${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}

LINUX_IPAM_BP_NAME := "cita-starter-lin-${BLUEPRINT_COOKIECUTTER_IPAM_SOLUTION}-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_IPAM_BP_NAME := "cita-starter-win-${BLUEPRINT_COOKIECUTTER_IPAM_SOLUTION}-${BLUEPRINT_SUFFIX_NAME}"

# Export all variables.
export

# Print environment specific values.
print-env:
	@echo CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	@echo PC_IP_ADDRESS=$(PC_IP_ADDRESS)
	@echo CALM_PROJECT=$(CALM_PROJECT)
	@echo CALM_ENVIRONMENT_LOWER=$(CALM_ENVIRONMENT_LOWER)
	@echo $(shell calm --version)
	@echo $(shell make --version | head -n1)
	@echo $(shell python --version | head -n1)
	@echo $(shell pip --version | awk '{print $1 " " $2}')

## Initialize Calm dsl config and do some quick validations.
## CALM_PROJECT default is what was entered when answering the cookiecutter questions.  If you wish to override, pass in the appropriate calm project. i.e., make init-dsl-config CALM_PROJECT=default.
## CALM_ENVIRONMENT default is what was entered when answering the cookiecutter questions.  If you wish to override, pass in the appropriate site, i.e., make init-dsl-config CALM_ENVIRONMENT=oswald.
## PC_IP_ADDRESS default is what was entered when answering the cookiecutter questions.  If you wish to override, pass in the appropriate site, i.e., make init-dsl-config PC_IP_ADDRESS=x.x.x.x.

CALM_DSL_LOCAL_DIR_LOCATION = $(CURDIR)/.local/${CALM_ENVIRONMENT}/
export CALM_DSL_LOCAL_DIR_LOCATION

INIT_DSL_LOCATION = $(CURDIR)

init-dsl: init-dsl-secrets init-dsl-config

init-dsl-secrets:
	@read -s -p "Enter the username for the Calm environment/IP address you entered in the cookiecutter: " username ; \
	read -s -p "Enter the password for the Calm environment/IP address you entered in the cookiecutter: " password ; \
	$(INIT_DSL_LOCATION)/dsl-init-secrets.sh ${CALM_ENVIRONMENT} $$username $$password
	@rm -rf ~/.calm/dsl.db ~/.calm/init.ini

init-dsl-config: print-env
	# initialize target prism central cluster calm instance
	calm init dsl $(DSL_INIT_PARAMS) --project $(CALM_PROJECT) --local_dir $(CALM_DSL_LOCAL_DIR_LOCATION) --config $(CALM_DSL_LOCAL_DIR_LOCATION)config.ini --db_file $(CALM_DSL_LOCAL_DIR_LOCATION)dsl.db
	calm get projects -n ${CALM_PROJECT}
	calm get server status

############################################################################################################
### DEVELOPMENT TESTING - CREATE BLUEPRINT TASKS
### PURPOSE: Create the corresdponding blueprints in the respective sites, i.e., PHX and AMS

create-all-bps: create-linux-ipam-bp create-windows-ipam-bp ## Create all blueprints on the Calm instance.

create-linux-ipam-bp: ## Create Linux IPAM blueprint on Calm instance.
	make init-dsl-config CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	calm compile bp -f linux/linux_${BLUEPRINT_COOKIECUTTER_FILE_SUFFFIX}.py
	calm create bp -f linux/linux_${BLUEPRINT_COOKIECUTTER_FILE_SUFFFIX}.py --name ${LINUX_IPAM_BP_NAME} --force

create-windows-ipam-bp: ## Create Linux IPAM blueprint on Calm instance.
	make init-dsl-config CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	calm compile bp -f windows/windows_${BLUEPRINT_COOKIECUTTER_FILE_SUFFFIX}.py
	calm create bp -f windows/windows_${BLUEPRINT_COOKIECUTTER_FILE_SUFFFIX}.py --name ${WINDOWS_IPAM_BP_NAME} --force

############################################################################################################
### DEVELOPMENT TESTING - COOKIECUTTER AND CALM DSL DELETE BLUEPRINT TASKS
### PURPOSE: Delete calm dsl created blueprints in the respective sites, i.e., PHX and AMS

delete-all-bps: delete-linux-ipam-bp delete-windows-ipam-bp ## Delete all blueprints from the Calm instance.

delete-linux-ipam-bp: ## Delete the Linux IPAM blueprint from the Calm instance.
	make init-dsl-config CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	calm delete bp ${LINUX_IPAM_BP_NAME}

delete-windows-ipam-bp: ## Delete the Linux IPAM blueprint from the Calm instance.
	make init-dsl-config CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	calm delete bp ${WINDOWS_IPAM_BP_NAME}

## Help listing makefile blocks
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
