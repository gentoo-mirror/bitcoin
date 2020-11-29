# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/ElementsProject/libwally-core"

COMMIT_HASH="bf81e8b17069020dec0638e352298770aa382952"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT CC0-1.0"
SLOT="0"

#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
IUSE="elements"

# TODO: python, java, js

DEPEND="
	|| ( >=dev-libs/libsecp256k1-0.1_pre20181018[ecdh] >=dev-libs/libsecp256k1-zkp-0.1_pre20190625[ecdh] )
	elements? ( dev-libs/libsecp256k1-zkp[generator,rangeproof,surjectionproof,whitelist] )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

PATCHES=(
	"${FILESDIR}/0.8.1-sys_libsecp256k1.patch"
)

src_prepare() {
	sed -i 's|\(#[[:space:]]*include[[:space:]]\+\)"\(src/\)\?secp256k1/include/\(.*\)"|\1<\3>|' src/*.{c,h} || die
	rm -r src/secp256k1
	default
	sed -e 's/==/=/g' -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf --includedir="${EPREFIX}"/usr/include/libwally/ \
		--enable-export-all \
		$(use_enable elements)
}