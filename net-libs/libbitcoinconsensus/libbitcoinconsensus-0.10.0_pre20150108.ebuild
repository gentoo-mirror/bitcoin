# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="263b65ebf0ce0beae5622a533234c8f897aec4e1"
inherit bitcoincore-v0.10-20150108 eutils

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
