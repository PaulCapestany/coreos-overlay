# Copyright 2014 CoreOS, Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="coreos/mantle"
CROS_WORKON_LOCALNAME="mantle"
CROS_WORKON_REPO="git://github.com"
COREOS_GO_PACKAGE="github.com/coreos/mantle"

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="fd2a3215e5d4a90f6acc7bb5b1e3a91e304671c9" # v0.9.0
	KEYWORDS="amd64 arm64"
fi

inherit coreos-go cros-workon

DESCRIPTION="Mantle: Gluing CoreOS together"
HOMEPAGE="https://github.com/coreos/mantle"
LICENSE="Apache-2"
SLOT="0"
# objcopy/split have trouble with our cross-compiled kolet
STRIP_MASK="/*/kola/*/kolet"

RDEPEND=">=net-dns/dnsmasq-2.72[dhcp,ipv6]"

src_compile() {
	export GO15VENDOREXPERIMENT="1"
	if [[ "${PV}" == 9999 ]]; then
		GO_LDFLAGS="-X ${COREOS_GO_PACKAGE}/version.Version=$(get_semver)"
	else
		GO_LDFLAGS="-X ${COREOS_GO_PACKAGE}/version.Version=${PV}"
	fi

	for cmd in cork gangue kola ore plume; do
		go_build "${COREOS_GO_PACKAGE}/cmd/${cmd}"
	done

	for a in amd64 arm64; do
		mkdir -p "${GOBIN}/${a}"
		CGO_ENABLED=0 GOBIN="${GOBIN}/${a}" GOARCH=${a} go_build "${COREOS_GO_PACKAGE}/cmd/kolet"
	done
}

src_test() {
	./test
}

src_install() {
	for cmd in cork gangue kola ore plume; do
		dobin "${GOBIN}"/"${cmd}"
	done

	for a in amd64 arm64; do
		exeinto /usr/lib/kola/${a}
		doexe "${GOBIN}/${a}/kolet"
	done
}

