# Containerd

An open and reliable container runtime.

Links:

* [Github repository](https://github.com/containerd/containerd)

## Getting started

### Installing containerd

**Option 1: From the official binaries**

**Step 1: Installing containerd**

```bash
export URL=https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-linux-amd64.tar.gz
wget -P ~/Downloads $URL
export URL=https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-linux-amd64.tar.gz.sha256sum
wget -P ~/Downloads $URL
export FILE=~/Downloads/containerd-1.6.16-linux-amd64.tar.gz
export HASHFILE=~/Downloads/containerd-1.6.16-linux-amd64.tar.gz.sha256sum
echo "$(grep amd64 $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check
echo "$(grep amd64 $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check --status
sudo tar Cxzvf /usr/local $FILE

# systemd
sudo mkdir -p /usr/local/lib/systemd/system
export URL=https://raw.githubusercontent.com/containerd/containerd/v1.6.16/containerd.service
sudo curl -o /usr/local/lib/systemd/system/containerd.service $URL
sudo systemctl daemon-reload
sudo systemctl status containerd
sudo systemctl enable --now containerd
```

**Step 2: Installing runc**

```bash
export URL=https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
wget -P ~/Downloads $URL
export URL=https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64.asc
wget -P ~/Downloads $URL
export URL=https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.sha256sum
wget -P ~/Downloads $URL
export FILE=~/Downloads/runc.amd64
export HASHFILE=~/Downloads/runc.sha256sum
echo "$(grep amd64 $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check
sudo install -m 755 $FILE /usr/local/sbin/runc
```

**Step 3: Installing CNI plugins**

```bash
export URL=https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
wget -P ~/Downloads $URL
export URL=https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz.sha256
wget -P ~/Downloads $URL
export FILE=~/Downloads/cni-plugins-linux-amd64-v1.2.0.tgz
export HASHFILE=~/Downloads/cni-plugins-linux-amd64-v1.2.0.tgz.sha256
echo "$(grep amd64 $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin $FILE

# rootless
sudo chmod 0755 /etc/cni
```
