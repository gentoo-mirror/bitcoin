# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="e43f25c5b1c7b38d28cd0fba09098a9d56d9ac6b"
BITCOINCORE_LJR_DATE="20150205"
inherit bitcoincore

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
