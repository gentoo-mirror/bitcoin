# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN=github.com/btcsuite/snappy-go/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	die
fi
inherit golang-build

DESCRIPTION="Implementation of the Snappy compression format written in go"
HOMEPAGE="https://github.com/btcsuite/snappy-go/blob/master/README.md"
LICENSE="BSD"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""
