#!/bin/bash

set -e
set -o pipefail

{% if deployment_use_lockfile %}
export DEPLOYMENT_LOCK_FILE="/var/run/deployments/{{ deployment_project }}.pid"
{% endif %}
export DEPLOYMENT_COMMAND="{{ deployment_command }}"
{% if deployment_git_upstream is defined %}
export DEPLOYMENT_GIT_UPSTREAM="{{ deployment_git_upstream }}"
{% endif %}
export DEPLOYMENT_GIT_BRANCH="{{ deployment_git_branch }}"
{% if deployment_git_workdir is defined %}
# as deployment_git_workdir
export DEPLOYMENT_GIT_WORKDIR="{{ deployment_git_workdir }}"
{% else %}
# as deployment_recipes_directory / deployment_project
export DEPLOYMENT_GIT_WORKDIR="{{ deployment_recipes_directory }}/{{ deployment_project }}"
{% endif %}
{% if deployment_git_subdir | length %}
export DEPLOYMENT_GIT_SUBDIR="{{ deployment_git_subdir }}"
{% endif %}
{% if deployment_git_keyfile is defined %}
export DEPLOYMENT_GIT_KEYFILE="{{ deployment_git_keyfile }}"
{% endif %}
{% if deployment_skip_checkout_on_existing_dir %}
export DEPLOYMENT_SKIP_CHECKOUT_ON_EXISTING_DIR="yes"
{% endif %}

{% if deployment_skip_logger %}
exec /usr/local/bin/deploy_from_git.sh 
{% else %} 
/usr/local/bin/deploy_from_git.sh 2>&1 | logger -e -s -t "{{deployment_log_prefix}}_{{ deployment_project }}"
{% endif %}
