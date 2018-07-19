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
 
# Checks to see if Kubernetes Dashboard is required
if [ $dashboard == true ]; then
	echo "Kubernetes Dashboard is required, installing"
  	# Set admin variable
	export KUBECONFIG=/etc/kubernetes/admin.conf
	# Deploy the dashboard
	kubectl create -f $url
else
        echo "Kubernetes Dashboard is not required"
fi
