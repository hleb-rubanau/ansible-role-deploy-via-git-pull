# Usage

## Convenience script (initial provisioning of your project from git storage)

```
export DEPLOYMENT_GIT_UPSTREAM=<url of a git repo to clone>
export DEPLOYMENT_COMMAND='./deploy.sh'
### extra parameters:
#     DEPLOYMENT_GIT_KEYFILE  -- file with SSH identity key
#     DEPLOYMENT_GIT_WORKDIR -- alternative checkout location (default: /usr/local/etc/recipes/bootstrap )
#     DEPLOYMENT_GIT_BRANCH -- git branch to use if not master
#     DEPLOYMENT_GIT_SUBDIR -- subdirectory under working tree to cd into before executing DEPLOYMENT_COMMAND
curl -s https://raw.githubusercontent.com/hleb-rubanau/ansible-role-deploy-via-git-pull/master/files/deploy_from_git.sh | /bin/bash
```

## Regular updates (ansible role)

### requirements.yml

Add following to requirements.yml 

```
- src: https://github.com/hleb-rubanau/ansible-role-deploy-via-git-pull
  name: deploy-via-git-pull
```

Run `ansible-galaxy install -r requirements.yml roles/`

### Ansible variables

Mandatory:

1. ```deployment_project``` -- symbolic name of the recipes set (is used in logging etc.)
2. ```deployment_command``` -- command to run inside git repo to deploy the configuration (default: deploy.sh)
3. ```deployment_git_upstream``` (optional, but either it or deployment_recipe_directory must be defined) -- url of a git repo to cloune
4. ```deployment_git_branch``` (optional) -- branch to switch to
5. ```deployment_git_subdir``` (optional) -- subdirectory inside git repo to switch to before running command
6. ```deployment_git_keyfile``` (optional) -- SSH private key file to use (unless authentication is already handled for the session)
7. ```deployment_recipes_directory``` (optional, default: `/usr/local/etc/recipes/`) -- directory to handle recipes (git worktrees) named after projects
8. ```deployment_use_cron``` (optional, default: no) -- whether to install cron task for regular run of the task
  8. ```deployment_cron_schedule``` (optional, default: ```{minute: '*/20'}```) -- dictionary, cron schedule for git pulls
9. ```deployment_dedicated_user``` (optional, default: no) -- whether to setup a dedicated user for external invocation of deployments via SSH
  9. ```deployment_dedicated_user_name```
  9. ```deployment_dedicated_user_keys``` -- list of public SSH keys for dedicated user
  9. ```deployment_dedicated_user_restrict``` -- whether to restrict dedicated user keys to only be able to run the deployment command
10. ```deployment_use_lockfile``` (optional, default: no)  -- whether to use lock file to prevent parallel deployment runs

# In playbook:
Add role deploy-via-git-pull

