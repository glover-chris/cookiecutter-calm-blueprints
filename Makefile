## Set Calm environment variable.  Default to PHX.
## To override, pass in variables as part of the make call, e.g.,make create-phx-dhcp_bps CALM_ENVIRONMENT=oswald CALM_PROJECT=default.
CALM_ENVIRONMENT ?= PHX
export CALM_ENVIRONMENT

CALM_ENVIRONMENT_LOWER := $(shell echo ${CALM_ENVIRONMENT} | tr '[:upper:]' '[:lower:]')
CALM_PROJECT ?= pracdev-cap

PC_USER := $$(cat .local/${CALM_ENVIRONMENT}/calm_dsl_user)
PC_PASS := $$(cat .local/${CALM_ENVIRONMENT}/calm_dsl_pass)
PC_CRED := $(PC_USER):$(PC_PASS)
PC_PORT ?= 9440
PC_IP_ADDRESS ?=
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

## Getting local git repository details.
GIT_COMMIT_ID     := $(shell git rev-parse --short HEAD)
GIT_BRANCH_NAME   := $(shell git rev-parse --abbrev-ref HEAD | head -c14)

## Blueprint naming variables.
BLUEPRINT_SUFFIX_NAME := ${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}

LINUX_BP_NAME_DHCP := "cita-starter-lin-dhcp-${BLUEPRINT_SUFFIX_NAME}"
LINUX_BP_NAME_STATIC_IP := "cita-starter-lin-static-ip-${BLUEPRINT_SUFFIX_NAME}"
LINUX_BP_NAME_PHPIPAM := "cita-starter-lin-phpipam-${BLUEPRINT_SUFFIX_NAME}"
LINUX_BP_NAME_INFOBLOX := "cita-starter-lin-infoblox-${BLUEPRINT_SUFFIX_NAME}"
LINUX_BP_NAME_SOLARWINDS := "cita-starter-lin-solarwinds-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_BP_NAME_DHCP := "cita-starter-win-dhcp-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_BP_NAME_STATIC_IP := "cita-starter-win-static-ip-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_BP_NAME_PHPIPAM := "cita-starter-win-phpipam-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_BP_NAME_INFOBLOX := "cita-starter-win-infoblox-${BLUEPRINT_SUFFIX_NAME}"
WINDOWS_BP_NAME_SOLARWINDS := "cita-starter-win-solarwinds-${BLUEPRINT_SUFFIX_NAME}"

# Export all variables.
export

# Print environment specific values.
print-env:
	@echo CALM_ENVIRONMENT=${CALM_ENVIRONMENT}
	@echo PC_IP_ADDRESS=$(PC_IP_ADDRESS)
	@echo PC_USER=$(PC_USER)
	@echo PC_PASS=$(PC_PASS)
	@echo DSL_INIT_PARAMS=$(DSL_INIT_PARAMS)
	@echo CALM_PROJECT=$(CALM_PROJECT)
	@echo CALM_ENVIRONMENT_LOWER=$(CALM_ENVIRONMENT_LOWER)
	@echo $(shell calm --version)
	@echo $(shell make --version | head -n1)
	@echo $(shell python --version | head -n1)
	@echo $(shell pip --version | awk '{print $1 " " $2}')

## Initialize calm config and do some quick validations.
## CALM_PROJECT default is pracdev-cap.  If you wish to override, pass in the appropriate calm project. i.e., make init-dsl-config CALM_PROJECT=default.
## CALM_ENVIRONMENT default is PHX.  If you wish to override, pass in the appropriate site, i.e., make init-dsl-config CALM_ENVIRONMENT=oswald.
## For sites other than GSO Phoenix or Amsterdam, pass in the approriate IP for the prism central calm instance, i.e., make init-dsl-config PC_IP_ADDRESS= 10.x.x.x CALM_ENVIRONMENT=oswald CALM_PROJECT=default
CALM_DSL_LOCAL_DIR_LOCATION = $(CURDIR)/.local/${CALM_ENVIRONMENT}/

init-dsl-config: print-env
	# initialize target prism central cluster calm instance
	calm init dsl $(DSL_INIT_PARAMS) --project $(CALM_PROJECT) --local_dir $(CALM_DSL_LOCAL_DIR_LOCATION) --config $(CALM_DSL_LOCAL_DIR_LOCATION)config.ini --db_file $(CALM_DSL_LOCAL_DIR_LOCATION)dsl.db
	calm get projects -n ${CALM_PROJECT}
	calm get server status

