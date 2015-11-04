# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/txscript"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Implementation of the bitcoin transaction script language"
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/txscript"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcec
	dev-go/btcd-chaincfg
	dev-go/btcd-wire
	dev-go/btclog
	dev-go/btcutil
	dev-go/fastsha256
	dev-go/btcsuite-ripemd160"
RDEPEND=""

