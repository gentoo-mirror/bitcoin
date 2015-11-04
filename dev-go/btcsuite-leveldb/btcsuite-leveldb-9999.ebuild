# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/goleveldb/leveldb"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	die
fi
inherit golang-build

DESCRIPTION="LevelDB key/value database in Go."
HOMEPAGE="https://github.com/btcsuite/goleveldb/blob/master/README.md"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcsuite-snappy"
RDEPEND=""
