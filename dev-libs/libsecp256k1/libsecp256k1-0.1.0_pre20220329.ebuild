# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
COMMITHASH="8746600eec5e7fcd35dabd480839a3a4bdfee87b"
SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${PN}-v${PV}.tgz"

LICENSE="MIT"
SLOT="0/20210628"  # subslot is date of last ABI change
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm ecdh +experimental +extrakeys lowmem precompute-ecmult +schnorr +recovery test valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	?? ( lowmem precompute-ecmult )
	schnorr? ( extrakeys )
"
RDEPEND="
	!=dev-util/bitcoin-tx-22*[-recent-libsecp256k1(-)]
	!=net-p2p/bitcoind-22*[-recent-libsecp256k1(-)]
	!=net-p2p/bitcoin-qt-22*[-recent-libsecp256k1(-)]
	!=net-libs/libbitcoinconsensus-22*[-recent-libsecp256k1(-)]
	!net-p2p/core-lightning[-recent-libsecp256k1(-)]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	valgrind? ( dev-util/valgrind )
"

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

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
		--with-asm=$asm_opt \
		$(use_enable {,module-}ecdh) \
		$(use_enable {,module-}extrakeys) \
		$(use_enable {,module-}recovery) \
		$(use_enable schnorr module-schnorrsig) \
		$(usex lowmem '--with-ecmult-window=2 --with-ecmult-gen-precision=2' '') \
		$(usex precompute-ecmult '--with-ecmult-window=24 --with-ecmult-gen-precision=8' '') \
		$(use_with valgrind) \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
