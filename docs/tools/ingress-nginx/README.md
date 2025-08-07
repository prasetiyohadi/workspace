# Ingress-nginx

## Getting Started

* install helm repository
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

* create ingress-nginx namespace
```
kubectl create namespace ingress-nginx
```

* install helm Chart
```
helm install -n ingress-nginx ingress-nginx ingress-nginx/ingress-nginx
```

* detect installed version
```
POD_NAME=$(kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n ingress-nginx -it $POD_NAME -- /nginx-ingress-controller --version
```

* test the ingress-nginx installation
```
export BASE_HOST=<your_ingress_base_host>
kubectl apply -f $(sed "s/BASE_HOST/$BASE_HOST/g" deployment.yaml)
```

## Issue with ingress-nginx webhook

[Github issue #5401](https://github.com/kubernetes/ingress-nginx/issues/5401)

If there are errors in the ingress-nginx deployment, use the patch patch/ingress-nginx-admission.yaml for error related to validatingwebhookconfigurations.
```
kubectl patch -n ingress-nginx validatingwebhookconfigurations ingress-nginx-admission --patch "$(cat patch/ingress-nginx-admission.yaml)"
```

The other solution is to disable controller.admissionWebhooks.enabled on the helm installation.
```
helm upgrade -n ingress-nginx ingress-nginx ingress-nginx/ingress-nginx --set controller.admissionWebhooks.enabled=false
```
