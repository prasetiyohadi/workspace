# Nerdctl

contaiNERD CTL - Docker-compatible CLI for containerd, with support for Compose, Rootless, eStargz, OCIcrypt, IPFS, ...

[Github repository](https://github.com/containerd/nerdctl/)

## Introduction

### Rootless mode

See https://rootlesscontaine.rs/getting-started/common/ for the prerequisites.

To launch rootless containerd:

```
$ containerd-rootless-setuptool.sh install
```

To run a container with rootless containerd:

```
$ nerdctl run -d -p 8080:80 --name nginx nginx:alpine
```

See [./docs/rootless.md](https://github.com/containerd/nerdctl/blob/main/docs/rootless.md).

## Install

Binaries are available here: https://github.com/containerd/nerdctl/releases

In addition to [containerd](https://github.com/containerd/containerd), the following components should be installed:

- [CNI plugins](https://github.com/containernetworking/plugins): for using `nerdctl run`.
  - v1.1.0 or later is highly recommended. Older versions require extra [CNI isolation plugin](https://github.com/AkihiroSuda/cni-isolation) for isolating bridge networks (`nerdctl network create`).
- [BuildKit](https://github.com/moby/buildkit) (OPTIONAL): for using `nerdctl build`. BuildKit daemon (buildkitd) needs to be running. See also [the document about setting up BuildKit](https://github.com/containerd/nerdctl/blob/main/docs/build.md).
  - v0.11.0 or later is highly recommended. Some features, such as pruning caches with `nerdctl system prune`, do not work with older versions.
- [RootlessKit](https://github.com/rootless-containers/rootlesskit) and [slirp4netns](https://github.com/rootless-containers/slirp4netns) (OPTIONAL): for [Rootless mode](https://github.com/containerd/nerdctl/blob/main/docs/rootless.md)
  - RootlessKit needs to be v0.10.0 or later. v0.14.1 or later is recommended.
  - slirp4netns needs to be v0.4.0 or later. v1.1.7 or later is recommended.

These dependencies are included in `nerdctl-full-<VERSION>-<OS>-<ARCH>.tar.gz`, but not included in `nerdctl-<VERSION>-<OS>-<ARCH>.tar.gz`.

## Add-ons

### BuildKit

To enable BuildKit with containerd worker, run the following command:

```
$ CONTAINERD_NAMESPACE=default containerd-rootless-setuptool.sh install-buildkit-containerd
```

To enable BuildKit with OCI worker, run the following command:

```
$ containerd-rootless-setuptool.sh install-buildkit
```
