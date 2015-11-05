# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcwallet"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="A secure bitcoin wallet daemon written in Go"
HOMEPAGE="https://github.com/btcsuite/btcwallet"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcsuite-bolt
	dev-go/btcd-blockchain
	dev-go/btcec
	dev-go/btcjson
	dev-go/btcd-chaincfg
	dev-go/btcd-txscript
	dev-go/btcd-wire
	dev-go/btclog
	dev-go/btcrpcclient
	dev-go/btcutil
	dev-go/btcutil-hdkeychain
	dev-go/fastsha256
	dev-go/btcsuite-flags
	dev-go/btcsuite-secretbox
	dev-go/btcsuite-ripemd160
	dev-go/btcsuite-scrypt
	dev-go/btcsuite-terminal
	dev-go/btcsuite-seelog
	dev-go/btcsuite-websocket"
RDEPEND=""

src_install() {
	exeinto /usr/bin
	doexe "${S}/btcwallet"
	dodoc -r "${S}/src/${EGO_PN}/docs/"
}
