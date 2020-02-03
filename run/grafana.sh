#!/usr/bin/env bash
echo "Password: " && kubectl get secret -n grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode
echo
kubectl port-forward -n grafana service/grafana 3000:80
