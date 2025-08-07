# Kube-prometheus-stack

Kube-prometheus-stack [Helm Chart page](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md)

## Getting Started

**Add Helm repository**

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

**Update Helm repository**

```
helm repo update
```

**Create namespace**

```
kubectl create namespace prometheus
```

**Install kube-prometheus-stack Chart**

```
helm install -n prometheus prometheus prometheus-community/kube-prometheus-stack
```

**Use values from the file local/values.yml to enable ingress using domain 127.0.0.1.sslip.io**

```
helm install -n prometheus prometheus prometheus-community/kube-prometheus-stack -f local/values.yml
```

## Note for Kubernetes from Docker-Desktop

[Github issue #467](https://github.com/prometheus-community/helm-charts/issues/467) [kube-prometheus-stack] node-exporter crashes at startup

[Pull Request #757](https://github.com/prometheus-community/helm-charts/pull/757) [prometheus-node-exporter] Allow to opt-out node exporter rootfs mount

**Patch for `values.yml`**

```
prometheus-node-exporter:
  hostRootFsMount: false
```

## Note for ARM/ARM64 Support

[Github issue #373](https://github.com/prometheus-community/helm-charts/issues/373) [kube-prometheus-stack] ARM Support

[Pull Request #703](https://github.com/prometheus-community/helm-charts/pull/703) [kube-prometheus-stack] Upgrade to latest kube-state-metrics chart

**Alternative fix to iInstall kube-prometheus-stack chart in ARM/ARM64**

```
helm install -n prometheus prometheus prometheus-community/kube-prometheus-stack -f arm/values.yml
```