####################################################################
### COOKIECUTTER TASKS - Commands to create various cookiecutter projects locally.
### PURPOSE: Create local Calm blueprints with cookiecutter.

    ## Use the below to create blueprints for any environment
cookiecutter-bps-user-input:
	git submodule update --init
	cookiecutter -v ./ -f

    ## Phoenix GSOLAB SPECIFIC COMMANDS

cookiecutter-phx-bps-user-input: ## Creates Cookiecutter Phoenix IPAM blueprints locally asking for user input for site config and cookiecutter.json variable values
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml

cookiecutter-phx-bps-pipeline: ## Creates Cookiecutter Phoenix IPAM blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml --no-input

cookiecutter-phx-dhcp_bps: ## Creates Cookiecutter Phoenix DHCP blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml ipam_solution=dhcp -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_dhcp -f --no-input

cookiecutter-phx-static_ip_bps: ## Creates Cookiecutter Phoenix Static IP blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml ipam_solution=static_ip -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_staticip -f --no-input

cookiecutter-phx-phpipam_bps: ## Creates Cookiecutter Phoenix PHPIpam blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml ipam_solution=phpipam -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_phpipam -f --no-input

cookiecutter-phx-infoblox_bps: ## Creates Cookiecutter Phoenix InfoBlox blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml ipam_solution=infoblox -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_infoblox -f --no-input

cookiecutter-phx-solarwinds_bps: ## Creates Cookiecutter Phoenix Solarwinds blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/phx_config.yaml ipam_solution=solarwinds -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_solarwinds -f --no-input

    ## AMSTERDAM GSOLAB SPECIFIC COMMANDS

cookiecutter-ams-bps-user-input: ## Creates Cookiecutter Amsterdam IPAM blueprints locally asking for user input for site config and cookiecutter.json variable values
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml

cookiecutter-ams-bps-pipeline: ## Creates Cookiecutter Amsterdam IPAM blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml --no-input

cookiecutter-ams-dhcp_bps: ## Creates Cookiecutter Amsterdam DHCP blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml ipam_solution=dhcp -o ./blueprints_ams_dhcp -f --no-input

cookiecutter-ams-static_ip_bps: ## Creates Cookiecutter Amsterdam Static IP blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml ipam_solution=static_ip -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_staticip -f --no-input

cookiecutter-ams-phpipam_bps: ## Creates Cookiecutter Amsterdam PHPIpam blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml ipam_solution=phpipam -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_phpipam -f --no-input

cookiecutter-ams-infoblox_bps:## Creates Cookiecutter Amsterdam InfoBlox blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml ipam_solution=infoblox -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_infoblox -f --no-input

cookiecutter-ams-solarwinds_bps: ## Creates Cookiecutter Amsterdam Solarwinds blueprints locally with default values from site config and cookiecutter.json
	git submodule update --init
	cookiecutter -v ./ --config-file ./site_configuration_files/ams_config.yaml ipam_solution=solarwinds -o ./blueprints_$(CALM_ENVIRONMENT_LOWER)_solarwinds -f --no-input

############################################################################################################
### DEVELOPMENT TESTING - COOKIECUTTER AND CALM DSL CREATE BLUEPRINT TASKS
### PURPOSE: Create local cookiecutter projects and have calm dsl create the corresdponding blueprints in the respective sites, i.e., PHX and AMS

create-bps-user-input:
	make cookiecutter-bps-user-input
	calm init dsl --port ${PC_PORT} --username ${PC_USER} --password ${PC_PASS}

    ## Phoenix and Amsterdam GSOLAB SPECIFIC COMMAND to create all blueprints in both GSOLAB sites.
create-all-bps: create-phx-all_bps create-ams-all_bps  ## Creates ALL Cookiecutter Phoenix and Amsterdam IPAM blueprints locally and in Calm instance

    ## Phoenix GSOLAB SPECIFIC COMMANDS

create-phx-all_bps: create-phx-dhcp_bps create-phx-static_ip_bps create-phx-phpipam_bps create-phx-infoblox_bps create-phx-solarwinds_bps ## Creates all Cookiecutter Phoenix IPAM blueprints locally and in CALM instance

