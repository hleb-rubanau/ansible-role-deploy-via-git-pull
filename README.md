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
3. ```deployment_git_upstream``` -- url of a git repo to cloune
4. ```deployment_git_branch``` (optional) -- branch to switch to
5. ```deployment_git_subdir``` (optional) -- subdirectory inside git repo to switch to before running command
6. ```deployment_git_keyfile``` (optional) -- SSH private key file to use (unless authentication is already handled for the session)

    
# In playbook:
Add role deploy-via-git-pull

