# Kubernetes Resource Monitoring by example

Medium article: TODO

**NOTICE**
If some of the Prometheus queries are not working for you it might be because of `pod_name` or `container_name` have been renamed to `pod` and `container` in other metrics-server version.



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


## monitor

### Run Grafana
```
./run/grafana.sh
```
Then head to http://localhost:3000/login

User: admin

Password: printed in the terminal output.

#### install Dashboard
Go to http://localhost:3000/dashboard/import and import the dashboard from `i/grafana/dashboard.json`




### Use resources
Change the `i/k8s/deploy.yaml`.

Or exec into the running pod and make it use resources.

```
# cpu
kubectl exec -it compute-7bc79fcc8-jd5c4 stress -- -cpus 1

# memory
kubectl exec -it compute-b57fb48cd-km6wn bash
> /usr/local/bin/stress --cpu 1 --io 4 --vm 1 --vm-bytes 400M
```


# Prometheus queries

## cpu
```
# container usage
rate (container_cpu_usage_seconds_total{pod_name=~"compute-.*", image!="", container!="POD"}[5m])

# container requests
avg(kube_pod_container_resource_requests_cpu_cores{pod=~"compute-.*"})

# container limits
avg(kube_pod_container_resource_limits_cpu_cores{pod=~"compute-.*"})

# throttling
sum(rate(container_cpu_cfs_throttled_seconds_total{pod=~"compute-.*", container!="POD", image!=""}[5m]))
```

## memory
```
# container usage
container_memory_working_set_bytes{pod_name=~"compute-.*", image!="", container!="POD"}

# container requests
avg(kube_pod_container_resource_requests_memory_bytes{pod=~"compute-.*"})

# container limits
avg(kube_pod_container_resource_limits_memory_bytes{pod=~"compute-.*"})
```
