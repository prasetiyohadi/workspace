# Cert-manager

[Cert-manager](https://cert-manager.io/) is a tool to automatically provision and manage TLS certificates in Kubernetes.

[Github repository](https://github.com/jetstack/cert-manager)

## Getting Started

* install helm repository
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

* create cert-manager namespace
```
kubectl create namespace cert-manager
```

* install cert-manager plugin for kubectl
```
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v1.2.0/kubectl-cert_manager-linux-amd64.tar.gz
tar -zxvf kubectl-cert-manager.tar.gz
sudo install -m 755 kubectl-cert_manager /usr/local/bin/kubectl-cert_manager
```

* install helm Chart
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --create-namespace --set installCRDs=true
```

* get all resources in cert-manager namespace
```
kubectl get all -n cert-manager -o wide
```

## Cert-manager Issuer

### Self-signed

* create cert-manager self-signed issuer
```
kubectl apply -f self-signed-issuer.yaml
```

### Securing NGINX Ingress Controller with Let's Encrypt


* install NGINX Ingress Controller and assign a DNS name to the ingress-controller external IP

* deploy a service
```
kubectl apply -f deployment.yaml
```

* deploy cert-manager

* create cert-manager staging let's encrypt issuer
```
kubectl apply -f staging-issuer.yaml
```

* create cert-manager production let's encrypt issuer
```
kubectl apply -f production-issuer.yaml
```

* deploy a TLS ingress resource
```
kubectl apply -f ingress-tls.yaml
```
