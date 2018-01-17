# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

COMMITHASH=3739537b9c6fbba7a7a48e8ac1341fa83788ee02
SRC_URI="https://github.com/ianlancetaylor/${PN}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMITHASH}"
