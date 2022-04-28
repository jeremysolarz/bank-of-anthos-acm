#!/bin/bash

# setup of ACM procedure
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

export BASE_DIR=$(realpath $(dirname $BASH_SOURCE))

. env.sh

. demo-magic.sh


######################################################
# Change in repo
######################################################
if [ ! -d "$REPO_NAME" ]; then
  # clone repo
  git clone git@github.com:${GIT_USER}/${REPO_NAME}.git
fi

# watch ClusterRolebinding
pe "kubectl get rolebindings -n bank-of-anthos pod-creators -o yaml"

# (in another termin) edit
pe "vim ${REPO_NAME}/namespace/bank-of-anthos/pod-creator-rolebinding.yaml"

# add to subjects
# - kind: User
#  name: developer2@bank-of-anthos.com
#  apiGroup: rbac.authorization.k8s.io

pe "kubectl get rolebindings -n bank-of-anthos pod-creators -o yaml"

pe "cd ${REPO_NAME}"
# commit changes
pe "git add namespaces/bank-of-anthos/pod-creator-rolebinding.yaml"
pe "git commit -m 'Add developer2 to pod-creator'"
pe "git push"

pe "kubectl get rolebindings -n bank-of-anthos pod-creator -o yaml"

pe "export HASH=$(git rev-parse HEAD)"

# revert change
pe "git revert $HASH"
pe "git push"

pe "kubectl get rolebindings -n bank-of-anthos pod-creator -o yaml"
