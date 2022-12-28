# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"
HOMEPAGE="https://github.com/bitcoin-core/secp256k1"
SRC_URI="
	${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tgz
	${HOMEPAGE}/commit/772e747bd9104d80fe531bed61f23f75342d7d63.patch -> ${PN}-PR1159-772e74.patch
	${HOMEPAGE}/commit/54e290ddaf3499002d9ce06bc4adbae05ac32e9e.patch -> ${PN}-PR1160-54e290.patch
"

LICENSE="MIT"
SLOT="0/1"  # subslot is "$((_LIB_VERSION_CURRENT-_LIB_VERSION_AGE))" from configure.ac
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm +ecdh +experimental +extrakeys lowmem +recovery +schnorr static-libs test valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	schnorr? ( extrakeys )
"
RDEPEND="
	!=dev-util/bitcoin-tx-0.21* !=dev-util/bitcoin-tx-21.2
	!=dev-util/bitcoin-tx-22.0 !=dev-util/bitcoin-tx-22.0-r1[-recent-libsecp256k1(+)]
	!=dev-util/bitcoin-tx-22.0-r2[-recent-libsecp256k1(+)]
	!=net-p2p/bitcoind-0.21* !=net-p2p/bitcoind-21.2
	!=net-p2p/bitcoind-22.0 !=net-p2p/bitcoind-22.0-r1[-recent-libsecp256k1(+)]
	!=net-p2p/bitcoin-qt-0.21* !=net-p2p/bitcoin-qt-21.2
	!=net-p2p/bitcoin-qt-22.0 !=net-p2p/bitcoin-qt-22.0-r1[-recent-libsecp256k1(+)]
	!=net-libs/libbitcoinconsensus-0.21* !=net-libs/libbitcoinconsensus-21.2
	!=net-libs/libbitcoinconsensus-22.0
"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

PATCHES=(
	"${DISTDIR}/${PN}-PR1159-772e74.patch"
	"${DISTDIR}/${PN}-PR1160-54e290.patch"
)

S="${WORKDIR}/${MyPN}-${PV}"

src_unpack() {
	unpack "${P}.tgz"
}

src_prepare() {
	default
	eautoreconf

	# Generate during build
	rm -f src/precomputed_ecmult.c src/precomputed_ecmult_gen.c || die
}

multilib_src_configure() {
	local myconf=(
		$(use_enable static{-libs,})
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable {,module-}ecdh)
		$(use_enable {,module-}extrakeys)
		$(use_enable {,module-}recovery)
		$(use_enable schnorr module-schnorrsig)
		$(usex lowmem '--with-ecmult-window=4 --with-ecmult-gen-precision=2' '')
		$(use_with valgrind)
	)
	if use asm; then
		if use arm; then
			myconf+=( --with-asm=arm )
		else
			myconf+=( --with-asm=auto )
		fi
	else
		myconf+=( --with-asm=no )
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete || die
}
