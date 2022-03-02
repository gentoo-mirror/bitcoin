# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

COMMITHASH="2446c66076480ce07a6bd868badcbceb3eeecc2e"
SRC_URI="${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="static-libs"
RESTRICT="test"

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMITHASH}"

src_configure() {
	econf --enable-shared \
		$(use_enable static{-libs,})
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
