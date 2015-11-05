# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/golangcrypto/poly1305"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Vendored version of Go crypto library poly1305 function"
HOMEPAGE="https://github.com/btcsuite/golangcrypto/tree/master/poly1305"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""

