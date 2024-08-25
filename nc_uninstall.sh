#!/bin/bash
helm uninstall nextcloud -n nextcloud
kubectl delete pvc --all -n nextcloud