create-phx-dhcp_bps: ## Creates Cookiecutter Phoenix DHCP blueprints locally and in CALM instance
	make cookiecutter-phx-dhcp_bps
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm compile bp -f ./blueprints_phx_dhcp/blueprints_phx/linux/linux_phx_blueprint.py
	calm create bp -f ./blueprints_phx_dhcp/blueprints_phx/linux/linux_phx_blueprint.py --name ${LINUX_BP_NAME_DHCP} --force
	calm compile bp -f ./blueprints_phx_dhcp/blueprints_phx/windows/windows_phx_blueprint.py
	calm create bp -f ./blueprints_phx_dhcp/blueprints_phx/windows/windows_phx_blueprint.py --name ${WINDOWS_BP_NAME_DHCP} --force

create-phx-static_ip_bps:## Creates Cookiecutter Phoenix Static IP blueprints locally and in CALM instance
	make cookiecutter-phx-static_ip_bps
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm compile bp -f ./blueprints_phx_staticip/blueprints_phx/linux/linux_phx_blueprint.py
	calm create bp -f ./blueprints_phx_staticip/blueprints_phx/linux/linux_phx_blueprint.py --name ${LINUX_BP_NAME_STATIC_IP} --force
	calm compile bp -f ./blueprints_phx_staticip/blueprints_phx/windows/windows_phx_blueprint.py
	calm create bp -f ./blueprints_phx_staticip/blueprints_phx/windows/windows_phx_blueprint.py --name ${WINDOWS_BP_NAME_STATIC_IP} --force

create-phx-phpipam_bps:## Creates Cookiecutter Phoenix PHPIpam blueprints locally and in CALM instance
	make cookiecutter-phx-phpipam_bps
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm compile bp -f ./blueprints_phx_phpipam/blueprints_phx/linux/linux_phx_blueprint.py
	calm create bp -f ./blueprints_phx_phpipam/blueprints_phx/linux/linux_phx_blueprint.py --name ${LINUX_BP_NAME_PHPIPAM} --force
	calm compile bp -f ./blueprints_phx_phpipam/blueprints_phx/windows/windows_phx_blueprint.py
	calm create bp -f ./blueprints_phx_phpipam/blueprints_phx/windows/windows_phx_blueprint.py --name ${WINDOWS_BP_NAME_PHPIPAM} --force

create-phx-infoblox_bps:## Creates Cookiecutter Phoenix InfoBlox blueprints locally and in CALM instance
	make cookiecutter-phx-infoblox_bps
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm compile bp -f ./blueprints_phx_infoblox/blueprints_phx/linux/linux_phx_blueprint.py
	calm create bp -f ./blueprints_phx_infoblox/blueprints_phx/linux/linux_phx_blueprint.py --name ${LINUX_BP_NAME_INFOBLOX} --force
	calm compile bp -f ./blueprints_phx_infoblox/blueprints_phx/windows/windows_phx_blueprint.py
	calm create bp -f ./blueprints_phx_infoblox/blueprints_phx/windows/windows_phx_blueprint.py --name ${WINDOWS_BP_NAME_INFOBLOX} --force

create-phx-solarwinds_bps: ## Creates Cookiecutter Phoenix Solarwinds blueprints locally and in CALM instance
	make cookiecutter-phx-solarwinds_bps
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm compile bp -f ./blueprints_phx_solarwinds/blueprints_phx/linux/linux_phx_blueprint.py
	calm create bp -f ./blueprints_phx_solarwinds/blueprints_phx/linux/linux_phx_blueprint.py --name ${LINUX_BP_NAME_SOLARWINDS} --force
	calm compile bp -f ./blueprints_phx_solarwinds/blueprints_phx/windows/windows_phx_blueprint.py
	calm create bp -f ./blueprints_phx_solarwinds/blueprints_phx/windows/windows_phx_blueprint.py --name ${WINDOWS_BP_NAME_SOLARWINDS} --force

    ## AMSTERDAM GSOLAB SPECIFIC COMMANDS

create-ams-all_bps: create-ams-dhcp_bps create-ams-static_ip_bps create-ams-phpipam_bps create-ams-infoblox_bps create-ams-solarwinds_bps ## Creates all Cookiecutter Amsterdam IPAM blueprints locally and in CALM instance

