---
tags:
  - Helm
  - Kubernetes
---

# Helm

Helm install script

```
curl -fsSL -o helm/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
```

## Getting started

**Commands**

```
# getting-started
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm search repo stable
helm repo update
helm install stable/mysql --generate-name
helm show chart stable/mysql
helm show all stable/mysql
helm ls
helm uninstall <release name>
```

## Install chart from hub

**Commands**

```
# install chart from hub
helm search hub awx
helm repo add lifen https://honestica.github.io/lifen-charts/
helm search repo lifen
helm install lifen/awx --version 1.2.1 --generate-name
```

## Troubleshoot

- No internet access (<https://github.com/ubuntu/microk8s/issues/75>)

```
# restart microk8s
sudo snap disable microk8s
sudo snap enable microk8s
# traffic forward is blocked
sudo iptables -P FORWARD ACCEPT
```

- Change DNS forwarder (<https://github.com/ubuntu/microk8s/issues/75>)

```
# edit coredns configmap
microk8s.kubectl edit -n kube-system cm/coredns
```
