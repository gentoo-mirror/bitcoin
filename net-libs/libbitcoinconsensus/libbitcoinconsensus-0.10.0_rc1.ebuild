# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="4e0bfa581438a662147fe4459522b308406d7f57"
BITCOINCORE_POLICY_PATCHES="dcmp"
inherit autotools bitcoincore-v0.10-20141224 eutils user versionator

DESCRIPTION="Bitcoin Core consensus library"
LICENSE="MIT ISC GPL-2"
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
