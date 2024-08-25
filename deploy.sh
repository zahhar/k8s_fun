#!/bin/bash
apt-get update && apt-get upgrade -y

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal \
         --username f26bdd3b-f140-4d3d-8a72-fa216525d4be \
         --password ${AZ_PWD} \
         --tenant 5537b611-23f3-428b-86e7-808c0da2ed8c

az deployment sub create --location westeurope --template-file az_rg.bicep --parameters admPwd=${ADM_PWD} masterIp=${MASTER_IP}

curl -sfL https://get.k3s.io | sh -
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

kubectl create namespace nextcloud
helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update
helm install nextcloud nextcloud/nextcloud -n nextcloud -f ./nc/nc_values.yaml --set externalDatabase.password=${ADM_PWD} --set nextcloid.password=${ADM_PWD}
