# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a C library for encoding, decoding and manipulating JSON data"

HOMEPAGE="http://www.digip.org/jansson/"

SRC_URI="http://www.digip.org/jansson/releases/${P}.tar.bz2"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${P}"

src_compile() {
	econf

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
