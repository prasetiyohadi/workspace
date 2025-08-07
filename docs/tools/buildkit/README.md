# Buildkit

Buildkit is a concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit 

Links:

* [Github repository](https://github.com/moby/buildkit)

## Getting started

### Installing buildkit

```bash
export URL=https://github.com/moby/buildkit/releases/download/v0.11.2/buildkit-v0.11.2.linux-amd64.tar.gz
wget -P ~/Downloads $URL
export URL=https://github.com/moby/buildkit/releases/download/v0.11.2/buildkit-v0.11.2.linux-amd64.provenance.json
wget -P ~/Downloads $URL
export URL=https://github.com/moby/buildkit/releases/download/v0.11.2/buildkit-v0.11.2.linux-amd64.sbom.json
wget -P ~/Downloads $URL
export FILE=~/Downloads/buildkit-v0.11.2.linux-amd64.tar.gz
sudo tar Cxzvf /usr/local $FILE

# systemd
sudo mkdir -p /usr/local/lib/systemd/{system,user}
export URL=https://raw.githubusercontent.com/moby/buildkit/v0.11.2/examples/systemd/system/buildkit.service
sudo curl -o /usr/local/lib/systemd/system/buildkit.service $URL
export URL=https://raw.githubusercontent.com/moby/buildkit/v0.11.2/examples/systemd/system/buildkit.socket
sudo curl -o /usr/local/lib/systemd/system/buildkit.socket $URL
export URL=https://raw.githubusercontent.com/moby/buildkit/v0.11.2/examples/systemd/user/buildkit.service
sudo curl -o /usr/local/lib/systemd/user/buildkit.service $URL
export URL=https://raw.githubusercontent.com/moby/buildkit/v0.11.2/examples/systemd/user/buildkit-proxy.service
sudo curl -o /usr/local/lib/systemd/user/buildkit-proxy.service $URL
export URL=https://raw.githubusercontent.com/moby/buildkit/v0.11.2/examples/systemd/user/buildkit-proxy.socket
sudo curl -o /usr/local/lib/systemd/user/buildkit-proxy.socket $URL
sudo systemctl daemon-reload
sudo systemctl status buildkit
systemctl --user daemon-reload
systemctl --user status buildkit
systemctl --user status buildkit-proxy
```
