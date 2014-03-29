# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils git-2

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="
"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="git://github.com/bitcoin/bitcoin.git https://github.com/bitcoin/bitcoin.git"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipv6"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/openssl:0[-bindist]
"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--without-miniupnpc  \
		$(use_enable ipv6)  \
		--disable-tests  \
		--disable-wallet  \
		--without-daemon  \
		--without-gui
}

src_install() {
	einstall

	dodoc doc/README.md doc/release-notes.md
	dodoc doc/assets-attribution.md doc/tor.md
}
