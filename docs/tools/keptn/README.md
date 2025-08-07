# Keptn

[Keptn](https://keptn.sh/) is a Cloud-native application life-cycle orchestration. Keptn automates your SLO-driven multi-stage delivery and operations & remediation of your applications.

[Github repository](https://github.com/keptn/keptn)

## Quick Start

1. Create local k3d cluster. Therefore, you need to install [k3d](https://k3d.io/) if not already present on your machine. You can skip this if k3d is already available on your machine.

```
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v4.4.4 bash
```

Now, let’s start a cluster for Keptn!

```
k3d cluster create mykeptn -p "8082:80@agent[0]" --k3s-server-arg '--no-deploy=traefik' --agents 1
```

2. Download and install the [Keptn CLI](https://keptn.sh/docs/0.9.x/reference/cli)

```
curl -sL https://get.keptn.sh | bash
```

3. Install Keptn control-plane and execution-plane for continuous delivery use case

```
keptn install --use-case=continuous-delivery
```

Keptn comes with different installation options, please have a look at the [installation documentation](https://keptn.sh/docs/0.9.x/operate) for more details on cluster requirements, resource consumption, supported Kubernetes versions, and more.

4. Install and configure Istio for Ingress + continuous delivery use-case

```
curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/master/content/docs/quickstart/exposeKeptnConfigureIstio.sh | bash
```

5. (Optional but recommended) Create a demo project with multi-stage pipeline + SLO-based quality gates

```
curl -SL https://raw.githubusercontent.com/keptn/keptn.github.io/master/content/docs/quickstart/get-demo.sh | bash
```

6. Explore Keptn! Please have a look at our [tutorials](https://tutorials.keptn.sh/) and [documentation](https://keptn.sh/docs/) to learn how you can use Keptn.

7. If you are finished exploring Keptn, you can always stop and start the cluster and delete it eventually.

```
k3d cluster stop mykeptn
k3d cluster start mykeptn
```

Or delete it if you don’t need it anymore

```
k3d cluster delete mykeptn
```
