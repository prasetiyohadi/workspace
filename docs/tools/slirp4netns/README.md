# Slirp4netns

User-mode networking for unprivileged network namespaces

Links:

* [Github repository](https://github.com/rootless-containers/slirp4netns)

## Installation

**Install directly**

```bash
mkdir -p ~/.local/bin
curl -o ~/.local/bin/slirp4netns --fail -L https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.0/slirp4netns-$(uname -m)
chmod +x ~/.local/bin/slirp4netns
```

**Check SHA256SUM**

```bash
rm ~/Downloads/SHA256SUMS ~/Downloads/SHA256SUMS.asc
export URL=https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.0/slirp4netns-$(uname -m)
wget -P ~/Downloads $URL
export URL=https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.0/SHA256SUMS
wget -P ~/Downloads $URL
export URL=https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.0/SHA256SUMS.asc
wget -P ~/Downloads $URL
export FILE=~/Downloads/slirp4netns-$(uname -m)
export HASHFILE=~/Downloads/SHA256SUMS
echo "$(grep $(uname -m) $HASHFILE | awk '{print $1}') $FILE" | sha256sum --check
mkdir -p ~/.local/bin
install -m 755 $FILE ~/.local/bin/slirp4netns
```
