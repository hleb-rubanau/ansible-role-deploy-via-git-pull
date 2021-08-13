#!/bin/bash

# curl -s https://raw.githubusercontent.com/hleb-rubanau/ansible-role-deploy-via-git-pull/master/bootstrap.sh | /bin/bash

set -e
set -o pipefail
export LC_ALL=C

say() { echo "$*" >&2 ; }
die() { say "ERROR: $*" ; exit 1; }

eval "$( curl -s  https://gitlab.com/Rubanau/cloud-tools/raw/master/envvars_check.sh )"

# while DEPLOYMENT_GIT_WORKDIR is optional, bootstrap enforces explicit setup 
# to minimize confusions

envvars_check_abort_if_missing DEPLOYMENT_GIT_UPSTREAM \
                               DEPLOYMENT_COMMAND      \
                               DEPLOYMENT_GIT_WORKDIR   

envvars_check_warn_if_missing DEPLOYMENT_GIT_KEYFILE    \
                              DEPLOYMENT_GIT_BRANCH

envvars_check_report DEPLOYMENT_GIT_UPSTREAM            \
                     DEPLOYMENT_GIT_WORKDIR             \
                     DEPLOYMENT_GIT_SUBDIR              \
                     DEPLOYMENT_GIT_BRANCH              \
                     DEPLOYMENT_COMMAND                 \
                     DEPLOYMENT_GIT_KEYFILE             

# some optional flags are omitted as they are unlikely useful in bootstrapping
# (e.g. DEPLOYMENT_SKIP_CHECKOUT_ON_EXISTING_DIR, DEPLOYMENT_LOCK_FILE) 


DEPLOYER_SCRIPT_URL=https://raw.githubusercontent.com/hleb-rubanau/ansible-role-deploy-via-git-pull/master/files/deploy_from_git.sh 
say "Running $DEPLOYER_SCRIPT_URL"
curl -s $DEPLOYER_SCRIPT_URL | /bin/bash
