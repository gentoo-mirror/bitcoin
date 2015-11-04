# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/go-socks/socks"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="SOCKS5 Proxy Package for Go"
HOMEPAGE="https://github.com/btcsuite/go-socks/"
LICENSE="BSD"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""

