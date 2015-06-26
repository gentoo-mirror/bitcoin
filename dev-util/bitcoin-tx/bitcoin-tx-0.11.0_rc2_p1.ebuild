# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BITCOINCORE_COMMITHASH="88accef336a806ddc4e5f49be63d8435d7c97325"
BITCOINCORE_LJR_PV="0.11.0rc2"
BITCOINCORE_LJR_DATE="20150624"
BITCOINCORE_IUSE=""
BITCOINCORE_NEED_LIBSECP256K1=1
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_configure() {
	bitcoincore_conf \
		--enable-util-tx
}
