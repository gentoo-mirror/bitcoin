# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

PATCH_HASHES=(
	831887cbaff488ceef489b2415b93f681a734373	# libbacktrace: always link test programs statically
)
PATCH_FILES=( "${PATCH_HASHES[@]/%/.patch}" )
PATCHES=(
	"${PATCH_FILES[@]/#/${DISTDIR%/}/}"
)

COMMITHASH="8602fda64e78f1f46563220f2ee9f7e70819c51d"
SRC_URI="${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"
S="${WORKDIR}/${PN}-${COMMITHASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND=""
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
