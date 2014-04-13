# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools

COMMIT="v0.4"

DESCRIPTION="Wallet related functionality forked from libbitcoin"
HOMEPAGE=""
SRC_URI="https://github.com/spesmilo/libwallet/archive/${COMMIT}.tar.gz"
RESTRICT="mirror"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=net-p2p/libbitcoin-2.0
	dev-libs/boost
"

DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
