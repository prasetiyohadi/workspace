# Rootlesskit

Linux-native "fake root" for implementing rootless containers

Links:

* [Github repository](https://github.com/rootless-containers/rootlesskit)

## Requirements

```bash
sudo apt update
sudo apt install -y uidmap
```

## Installation

**Install directly**

```bash
mkdir -p ~/.local/bin
curl -sSL https://github.com/rootless-containers/rootlesskit/releases/download/v1.1.0/rootlesskit-$(uname -m).tar.gz | tar Cxzv ~/.local/bin
```

**Check SHA256SUM**

```bash
rm ~/Downloads/SHA256SUMS ~/Downloads/SHA256SUMS.asc
export URL=https://github.com/rootless-containers/rootlesskit/releases/download/v1.1.0/rootlesskit-$(uname -m).tar.gz
wget -P ~/Downloads $URL
export URL=https://github.com/rootless-containers/rootlesskit/releases/download/v1.1.0/SHA256SUMS
wget -P ~/Downloads $URL
export URL=https://github.com/rootless-containers/rootlesskit/releases/download/v1.1.0/SHA256SUMS.asc
wget -P ~/Downloads $URL
export FILE=~/Downloads/rootlesskit-$(uname -m).tar.gz
export HASHFILE=~/Downloads/SHA256SUMS
echo "$(grep $(uname -m) $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check
mkdir -p ~/.local/bin
tar Cxzvf ~/.local/bin $FILE
```

## Optional: cgroup v2

Source: [[Optional] cgroup v2](https://rootlesscontaine.rs/getting-started/common/cgroup2/)

### Checking whether cgroup v2 is already enabled

If `/sys/fs/cgroup/cgroup.controllers` is present on your system, you are using v2, otherwise you are using v1.

```bash
# check if cgroup v2 is already enabled
cat /sys/fs/cgroup/cgroup.controllers
```

### Enabling cgroup v2

Enabling cgroup v2 for containers requires kernel 4.15 or later. Kernel 5.2 or later is recommended.

And yet, delegating cgroup v2 controllers to non-root users requires a recent version of systemd. systemd 244 or later is recommended.

To boot the host with cgroup v2, add the following string to the `GRUB_CMDLINE_LINUX` line in `/etc/default/grub` and then run `sudo update-grub`.

```
systemd.unified_cgroup_hierarchy=1
```

For ubuntu on azure, you should add this in `/etc/default/grub.d/50-cloudimg-settings.cfg`

### Enabling CPU, CPUSET, and I/O delegation

By default, a non-root user can only get `memory` controller and `pids` controller to be delegated.

```bash
cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.controllers
```

To allow delegation of other controllers such as `cpu`, `cpuset`, and `io`, run the following commands:

```bash
sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload
```

Delegating `cpuset` is recommended as well as `cpu`. Delegating `cpuset` requires systemd 244 or later.

After changing the systemd configuration, you need to re-login or reboot the host. Rebooting the host is recommended.
