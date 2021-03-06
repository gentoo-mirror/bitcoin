# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/niftynei/libwally-core"

MyPN="libwally-core"
COMMIT_HASH="1f45aef1e990e945710691e0e3637312f9a84e73"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT CC0-1.0"
SLOT="0"

KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="elements"

# TODO: python, java, js

DEPEND="
	|| ( >=dev-libs/libsecp256k1-0.1_pre20181018[ecdh] >=dev-libs/libsecp256k1-zkp-0.1_pre20190625[ecdh] )
	elements? ( dev-libs/libsecp256k1-zkp[generator,rangeproof,surjectionproof,whitelist] )
"
RDEPEND="${DEPEND}
	!net-libs/libwally-core
"

S="${WORKDIR}/${MyPN}-${COMMIT_HASH}"

src_prepare() {
	eapply "${FILESDIR}/0.7.5-sys_libsecp256k1.patch"
	sed -i 's|\(#[[:space:]]*include[[:space:]]\+\)"\(src/\)\?secp256k1/include/\(.*\)"|\1<\3>|' src/*.{c,h} || die
	rm -r src/secp256k1
	default
	eautoreconf
}

src_configure() {
	# configure.ac uses 'test .. == ..' bashism
	CONFIG_SHELL=/bin/bash \
	econf --includedir="${EPREFIX}"/usr/include/libwally/ \
		--enable-export-all \
		$(use_enable elements)
}
