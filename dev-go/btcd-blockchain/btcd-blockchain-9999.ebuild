# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/blockchain"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="A library implenenting bitcoin block handling and chain selection rules"
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/blockchain"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcd-chaincfg
	dev-go/btcd-database
	dev-go/btcd-txscript
	dev-go/btcd-wire
	dev-go/btclog
	dev-go/btcutil"
RDEPEND=""

