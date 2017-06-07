# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="https://github.com/bitcoin/secp256k1.git"
inherit git-2 autotools eutils

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin/${MyPN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+asm ecdh endomorphism experimental gmp java +recovery test test_openssl"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	ecdh? ( experimental )
	java? ( ecdh )
	test_openssl? ( test )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( virtual/jdk )
	test_openssl? ( dev-libs/openssl:0 )
"

src_prepare() {
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
		$(use_enable java jni) \
		$(use_enable test tests) \
		$(use_enable test_openssl openssl-tests) \
		$(use_enable ecdh module-ecdh) \
		$(use_enable endomorphism)  \
		--with-asm=$asm_opt \
		--with-bignum=$(usex gmp gmp no) \
		$(use_enable recovery module-recovery) \
		--disable-static
}

src_install() {
	dodoc README.md
	emake DESTDIR="${D}" install
	prune_libtool_files
}
