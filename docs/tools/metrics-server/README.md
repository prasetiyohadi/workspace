# Metrics-server

## Getting Started

### Install metrics-server from kubernetes-sigs repository

* install metrics server using kubectl
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Install metrics-server from Bitnami Helm Charts repository

* install helm repository
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

* create metrics-server namespace
```
kubectl create namespace metrics-server
```

* create metrics-server configuration values file for your installation (i.e. linode)
```
vi linode.yaml
```

* check pod resource usage
```
kubectl top pod <pod_name>
```

* install helm Chart
```
helm install -n metrics-server metrics-server bitnami/metrics-server -f linode.yaml
```

* get all resources in metrics-server namespace
```
kubectl -n metrics-server get all -o wide
```

## Troubleshooting

### Install metrics-server in kubernetes in docker-desktop

* patch the metrics-server deployment using this command
```
kubectl patch deployment metrics-server -n kube-system --type json \
    -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-",
    "value": "--kubelet-insecure-tls"}]'
```

### Install metrics-server in kubernetes in docker (kind) cluster

* Github issue: https://github.com/kubernetes-sigs/kind/issues/398

* kubernetes deployment using kind (kubernetes in docker) needs the following
  configuration for the metrics-server container
```
    args:
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
```

* update the metrics-server installation manifest for kind cluster or patch
  using kubectl from this [Github gist](https://gist.github.com/sanketsudake/a089e691286bf2189bfedf295222bd43)
```
kubectl patch deployment metrics-server -n kube-system --type json \
    -p '[{"op": "replace", "path": "/spec/template/spec/containers/0/args",
    "value": [
        "--cert-dir=/tmp",
        "--secure-port=443",
        "--kubelet-insecure-tls",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s"
    ]}]'
```
