# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/bitcoin-core/secp256k1.git"
inherit git-r3 autotools

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+asm ecdh +experimental +extrakeys gmp lowmem +schnorr +recovery test test-openssl valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	extrakeys? ( experimental )
	schnorr? ( experimental extrakeys )
	test-openssl? ( test )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test-openssl? ( dev-libs/openssl:0 )
	valgrind? ( dev-util/valgrind )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local asm_opt
	if use asm; then
		if use arm; then
			asm_opt=arm
		else
			asm_opt=auto
		fi
	else
		asm_opt=no
	fi
	econf \
		--disable-benchmark \
		$(use_enable experimental) \
		$(use_enable test tests) \
		$(use_enable test exhaustive-tests) \
		$(use_enable test-openssl openssl-tests) \
		$(use_enable ecdh module-ecdh) \
		$(use_enable extrakeys module-extrakeys) \
		--with-asm=$asm_opt \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		$(use_enable schnorr module-schnorrsig) \
		$(usex lowmem '--with-ecmult-window=2 --with-ecmult-gen-precision=2' '') \
		$(use_with valgrind) \
		--disable-static
}

src_install() {
	dodoc README.md
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
}
