# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_MASTER="install"
EGIT_BRANCH="install"

inherit git

DESCRIPTION="PySide Bitcoin user interface"
HOMEPAGE="https://gitorious.org/bitcoin/spesmilo"
EGIT_REPO_URI="git://gitorious.org/bitcoin/spesmilo.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
#IUSE="custom-bitcoind"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyside"

src_compile() {
	      emake all || die
}

src_install() {
	      emake DESTDIR="${D}" install || die
}
