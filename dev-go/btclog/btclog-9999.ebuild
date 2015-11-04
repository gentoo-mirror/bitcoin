# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btclog"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="A subsystem aware logger backed by seelog"
HOMEPAGE="https://github.com/btcsuite/btclog"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcsuite-seelog"
RDEPEND=""

