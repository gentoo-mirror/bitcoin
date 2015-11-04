# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN=github.com/btcsuite/seelog/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	die
fi
inherit golang-build

DESCRIPTION="Seelog provides logging functionality with flexible dispatching, filtering, and formatting."
HOMEPAGE="https://github.com/btcsuite/seelog/blob/master/README.md"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=""
RDEPEND=""

