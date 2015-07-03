# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="afc60de4164dc723f9010da7f3867f8354f81530"
BITCOINCORE_LJR_PV="0.11.0rc3"
BITCOINCORE_LJR_DATE="20150703"
BITCOINCORE_IUSE="+ljr"
inherit bash-completion-r1 bitcoincore

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind \)bitcoind \(bitcoin-cli\)$/\1\2/' contrib/bitcoind.bash-completion
	bitcoincore_src_prepare
}

src_configure() {
	bitcoincore_conf \
		--enable-util-cli
}

src_install() {
	bitcoincore_src_install

	doman contrib/debian/manpages/bitcoin-cli.1

	newbashcomp contrib/bitcoind.bash-completion ${PN}
}
