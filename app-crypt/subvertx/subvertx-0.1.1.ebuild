# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="Proof of concept command line utilities using libbitcoin."
HOMEPAGE="http://libbitcoin.org/"
SRC_URI="https://gitorious.org/libbitcoin/subvertx/archive-tarball/v${PV/_/} -> subvertx-v${PV}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="=net-p2p/libbitcoin-0.1.0_alpha2[postgres,berkdb]"
DEPEND=">=sys-devel/gcc-4.6 ${RDEPEND}"

S="${WORKDIR}/libbitcoin-subvertx"

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
		dodoc AUTHORS ChangeLog INSTALL NEWS README || die
	fi

	emake DESTDIR="${D}" install || die "Install failed"
}
