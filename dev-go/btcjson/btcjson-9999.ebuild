# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd/btcjson"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Concrete types for marshalling to and from the bitcoin JSON-RPC API"
HOMEPAGE="https://github.com/btcsuite/btcd/tree/master/btcjson"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""

