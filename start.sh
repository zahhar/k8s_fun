#!/bin/bash
# This script is used to start a shell session from LOCAL machine to REMOTE host
master_ip="$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/"//g' )"
az_pwd="PASSWORD" # This is the password for Azure service principal
ssh -t root@185.4.72.4 "export MASTER_IP=${master_ip} && export AZ_PWD=${az_pwd} && export ADM_PWD=PASSWORD; git clone https://github.com/zahhar/k8s_fun.git; sh ./k8s_fun/deploy.sh; /bin/bash -i"
