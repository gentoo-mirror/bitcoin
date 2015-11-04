# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/wire"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Implementation of the bitcoin wire protocol"
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/wire"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/fastsha256"
RDEPEND=""

