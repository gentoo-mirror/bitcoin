# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for Base58Check encoding and decoding"
HOMEPAGE="https://github.com/whitslack/libbase58check"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0/0"  # subslot is from soname
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc +man test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/openssl:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	man? ( app-doc/doxygen )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc doxygen-html)
		$(use_enable {,doxygen-}man)
		$(use_enable test{,s})
	)
	use doc || use man || myeconfargs+=( --disable-doxygen-doc )
	econf "${myeconfargs[@]}"
}

src_install() {
	use doc && DOCS+=( doxygen-doc/html )
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
