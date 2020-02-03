# Kubernetes Resource Monitoring by example

Medium article: TODO

## run yourself

### You need a cluster, like with Gcloud:
```
gcloud container clusters create resources --num-nodes 3 --zone europe-west3-b --machine-type n1-standard-2
```

### Install helm repos:
Helmfile is used for managing helm repos.
```
kubectl create ns grafana
kubectl create ns prometheus

# if you need to install metrics-server create the namespace and uncomment code in i/helm/helmfile.yaml
#kubectl create ns metrics-server

cd i/helm
helmfile diff
helmfile sync
```

### Install k8s test app:
```
kubectl apply -f i/k8s
```


### Run Grafana
```
./run/grafana.sh
```
Then head to http://localhost:3000/login.

User: admin

Password: printed in the terminal output.



### Use resources
```
k exec -it compute-7bc79fcc8-jd5c4 stress -- -cpus 1
```


# Prometheus queries
```
sum (rate (container_cpu_usage_seconds_total{pod_name=~"compute-.*"}[5m]))
```