create-ams-dhcp_bps: ## Creates Cookiecutter Amsterdam DHCP blueprints locally and in CALM instance
	make cookiecutter-ams-dhcp_bps
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm compile bp -f ./blueprints_ams_dhcp/blueprints_ams/linux/linux_ams_blueprint.py
	calm create bp -f ./blueprints_ams_dhcp/blueprints_ams/linux/linux_ams_blueprint.py --name ${LINUX_BP_NAME_DHCP} --force
	calm compile bp -f ./blueprints_ams_dhcp/blueprints_ams/windows/windows_ams_blueprint.py
	calm create bp -f ./blueprints_ams_dhcp/blueprints_ams/windows/windows_ams_blueprint.py --name ${WINDOWS_BP_NAME_DHCP} --force

create-ams-static_ip_bps: ## Creates Cookiecutter Amsterdam Static IP blueprints locally and in CALM instance
	make cookiecutter-ams-static_ip_bps
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm compile bp -f ./blueprints_ams_staticip/blueprints_ams/linux/linux_ams_blueprint.py
	calm create bp -f ./blueprints_ams_staticip/blueprints_ams/linux/linux_ams_blueprint.py --name ${LINUX_BP_NAME_STATIC_IP} --force
	calm compile bp -f ./blueprints_ams_staticip/blueprints_ams/windows/windows_ams_blueprint.py
	calm create bp -f ./blueprints_ams_staticip/blueprints_ams/windows/windows_ams_blueprint.py --name ${WINDOWS_BP_NAME_STATIC_IP} --force

create-ams-phpipam_bps: ## Creates Cookiecutter Amsterdam PHPIpam blueprints locally and in CALM instance
	make cookiecutter-ams-phpipam_bps
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm compile bp -f ./blueprints_ams_phpipam/blueprints_ams/linux/linux_ams_blueprint.py
	calm create bp -f ./blueprints_ams_phpipam/blueprints_ams/linux/linux_ams_blueprint.py --name ${LINUX_BP_NAME_PHPIPAM} --force
	calm compile bp -f ./blueprints_ams_phpipam/blueprints_ams/windows/windows_ams_blueprint.py
	calm create bp -f ./blueprints_ams_phpipam/blueprints_ams/windows/windows_ams_blueprint.py --name ${WINDOWS_BP_NAME_PHPIPAM} --force

create-ams-infoblox_bps: ## Creates Cookiecutter Amsterdam InfoBlox blueprints locally and in CALM instance
	make cookiecutter-ams-infoblox_bps
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm compile bp -f ./blueprints_ams_infoblox/blueprints_ams/linux/linux_ams_blueprint.py
	calm create bp -f ./blueprints_ams_infoblox/blueprints_ams/linux/linux_ams_blueprint.py --name ${LINUX_BP_NAME_INFOBLOX} --force
	calm compile bp -f ./blueprints_ams_infoblox/blueprints_ams/windows/windows_ams_blueprint.py
	calm create bp -f ./blueprints_ams_infoblox/blueprints_ams/windows/windows_ams_blueprint.py --name ${WINDOWS_BP_NAME_INFOBLOX} --force

create-ams-solarwinds_bps: ## Creates Cookiecutter Amsterdam Solarwinds blueprints locally and in CALM instance
	make cookiecutter-ams-solarwinds_bps
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm compile bp -f ./blueprints_ams_solarwinds/blueprints_ams/linux/linux_ams_blueprint.py
	calm create bp -f ./blueprints_ams_solarwinds/blueprints_ams/linux/linux_ams_blueprint.py --name ${LINUX_BP_NAME_SOLARWINDS} --force
	calm compile bp -f ./blueprints_ams_solarwinds/blueprints_ams/windows/windows_ams_blueprint.py
	calm create bp -f ./blueprints_ams_solarwinds/blueprints_ams/windows/windows_ams_blueprint.py --name ${WINDOWS_BP_NAME_SOLARWINDS} --force

############################################################################################################
### DEVELOPMENT TESTING - COOKIECUTTER AND CALM DSL DELETE BLUEPRINT TASKS
### PURPOSE: Delete calm dsl created blueprints in the respective sites, i.e., PHX and AMS

delete-all-bps: delete-phx-all_bps delete-ams-all_bps ## Deletes ALL Phoenix and Amsterdam IPAM blueprints in CALM instance

    ## PHOENIX GSOLAB SPECIFIC COMMANDS

delete-phx-all_bps: delete-phx-dhcp_bps delete-phx-static_ip_bps delete-phx-phpipam_bps delete-phx-infoblox_bps delete-phx-solarwinds_bps ## Deletes ALL Phoenix IPAM blueprints

