#!/bin/bash

# setup of ACM procedure
# set -o errexit          # Exit on most errors (see the manual)
# set -o errtrace         # Make sure any error trap is inherited
# set -o nounset          # Disallow expansion of unset variables
# set -o pipefail         # Use last non-zero exit code in a pipeline

export BASE_DIR=$(realpath $(dirname $BASH_SOURCE))


. demo-magic.sh

pe "cat namespaces/bank-of-anthos/priv-pod.yaml"

pe "kubectl apply -f namespaces/bank-of-anthos/priv-pod.yaml"
pe "kubectl get pods -n bank-of-anthos privileged"
pe "kubectl delete pod -n bank-of-anthos privileged"

cat > psp-constraint.yaml <<EOF
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPPrivilegedContainer
metadata:
  name: psp-privileged-container
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces: ["kube-system"]
EOF

pe "cat psp-constraint.yaml"

pe "kubectl apply -f psp-constraint.yaml"

pe "kubectl get K8sPSPPrivilegedContainer"

pe "kubectl apply -f namespaces/bank-of-anthos/priv-pod.yaml"
pe "kubectl get pods -n bank-of-anthos privileged"

pe "kubectl delete -f psp-constraint.yaml"

rm -rf psp-constraint.yaml