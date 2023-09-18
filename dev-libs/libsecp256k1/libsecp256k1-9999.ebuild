# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/bitcoin-core/secp256k1.git"
inherit git-r3 autotools

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
SRC_URI="
	${HOMEPAGE}/commit/772e747bd9104d80fe531bed61f23f75342d7d63.patch?full_index=1 -> ${PN}-PR1159-772e74.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+asm +ecdh +ellswift experimental +extrakeys lowmem +recovery +schnorr test valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	schnorr? ( extrakeys )
"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
	valgrind? ( dev-util/valgrind )
"

PATCHES=(
	"${DISTDIR}/${PN}-PR1159-772e74.patch"
)

src_prepare() {
	default
	eautoreconf

	# Generate during build
	rm -f src/precomputed_ecmult.c src/precomputed_ecmult_gen.c || die
}

src_configure() {
	local myeconfargs=(
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable {,module-}ecdh)
		$(use_enable {,module-}ellswift)
		$(use_enable {,module-}extrakeys)
		$(use_enable {,module-}recovery)
		$(use_enable schnorr module-schnorrsig)
		$(usev lowmem '--with-ecmult-window=4 --with-ecmult-gen-precision=2')
		$(use_with valgrind)
	)
	if use asm; then
		if use arm; then
			myeconfargs+=( --with-asm=arm32 )
		else
			myeconfargs+=( --with-asm=auto )
		fi
	else
		myeconfargs+=( --with-asm=no )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
