# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/bolt"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="A low-level key/value database for Go. "
HOMEPAGE="https://github.com/btcsuite/bolt"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""

