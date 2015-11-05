# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcrpcclient"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="A robust and easy to use websocket-enabled Bitcoin JSON-RPC client."
HOMEPAGE="https://github.com/btcsuite/btcrpcclient"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcjson
	dev-go/btcd-chaincfg
	dev-go/btcd-wire
	dev-go/btclog
	dev-go/btcutil
	dev-go/btcsuite-socks
	dev-go/btcsuite-websocket"
RDEPEND=""

