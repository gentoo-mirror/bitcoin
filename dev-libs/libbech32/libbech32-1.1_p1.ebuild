# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for Bech32/Bech32m/Blech32/Blech32m encoding/decoding"
HOMEPAGE="https://github.com/whitslack/libbech32"
SRC_URI="${HOMEPAGE}/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV/_}"

LICENSE="WTFPL-2"
SLOT="0/0"  # subslot is from soname
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+blech32 cxx doc +man test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( cxx )"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	man? ( app-text/doxygen )
"

src_prepare() {
	default
	has_version -b '=dev-build/autoconf-archive-2024.10.16' && eapply "${FILESDIR}/avoid-ax_cxx_compile_stdcxx-bug.patch"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable blech32)
		$(use_enable cxx c++)
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
