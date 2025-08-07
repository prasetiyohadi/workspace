DIR ?= ${HOME}/Downloads
OS_TYPE ?= linux-amd64

# Buildkit
BUILDKIT_GIT = https://github.com/moby/buildkit.git
BUILDKIT_RAW = https://raw.githubusercontent.com/moby/buildkit
BUILDKIT_RELEASE = https://github.com/moby/buildkit/releases/download
BUILDKIT_VERSION ?= $(shell ./get-latest.sh ${BUILDKIT_GIT})
BUILDKIT_PKG = buildkit-v${BUILDKIT_VERSION}.${OS_TYPE}
BUILDKIT_SYSTEMD_SYSTEM = ${BUILDKIT_RAW}/v${BUILDKIT_VERSION}/examples/systemd/system/buildkit
BUILDKIT_SYSTEMD_USER = ${BUILDKIT_RAW}/v${BUILDKIT_VERSION}/examples/systemd/user/buildkit
BUILDKIT_URL = ${BUILDKIT_RELEASE}/v${BUILDKIT_VERSION}/${BUILDKIT_PKG}

dir:
	mkdir -p ${DIR}

clean:
	@echo "# Cleaning buildkit..."
	rm -fv ${DIR}/${BUILDKIT_PKG}.tar.gz
	rm -fv ${DIR}/${BUILDKIT_PKG}.provenance.json
	rm -fv ${DIR}/${BUILDKIT_PKG}.sbom.json

download: dir
	@echo "# Downloading buildkit..."
	wget -P ${DIR} ${BUILDKIT_URL}.tar.gz
	wget -P ${DIR} ${BUILDKIT_URL}.provenance.json
	wget -P ${DIR} ${BUILDKIT_URL}.sbom.json

install:
	@echo "# Installing buildkit..."
	sudo tar Cxzvf /usr/local ${DIR}/${BUILDKIT_PKG}.tar.gz

systemd:
	sudo mkdir -p /usr/local/lib/systemd/{system,user}
	sudo curl -o /usr/local/lib/systemd/system/buildkit.service ${BUILDKIT_SYSTEMD_SYSTEM}.service
	sudo curl -o /usr/local/lib/systemd/system/buildkit.socket ${BUILDKIT_SYSTEMD_SYSTEM}.socket
	sudo curl -o /usr/local/lib/systemd/user/buildkit.service ${BUILDKIT_SYSTEMD_USER}.service
	sudo curl -o /usr/local/lib/systemd/user/buildkit-proxy.service ${BUILDKIT_SYSTEMD_USER}-proxy.service
	sudo curl -o /usr/local/lib/systemd/user/buildkit-proxy.socket ${BUILDKIT_SYSTEMD_USER}-proxy.socket
	sudo systemctl daemon-reload
	sudo systemctl status buildkit
	systemctl --user daemon-reload
	systemctl --user status buildkit
	systemctl --user status buildkit-proxy

.PHONY: dir clean download install systemd
