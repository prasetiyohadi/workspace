# Argo-cd

## Getting Started

* create argocd namespace
```
kubectl create namespace argocd
```

* install argo-cd stable manifests
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

* install argocd CLI
```
./argocd.sh
```

* expose the argo-cd API server using service type LoadBalancer
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

* get the initial password for argo-cd API server
```
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name \
    | cut -d'/' -f 2
```

* login using the CLI with username `admin`
```
argocd login <argocd_server>
```

* change argo-cd API server password
```
argocd account update-password
```

* register a cluster to deploy applications to (i.e. kind-kind cluster)
```
argocd cluster add kind-kind
```

* create an application from a git repository
```
argocd app create guestbook \
    --repo https://github.com/argoproj/argocd-example-apps.git \
    --path guestbook --dest-server https://kubernetes.default.svc \
    --dest-namespace default
```

* view the application status
```
argocd app get guestbook
```

* sync (deploy) the application
```
argocd app sync guestbook
```
