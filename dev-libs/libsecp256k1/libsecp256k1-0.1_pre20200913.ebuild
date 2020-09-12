# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
COMMITHASH="c9939ba55d552d1b2cb5be5655bc0f3198b788d1"
SRC_URI="${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${PN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+asm ecdh endomorphism experimental extrakeys gmp lowmem precompute-ecmult schnorr +recovery test test-openssl valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	ecdh? ( experimental )
	schnorr? ( extrakeys )
	test-openssl? ( test )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test-openssl? ( dev-libs/openssl:0 )
"

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

src_prepare() {
	eapply "${FILESDIR}/20200913-valgrind-opt.patch"
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
		$(use_enable endomorphism)  \
		--with-asm=$asm_opt \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		$(use_enable schnorr module-schnorrsig) \
		$(usex lowmem '--with-ecmult-window=2 --with-ecmult-gen-precision=2' '') \
		$(usex precompute-ecmult '--with-ecmult-window=24 --with-ecmult-gen-precision=8' '') \
		$(use_with valgrind) \
		--disable-static
}

src_install() {
	dodoc README.md
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
}
