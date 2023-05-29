# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"
COMMITHASH="cdb64b688dda93bbbacbc2b1ccf50ce9329d4748"
SRC_URI="${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz
	${HOMEPAGE}/commit/6674aadb6f2be925e89b253f1b380ecdbc69777b.patch?full_index=1 -> ${PN}-libtool-no-wrap-tests.patch"
S="${WORKDIR}/${PN}-${COMMITHASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${DISTDIR}/${PN}-libtool-no-wrap-tests.patch"
)

BDEPEND="
	test? (
		app-arch/xz-utils
		sys-libs/zlib
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-shared \
		$(use_enable static{-libs,})
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
