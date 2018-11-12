#!/bin/bash

# Source: https://mapr.com/blog/making-data-actionable-at-scale-part-2-of-3/
# Dimitri de Swart - VMguru
# Version 1.0
# 19 July 2018

# Log $PATH
echo "Intial PATH = $PATH"

# Update PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
echo "New PATH = $PATH"

# Validate the ip-address of the node:
hostname --ip-address

# Initialize Kubernetes master
kubeadm init --kubernetes-version=v1.12.2 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(hostname --ip-address) --token-ttl 0  

# The kubeadm command will take a few minutes and it will print a 'kubeadm join'
# command once completed. Make sure to capture and store this 'kubeadm join'
# command as it is required to add other nodes to the Kubernetes cluster

# start  your cluster
echo "Initial HOME = $HOME"
export HOME=/root
echo "New HOME = $HOME"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel for network
# Doc: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#44-joining-your-nodes
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# Validate all pods are running
# WAIT TILL EVERYTHING IS UP AND RUNNING : we consider that there are 8 pods to start
echo "CHECK PODS STATUS (Must be running)"
sleep 5
nbRunning=`kubectl get pods --all-namespaces | grep Running | wc -l`
echo "nbRunning = $nbRunning"
while [[ "$nbRunning" -lt "8" ]]; do
	sleep 5
	nbRunning=`kubectl get pods --all-namespaces | grep Running | wc -l`
	echo "nbRunning = $nbRunning"
done
echo "Kubernetes Master is ready"

# Export token for joining the cluster
# Necessary to have in the software component a property varTokenToJoin of type Computed value
varTokenToJoin=`kubeadm token list | grep token | awk '{print $1}'`
echo "varTokenToJoin in 'K8s-MasterConfig.sh' = $varTokenToJoin"
rm -f /tmp/k8stoken
echo $varTokenToJoin > /tmp/k8stoken
