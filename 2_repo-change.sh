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
pe "kubectl get clusterrolebindings namespace-readers -o yaml"

# (in another termin) edit
pe "vim ${REPO_NAME}/cluster/namespace-reader-clusterrolebinding.yaml"

# add to subjects
# - kind: User
#  name: jane@bank-of-anthos.com
#  apiGroup: rbac.authorization.k8s.io

pe "kubectl get clusterrolebindings namespace-readers -o yaml"

pe "cd ${REPO_NAME}"
# commit changes
pe "git add cluster/namespace-reader-clusterrolebinding.yaml"
pe "git commit -m 'Add Jane to namespace-reader'"
pe "git push"

pe "kubectl get clusterrolebindings namespace-readers -o yaml"

pe "export HASH=$(git rev-parse HEAD)"

# revert change
pe "git revert $HASH"
pe "git push"

pe "kubectl get clusterrolebindings namespace-readers -o yaml"
