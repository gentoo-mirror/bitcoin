# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/ElementsProject/libwally-core"

SRC_URI="https://github.com/ElementsProject/${PN}/archive/release_${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT CC0-1.0"
SLOT="0"

# Needs >libsecp256k1-0.1_pre20181017 keyworded first
KEYWORDS=""
IUSE=""

# TODO: python, java, js, elements (needs libsecp256k1-zkp)

DEPEND=">dev-libs/libsecp256k1-0.1_pre20181017[ecdh]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-release_${PV}"

src_prepare() {
	eapply "${FILESDIR}/0.7.4-sys_libsecp256k1.patch"
	sed -i 's/\(#[[:space:]]*include[[:space:]]\+\)"secp256k1\/include\/\(.*\)"/\1<\2>/' src/*.{c,h} || die
	rm -r src/secp256k1
	default
	eautoreconf
}

src_configure() {
	econf --includedir="${EPREFIX}"/usr/include/libwally/ --enable-export-all
}

src_install() {
	default
}
