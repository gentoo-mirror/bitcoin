# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/chaincfg"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Chain configuration parameters for the three standard Bitcoin networks"
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/chaincfg"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcd-wire"
RDEPEND=""

