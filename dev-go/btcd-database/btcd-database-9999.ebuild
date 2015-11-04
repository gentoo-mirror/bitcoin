# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/database"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Provides a database interface for the bitcoin block chain and transactions."
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/database"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcd-wire
	dev-go/btclog
	dev-go/btcutil
	dev-go/btcsuite-ripemd160"
RDEPEND=""

