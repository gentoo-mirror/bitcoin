# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MyPN=secp256k1-zkp
DESCRIPTION="A fork of libsecp256k1 with support for advanced and experimental features such as Confidential Assets and MuSig2"
HOMEPAGE="https://github.com/BlockstreamResearch/secp256k1-zkp"
COMMITHASH="6ec1ff6040164cbc3fafb665e28449870e6a9113"
SRC_URI="
	${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${P}.tgz
	https://github.com/bitcoin-core/secp256k1/commit/772e747bd9104d80fe531bed61f23f75342d7d63.patch?full_index=1 -> libsecp256k1-PR1159-772e74.patch
	https://github.com/bitcoin-core/secp256k1/commit/54e290ddaf3499002d9ce06bc4adbae05ac32e9e.patch?full_index=1 -> libsecp256k1-PR1160-54e290.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm bppp +ecdh ecdsa-adaptor ecdsa-s2c experimental external-default-callbacks +extrakeys generator lowmem musig rangeproof +recovery +schnorrsig surjectionproof test valgrind whitelist"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	asm? ( || ( amd64 arm ) arm? ( experimental ) )
	bppp? ( experimental )
	ecdsa-adaptor? ( experimental )
	ecdsa-s2c? ( experimental )
	generator? ( experimental )
	musig? ( experimental schnorrsig )
	rangeproof? ( experimental generator )
	schnorrsig? ( extrakeys )
	surjectionproof? ( experimental rangeproof )
	whitelist? ( experimental rangeproof )
"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

PATCHES=(
	"${DISTDIR}/libsecp256k1-PR1159-772e74.patch"
	"${DISTDIR}/libsecp256k1-PR1160-54e290.patch"
)

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

src_unpack() {
	unpack "${P}.tgz"
}

src_prepare() {
	default
	sed -e 's|^exhaustive_tests_CPPFLAGS = |\0-I$(top_srcdir)/src |' \
		-i Makefile.am || die
	sed -e 's/\(\blibsecp256k1\)\([]._]\)/\1_zkp\2/g' \
		-i configure.ac Makefile.am src/modules/*/Makefile.am.include || die
	sed -e 's|^\(Description:\).*$|\1 '"${DESCRIPTION}"'|' \
		-e 's|^\(URL:\).*$|\1 '"${HOMEPAGE}"'|' \
		-e 's/secp256k1$/\0_zkp/' \
		-i libsecp256k1.pc.in || die
	mv libsecp256k1{,_zkp}.pc.in || die
	eautoreconf

	# Generate during build
	rm -f src/precomputed_ecmult.c src/precomputed_ecmult_gen.c || die
}

multilib_src_configure() {
	local myeconfargs=(
		--includedir="/usr/include/${MyPN//-/_}"
		--disable-benchmark
		$(use_enable experimental)
		$(use_enable external-default-callbacks)
		$(use_enable test tests)
		$(use_enable test exhaustive-tests)
		$(use_enable {,module-}bppp)
		$(use_enable {,module-}ecdh)
		$(use_enable {,module-}ecdsa-adaptor)
		$(use_enable {,module-}ecdsa-s2c)
		$(use_enable {,module-}extrakeys)
		$(use_enable {,module-}generator)
		$(use_enable {,module-}musig)
		$(use_enable {,module-}rangeproof)
		$(use_enable {,module-}recovery)
		$(use_enable {,module-}schnorrsig) \
		$(use_enable {,module-}surjectionproof)
		$(use_enable {,module-}whitelist)
		$(usev lowmem '--with-ecmult-window=4 --with-ecmult-gen-precision=2')
		$(use_with valgrind)
	)
	if use asm; then
		if use arm; then
			myeconfargs+=( --with-asm=arm )
		else
			myeconfargs+=( --with-asm=auto )
		fi
	else
		myeconfargs+=( --with-asm=no )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -name '*.la' -delete || die
}
