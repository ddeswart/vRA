#!/bin/bash

# Source: https://virtualhobbit.com/2018/02/05/deploying-kubernetes-with-vrealize-automation/
# Dimitri de Swart - VMguru
# Version 1.0
# 19 July 2018

# Log $PATH
echo "Intial PATH = $PATH"

# Update PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin/:/root/bin
echo "New PATH = $PATH"
 
# Set admin variable
export KUBECONFIG=/etc/kubernetes/admin.conf

# Create Service account
# Source: http://www.joseluisgomez.com/containers/kubernetes-dashboard/
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF

# Create ClusterRoleBinding
# Source: http://www.joseluisgomez.com/containers/kubernetes-dashboard/
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF

# Expose Dashboard outside the cluster
kubectl patch service kubernetes-dashboard -n kube-system -p '{"spec":{"type":"NodePort"}}'

# Get external port
nodePort=$(kubectl get services kubernetes-dashboard -n kube-system -o jsonpath='{.spec.ports[0].nodePort}')

# Get token
# Source: http://www.joseluisgomez.com/containers/kubernetes-dashboard/
dashToken=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | awk '$1=="token:"{print $2}')

echo
echo
echo "Use your browser to connect to the Kubernetes Master on TCP/"$nodePort
echo
echo "Once connected, use the following token to authenticate:"
echo
echo $dashToken
