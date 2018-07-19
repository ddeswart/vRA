#!/bin/bash

# Source: https://mapr.com/blog/making-data-actionable-at-scale-part-2-of-3/
# Dimitri de Swart - VMguru
# Version 1.0
# 19 July 2018

# Need to have in the software component a property 'varTokenToJoin' of type 'String' mapped to 'varTokenToJoin' of 'Master Config'.

# Log $PATH
echo "Intial PATH = $PATH"

# Update PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin/:/root/bin
echo "New PATH = $PATH"

# Node joining Kubernetes cluster  
varTokenToJoin=$1
echo "Token to join in 'K8S-JoinCluster.sh' : $varTokenToJoin"
MasterNode=$2
echo "MasterNode in 'K8S-JoinCluster.sh' : $MasterNode"
kubeadm join $MasterNode:6443 --discovery-token-unsafe-skip-ca-verification --token $varTokenToJoin
