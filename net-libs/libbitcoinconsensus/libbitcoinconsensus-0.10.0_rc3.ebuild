# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="249bf0e0492758d71dc5d8fa77103b31b604979f"
inherit bitcoincore-v0.10-20150112 eutils

DESCRIPTION="Bitcoin Core consensus library"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

src_configure() {
	bitcoincore_conf \
		--with-libs
}

src_install() {
	bitcoincore_install
	prune_libtool_files
}
