# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/bitcoin/secp256k1.git"
inherit git-2 autotools eutils

DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin/secp256k1"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="asm doc endomorphism gmp test"

REQUIRED_USE="
	asm? ( amd64 )
"
RDEPEND="
	gmp? ( dev-libs/gmp )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gcc-4.7
	test? ( dev-libs/openssl )
"

src_prepare() {
	eautoreconf
}

src_configure() {
	local field
	if use gmp && ! use asm; then
		field=gmp
	elif use amd64; then
		field=64bit
	else
		field=32bit
	fi

	econf \
		--disable-benchmark \
		$(use_enable test tests) \
		$(use_enable endomorphism)  \
		--with-asm=$(usex asm auto no) \
		--with-bignum=$(usex gmp gmp no) \
		--with-field=${field} \
		--disable-static
}

src_compile() {
	emake
}

src_test() {
	emake check
}

src_install() {
	if use doc; then
		dodoc README.md
	fi

	emake DESTDIR="${D}" install
	prune_libtool_files
}
