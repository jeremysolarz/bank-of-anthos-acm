#!/bin/bash

# setup of ACM procedure
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

export BASE_DIR=$(realpath $(dirname $BASH_SOURCE))

./env.sh

. demo-magic.sh

######################################################
# TEST CONFIG MANAGEMENT
######################################################

# list cluster roles
pe "kubectl get clusterroles -l app.kubernetes.io/managed-by=configmanagement.gke.io"

# list roles
pe "kubectl get clusterrolebinding --all-namespaces -l app.kubernetes.io/managed-by=configmanagement.gke.io"
#
## pod security policies
pe "kubectl get resourcequota --all-namespaces -l app.kubernetes.io/managed-by=configmanagement.gke.io"
#
## attempt to modify
pe "kubectl delete secret jwt-key -n bank-of-anthos"
#
## test
pe "kubectl get secret -n bank-of-anthos"
#
## examine ClusterRole
# pe "kubectl get clusterrole namespace-reader -o yaml --watch"
#
## edit role (remove watch)
# kubectl edit clusterrole namespace-reader


