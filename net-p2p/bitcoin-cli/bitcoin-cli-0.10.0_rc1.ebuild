# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="4e0bfa581438a662147fe4459522b308406d7f57"
BITCOINCORE_NO_SYSLIBS=1
inherit bitcoincore-v0.10-20141224

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/bitcoin-leveldb
"

src_prepare() {
	bitcoincore_prepare
	sed -i 's/bitcoin-tx//' src/Makefile.am
	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		--with-utils
}
