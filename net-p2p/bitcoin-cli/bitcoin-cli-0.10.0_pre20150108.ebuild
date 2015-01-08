# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="263b65ebf0ce0beae5622a533234c8f897aec4e1"
inherit bitcoincore-v0.10-20150108

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
	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		--enable-util-cli
}
