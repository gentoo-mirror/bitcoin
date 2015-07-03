# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="afc60de4164dc723f9010da7f3867f8354f81530"
BITCOINCORE_LJR_PV="0.11.0rc3"
BITCOINCORE_LJR_DATE="20150703"
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
