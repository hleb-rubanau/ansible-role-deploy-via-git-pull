#!/bin/bash

set -e
set -o pipefail

{% if deployment_use_lockfile %}
export DEPLOYMENT_LOCK_FILE="/var/run/deployments/{{ deployment_project }}.pid"
{% end %}
export DEPLOYMENT_COMMAND="{{ deployment_command }}"
{% if deployment_git_upstream is defined %}
export DEPLOYMENT_GIT_UPSTREAM="{{ deployment_git_upstream }}"
{% endif %}
export DEPLOYMENT_GIT_BRANCH="{{ deployment_git_branch }}"
export DEPLOYMENT_GIT_WORKDIR="{{ deployment_recipes_directory }}/{{ deployment_project }}"
export DEPLOYMENT_GIT_BRANCH="{{ deployment_git_branch }}"
{% if len(deployment_git_subdir)>0 %}
export DEPLOYMENT_GIT_SUBDIR="{{ deployment_git_subdir }}"
{% endif %}
{% if deployment_git_keyfile is defined %}
export DEPLOYMENT_GIT_KEYFILE="{{ deployment_git_keyfile }}"
{% endif %}

/usr/local/bin/deploy_from_git.sh 2>&1 | logger -s -t "deploy_{{ deployment_project }}"
