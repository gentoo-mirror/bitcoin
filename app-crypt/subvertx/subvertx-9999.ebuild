# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/libbitcoin/subvertx.git"
inherit git-2 autotools

DESCRIPTION="Proof of concept command line utilities using libbitcoin."
HOMEPAGE="http://libbitcoin.org/"
SRC_URI=""

LICENSE="AGPL"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="net-p2p/libbitcoin"
DEPEND=">=sys-devel/gcc-4.6 ${RDEPEND}"

src_prepare() {
	eautoreconf || die "Prepare failed"
}

src_configure() {
	econf || die "Configure failed"
}

src_compile() {
	emake || die "Compile failed"
}

src_install() {
	if use doc; then
		dodoc  AUTHORS COPYING ChangeLog INSTALL NEWS README || die
	fi

	emake DESTDIR="${D}" install || die "Install failed"
}

