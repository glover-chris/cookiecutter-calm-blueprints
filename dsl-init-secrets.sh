#####
## This script will populate the ./local creds for target Calm/Prism Central instances.
## CALM_DSL User and PASSWORDS refer to the prism central credentials needed to perform the desired tasks in Calm through DSL.

## CALM_ENVIRONMENT name will be used in Make commands to find the secrets used for PC authentication and blueprint creation with DSL.
## CALM_ENVIRONMENT can be anything you wish but remember it as you will use it in the Make commands and the folder created for the secrets
## will be referenced as ,e.g., .local/$CALM_ENVIRONMENT/secret-files-placed-here
CALM_ENVIRONMENT=$1
CALM_DSL_USER_INPUT=$2
CALM_DSL_PASS_INPUT=$3

CALM_DSL_USER=$CALM_DSL_USER_INPUT
CALM_DSL_PASS=$CALM_DSL_PASS_INPUT

## Secrets needed for the blueprints in this repo in order to compile with CALM DSL without errors.
## Change the values below to what is needed in the environment you will be building the blueprints.
BP_CRED_linux_KEY="test"
BP_CRED_root_PASSWORD="test"
BP_CRED_prism_central_PASSWORD="test"
BP_CRED_windows_PASSWORD="test"
BP_CRED_active_directory_PASSWORD="test"
BP_CRED_phpipam_PASSWORD="test"
BP_CRED_infoblox_PASSWORD="test"
BP_CRED_solarwinds_PASSWORD="test"

ARGS_LIST=($@)

if [ ${#ARGS_LIST[@]} -lt 3 ]; then
	echo 'Usage: ./dsl_init_calm_config.sh [CALM-ENVIRONMENT-NAME] [CALM-DSL-USERNAME] [CALM-DSL-PASSWORD]'
	echo 'Example: ./dsl_init_calm_config.sh calm-enviroment-sitename dsl.user@gso.lab dslpassword'
	exit
fi

if [ ! -d .local/$CALM_ENVIRONMENT ]; then
	mkdir -p .local/$CALM_ENVIRONMENT
fi

echo "Initialize Local Configs"
touch .local/$CALM_ENVIRONMENT/dsl.db
touch .local/$CALM_ENVIRONMENT/config.ini

echo "Updating Local Secrets"
echo $CALM_DSL_USER > .local/$CALM_ENVIRONMENT/calm_dsl_user
echo $CALM_DSL_PASS > .local/$CALM_ENVIRONMENT/calm_dsl_pass
echo $BP_CRED_linux_KEY > .local/$CALM_ENVIRONMENT/BP_CRED_linux_KEY
echo $BP_CRED_root_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_root_PASSWORD
echo $BP_CRED_prism_central_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_prism_central_PASSWORD
echo $BP_CRED_windows_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_windows_PASSWORD
echo $BP_CRED_active_directory_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_active_directory_PASSWORD
echo $BP_CRED_phpipam_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_phpipam_PASSWORD
echo $BP_CRED_infoblox_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_infoblox_PASSWORD
echo $BP_CRED_solarwinds_PASSWORD > .local/$CALM_ENVIRONMENT/BP_CRED_solarwinds_PASSWORD