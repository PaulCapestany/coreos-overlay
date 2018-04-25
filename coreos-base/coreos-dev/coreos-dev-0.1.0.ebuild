# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="CoreOS Desktop (meta package)"
HOMEPAGE="http://coreos.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="selinux apparmor"


################################################################################
#
# READ THIS BEFORE ADDING PACKAGES TO THIS EBUILD!
#
################################################################################
#
# Every coreos dependency (along with its dependencies) is included in the
# release image -- more packages contribute to longer build times, a larger
# image, slower and bigger auto-updates, increased security risks, etc. Consider
# the following before adding a new package:
#
# 1. Does the package really need to be part of the release image?
#
# Some packages can be included only in the developer or test images, i.e., the
# chromeos-dev or chromeos-test ebuilds. If the package will eventually be used
# in the release but it's still under development, consider adding it to
# chromeos-dev initially until it's ready for production.
#
# 2. Why is the package a direct dependency of the chromeos ebuild?
#
# It makes sense for some packages to be included as a direct dependency of the
# chromeos ebuild but for most it doesn't. The package should be added as a
# direct dependency of the ebuilds for all packages that actually use it -- in
# time, this ensures correct builds and allows easier cleanup of obsolete
# packages. For example, if a utility will be invoked by the session manager,
# its package should be added as a dependency in the chromeos-login ebuild. Or
# if the package adds a daemon that will be started through an upstart job, it
# should be added as a dependency in the chromeos-init ebuild. If the package
# really needs to be a direct dependency of the chromeos ebuild, consider adding
# a comment why the package is needed and how it's used.
#
# 3. Are all default package features and dependent packages needed?
#
# The release image should include only packages and features that are needed in
# the production system. Often packages pull in features and additional packages
# that are never used. Review these and consider pruning them (e.g., through USE
# flags).
#
# 4. What is the impact on the image size?
#
# Before adding a package, evaluate the impact on the image size. If the package
# and its dependencies increase the image size significantly, consider
# alternative packages or approaches.
#
# 5. Is the package needed on all targets?
#
# If the package is needed only on some target boards, consider making it
# conditional through USE flags in the board overlays.
#
################################################################################

RDEPEND=">=sys-apps/baselayout-3.0.0"

# Optionally enable SELinux and pull in policy for containers
RDEPEND="${RDEPEND}
	sys-apps/dbus[selinux?]
	sys-apps/systemd[selinux?]
	selinux? (
		sec-policy/selinux-virt
	)
	apparmor? (
		sec-policy/apparmor-profiles
		sys-apps/apparmor
	)"

# Only applicable or available on amd64
RDEPEND="${RDEPEND}
	amd64? (
		app-crypt/go-tspi
	)"

RDEPEND="${RDEPEND}
	app-admin/mayday
	app-admin/sdnotify-proxy
	app-admin/sudo
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
	app-arch/torcx
	app-arch/unzip
	app-arch/xz-utils
	app-arch/zip
	app-crypt/gnupg
	app-crypt/pinentry
	app-crypt/tpmpolicy
	app-editors/neovim
	app-misc/ca-certificates
	app-misc/jq
	app-shells/bash
	app-shells/bash-completion
	app-text/tree
	coreos-base/coreos-init
	dev-util/indent
	dev-util/strace
	dev-vcs/git
	media-gfx/feh
	media-gfx/scrot
	media-sound/alsa-utils
	net-analyzer/nmap
	net-analyzer/tcpdump
	net-dns/bind-tools
	net-firewall/ebtables
	net-firewall/ipset
	net-firewall/iptables
	net-firewall/nftables
	net-fs/nfs-utils
	net-misc/bridge-utils
	net-misc/curl
	net-misc/dhcp
	net-misc/iputils
	net-misc/networkmanager
	net-misc/ntp
	net-misc/openssh
	net-misc/rsync
	net-misc/socat
	net-misc/wget
	net-misc/whois
	net-vpn/openvpn
	sys-apps/coreutils
	sys-apps/dbus
	sys-apps/diffutils
	sys-apps/ethtool
	sys-apps/file
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/grep
	sys-apps/iproute2
	sys-apps/kexec-tools
	sys-apps/less
	sys-apps/lshw
	sys-apps/net-tools
	sys-apps/nvme-cli
	sys-apps/pciutils
	sys-apps/rng-tools
	sys-apps/sed
	sys-apps/seismograph
	sys-apps/shadow
	sys-apps/the_silver_searcher
	sys-apps/usbutils
	sys-apps/util-linux
	sys-apps/which
	sys-block/open-iscsi
	sys-cluster/ipvsadm
	sys-devel/bc
	sys-devel/gcc
	sys-devel/make
	sys-devel/patch
	sys-fs/btrfs-progs
	sys-fs/dosfstools
	sys-fs/e2fsprogs
	sys-fs/mdadm
	sys-fs/multipath-tools
	sys-fs/quota
	sys-fs/xfsprogs
	sys-kernel/coreos-firmware
	sys-kernel/coreos-kernel
	sys-libs/glibc
	sys-libs/nss-usrfiles
	sys-libs/timezone-data
	sys-process/lsof
	sys-process/procps
	x11-base/xorg-drivers
	x11-base/xorg-server
	x11-misc/dmenu
	x11-misc/i3lock
	x11-misc/i3status
	x11-misc/xclip
	x11-misc/xcompmgr
	x11-terms/rxvt-unicode
	x11-wm/i3
	"
