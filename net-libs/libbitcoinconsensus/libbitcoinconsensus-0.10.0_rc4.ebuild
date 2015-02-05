# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="e43f25c5b1c7b38d28cd0fba09098a9d56d9ac6b"
inherit bitcoincore eutils

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
