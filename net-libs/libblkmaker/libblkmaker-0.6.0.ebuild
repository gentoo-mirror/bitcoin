# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="C implementation of Bitcoin's getblocktemplate interface"
HOMEPAGE="https://github.com/bitcoin/libblkmaker"
LICENSE="MIT"

SRC_URI="https://github.com/bitcoin/libblkmaker/archive/v${PV}.tar.gz -> ${P}-github.tgz"
SLOT="0/7"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/jansson-2.0.0
	dev-libs/libbase58
"
DEPEND="${RDEPEND}
	test? ( dev-libs/libgcrypt )
"

ECONF_SOURCE="${S}"

src_prepare() {
	default
	eautoreconf
}
