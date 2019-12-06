#! /bin/bash

### this is a helper script, which can be used directly (e.g. for initial provisioning)
### shortcut: 
# export DEPLOYMENT_GIT_UPSTREAM=<yoururl> DEPLOYMENT_COMMAND="./deploy.sh" 
# curl -s https://raw.githubusercontent.com/hleb-rubanau/ansible-role-deploy-via-git-pull/master/files/deploy_from_git.sh | /bin/bash
### extra parameters:
###     DEPLOYMENT_GIT_KEYFILE  -- file with SSH identity key
###     DEPLOYMENT_GIT_WORKDIR -- alternative checkout location (default: /usr/local/etc/recipes/bootstrap )
###     DEPLOYMENT_GIT_BRANCH -- git branch to use if not master
###     DEPLOYMENT_GIT_SUBDIR -- subdirectory under working tree to cd into before executing DEPLOYMENT_COMMAND
set -e

function say() { echo "$*" >&2 ; }
function die() { say "ERROR: $*" ; exit 1; }

DEPLOYMENT_GIT_WORKDIR=${DEPLOYMENT_GIT_WORKDIR:-/usr/local/etc/recipes/bootstrap}

if [ -z "$DEPLOYMENT_COMMAND" ]; then die "DEPLOYMENT_COMMAND must be configured" ; fi
if [ -z "$DEPLOYMENT_GIT_UPSTREAM" ] && [ ! -e "$DEPLOYMENT_GIT_WORKDIR" ]; then die "DEPLOYMENT_GIT_UPSTREAM must be configured" ; fi
if [ -z "$DEPLOYMENT_GIT_KEYFILE" ]; then
    say "WARNING: no DEPLOYMENT_GIT_KEYFILE specified, assuming ssh identity is already in place";
else
    export GIT_SSH="ssh -i $DEPLOYMENT_GIT_KEYFILE"
    chmod -v 0600 $DEPLOYMENT_GIT_KEYFILE    
fi 

if [ ! -z "$DEPLOYMENT_LOCK_FILE" ] ; then
    if [ -e "$DEPLOYMENT_LOCK_FILE" ]; then
        die "Lock file $DEPLOYMENT_LOCK_FILE is in place, doing nothing"
    else
        DEPLOYMENT_LOCK_FILE_PARENT_DIR=$( dirname "$DEPLOYMENT_LOCK_FILE" )
        mkdir -p "$DEPLOYMENT_LOCK_FILE_PARENT_DIR"
        echo "$$" > $DEPLOYMENT_LOCK_FILE
    fi
fi

DEPLOYMENT_GIT_BRANCH=${DEPLOYMENT_GIT_BRANCH:-master}
DEPLOYMENT_GIT_WORKDIR_PARENT=$( dirname "$DEPLOYMENT_GIT_WORKDIR" )

mkdir -pv "$DEPLOYMENT_GIT_WORKDIR_PARENT"

if [ ! -e "$DEPLOYMENT_GIT_WORKDIR" ]; then
    say "Cloning $DEPLOYMENT_GIT_UPSTREAM to $DEPLOYMENT_GIT_WORKDIR"
    cd "$DEPLOYMENT_GIT_WORKDIR_PARENT" ;
    BASE_GIT_DIR=$( basename "$DEPLOYMENT_GIT_WORKDIR" )

    git clone "$DEPLOYMENT_GIT_UPSTREAM" "$BASE_GIT_DIR"
    cd "$BASE_GIT_DIR"

    if [ "$DEPLOYMENT_GIT_BRANCH" != "master" ]; then
        git checkout -t "origin/$DEPLOYMENT_GIT_BRANCH"
    fi
else
    cd "$DEPLOYMENT_GIT_WORKDIR"
    git checkout $DEPLOYMENT_GIT_BRANCH
fi

say "On branch $DEPLOYMENT_GIT_BRANCH, pulling"
git pull

if [ ! -z "$DEPLOYMENT_GIT_SUBDIR" ]; then
    say "cd $DEPLOYMENT_GIT_SUBDIR"
    cd "$DEPLOYMENT_GIT_SUBDIR"
fi

say "Running deployment command: $DEPLOYMENT_COMMAND"
if [ ! -z "$DEPLOYMENT_LOCK_FILE" ]; then
    exec $DEPLOYMENT_COMMAND
else
    $DEPLOYMENT_COMMAND 
    result=$?
    rm -v $DEPLOYMENT_LOCK_FILE
    exit $result
fi
