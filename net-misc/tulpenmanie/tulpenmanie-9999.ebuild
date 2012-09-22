# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_COMPAT="python2_7"

inherit eutils git-2 python-distutils-ng

DESCRIPTION="Graphica speculatio platform, supports Bitstamp, BTC-e, CampBX, MtGox."
HOMEPAGE="https://github.com/3M3RY/${PN}"
EGIT_REPO_URI="git://github.com/3M3RY/tulpenmanie.git \
			   https://github.com/3M3RY/tulpenmanie.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/PyQt4"
DEPEND="${RDEPEND}"

pkg_preinst() {
	cd "${S}/graphics"
	newicon --size 16 icon-16x16.png ${PN}.png
	newicon --size 22 icon-22x22.png ${PN}.png
	newicon --size 32 icon-32x32.png ${PN}.png
	newicon --size 64 icon-64x64.png ${PN}.png
	newicon --size 128 icon-128x128.png ${PN}.png

	make_desktop_entry ${PN} Tulpenmanie ${PN} "Network;Economy;Finance"
}
