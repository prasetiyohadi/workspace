# Datadog Agent

[Datadog Agent](https://github.com/DataDog/datadog-agent)

[https://docs.datadoghq.com/](https://docs.datadoghq.com/)

## Datadog Agent and local Kubernetes (docker-desktop) integration

**Add helm repository for datadog agent**

```
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

**Create datadog namespace**

```
kubectl create namespace datadog
```

**Create datadog environment file**

`local/.env`

```
export DD_API_KEY=<datadog api key>
```

**Change datadog environment file permission**

```
chmod og-rwx local/.env
```

**Install datadog Helm Chart in Kubernetes**

```
source local/.env && helm install -n datadog datadog datadog/datadog --set datadog.apiKey=$DD_API_KEY -f local/values.yaml
```

**Upgrade existing datadog Release**

```
source local/.env && helm upgrade -n datadog datadog datadog/datadog --set datadog.apiKey=$DD_API_KEY -f local/values.yaml
```
