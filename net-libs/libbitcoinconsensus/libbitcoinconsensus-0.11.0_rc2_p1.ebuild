# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="88accef336a806ddc4e5f49be63d8435d7c97325"
BITCOINCORE_LJR_PV="0.11.0rc2"
BITCOINCORE_LJR_DATE="20150624"
BITCOINCORE_IUSE="ljr test"
inherit bitcoincore eutils

DESCRIPTION="Bitcoin Core consensus library"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_configure() {
	bitcoincore_conf \
		--with-libs
}

src_install() {
	bitcoincore_src_install
	dodoc doc/bips.md
	prune_libtool_files
}
