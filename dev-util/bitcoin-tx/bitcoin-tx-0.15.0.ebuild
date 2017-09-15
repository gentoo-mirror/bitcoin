# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BITCOINCORE_COMMITHASH="3751912e8e044958d5ccea847a3f8eab0b026dc1"
BITCOINCORE_LJR_DATE="20170914"
BITCOINCORE_IUSE="+knots"
BITCOINCORE_NEED_LIBSECP256K1=1
BITCOINCORE_NO_DEPEND="libevent"
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

src_configure() {
	bitcoincore_conf \
		--enable-util-tx
}
