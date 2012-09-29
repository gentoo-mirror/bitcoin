# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools-utils git-2

DESCRIPTION="Issue and manipulate digital assets using signed contracts and recipts."
HOMEPAGE="https://github.com/FellowTraveler/Open-Transactions"
EGIT_REPO_URI="git://github.com/FellowTraveler/Open-Transactions.git \
			   https://github.com/FellowTraveler/Open-Transactions.git"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS=""
#IUSE="java perl php python ruby"
IUSE=""
DEPEND="dev-libs/boost
		>=dev-libs/chaiscript-6.0.0
		dev-libs/msgpack
		dev-libs/openssl:0
		dev-libs/protobuf
		net-libs/zeromq"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_BUILD_DIR="${S}/build"

src_configure() {
	#local myeconfargs=(
	#	$(use_with java)
	#	$(use_with php)
	#	$(use_with python)
	#	$(use_with ruby)
	#	$(use_with perl perl5)
	#)
	autotools-utils_src_configure
}

src_compile() {
	einfo "ccache has exhibited linker issues with ${PN},"
	einfo "thus it will be temporarily disabled"
	local CCACHE_DISABLE=""
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install
}