delete-phx-dhcp_bps: ## Deletes Phoenix DHCP blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm delete bp ${LINUX_BP_NAME_DHCP}
	calm delete bp ${WINDOWS_BP_NAME_DHCP}

delete-phx-static_ip_bps: ## Deletes Phoenix Static IP blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm delete bp ${LINUX_BP_NAME_STATIC_IP}
	calm delete bp ${WINDOWS_BP_NAME_STATIC_IP}

delete-phx-phpipam_bps: ## Deletes Phoenix PHPIpam blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm delete bp ${LINUX_BP_NAME_PHPIPAM}
	calm delete bp ${WINDOWS_BP_NAME_PHPIPAM}

delete-phx-infoblox_bps: ## Deletes Phoenix InfoBlox blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm delete bp ${LINUX_BP_NAME_INFOBLOX}
	calm delete bp ${WINDOWS_BP_NAME_INFOBLOX}

delete-phx-solarwinds_bps: ## Deletes Phoenix Solarwinds blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=PHX
	calm delete bp ${LINUX_BP_NAME_SOLARWINDS}
	calm delete bp ${WINDOWS_BP_NAME_SOLARWINDS}

    ## AMSTERDAM GSOLAB SPECIFIC COMMANDS

delete-ams-all_bps: delete-ams-dhcp_bps delete-ams-static_ip_bps delete-ams-phpipam_bps delete-ams-infoblox_bps delete-ams-solarwinds_bps ## Deletes ALL Amsterdam IPAM blueprints in CALM instance

delete-ams-dhcp_bps: ## Deletes Amsterdam DHCP blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm delete bp ${LINUX_BP_NAME_DHCP}
	calm delete bp ${WINDOWS_BP_NAME_DHCP}

delete-ams-static_ip_bps: ## Deletes Amsterdam Static IP blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm delete bp ${LINUX_BP_NAME_STATIC_IP}
	calm delete bp ${WINDOWS_BP_NAME_STATIC_IP}

delete-ams-phpipam_bps: ## Deletes Amsterdam PHPIpam blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm delete bp ${LINUX_BP_NAME_PHPIPAM}
	calm delete bp ${WINDOWS_BP_NAME_PHPIPAM}

delete-ams-infoblox_bps: ## Deletes Amsterdam InfoBlox blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm delete bp ${LINUX_BP_NAME_INFOBLOX}
	calm delete bp ${WINDOWS_BP_NAME_INFOBLOX}

delete-ams-solarwinds_bps: ## Deletes Amsterdam Solarwinds blueprints in CALM instance
	make init-dsl-config CALM_ENVIRONMENT=AMS
	calm delete bp ${LINUX_BP_NAME_SOLARWINDS}
	calm delete bp ${WINDOWS_BP_NAME_SOLARWINDS}

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

NAME    := nutanixservices/cita-starter

blueprints:
	if [ ! -d "./blueprints" ]; then cookiecutter ./ --no-input -v; fi
	#source ${CALMDSL}/venv/bin/activate
	calm create bp --file ./blueprints/linux/blueprint_f1_dhcp.py --name cita-starter-linux-f1-dhcp
	calm create bp --file ./blueprints/linux/blueprint_f2_static.py --name cita-starter-linux-f2-static
	calm create bp --file ./blueprints/linux/blueprint_f3_phpipam.py --name cita-starter-linux-f3-phpipam
	calm create bp --file ./blueprints/linux/blueprint_f4_infoblox.py --name cita-starter-linux-f4-infoblox
	calm create bp --file ./blueprints/linux/blueprint_f5_solarwinds.py --name cita-starter-linux-f5-solarwinds
	calm create bp --file ./blueprints/windows/blueprint_f1_dhcp.py --name cita-starter-windows-f1-dhcp
	calm create bp --file ./blueprints/windows/blueprint_f2_static.py --name cita-starter-windows-f2-static
	calm create bp --file ./blueprints/windows/blueprint_f3_phpipam.py --name cita-starter-windows-f3-phpipam
	calm create bp --file ./blueprints/windows/blueprint_f4_infoblox.py --name cita-starter-windows-f4-infoblox
	calm create bp --file ./blueprints/windows/blueprint_f5_solarwinds.py --name cita-starter-windows-f5-solarwinds
