# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils multilib

MY_PN="ChaiScript"

DESCRIPTION="ECMAScript-inspired, embedded functional-like scripting language."
HOMEPAGE="http://${PN}.com"
SRC_URI="mirror://github/${MY_PN}/${MY_PN}/${P}-Source.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples test"

DEPEND="dev-libs/boost
		sys-libs/readline"
RDEPEND="sys-libs/readline"

S="${WORKDIR}/${P}-Source"

src_prepare() {
	sed -i -e "s:DESTINATION lib: DESTINATION $(get_libdir):" CMakeLists.txt || die
	epatch "${FILESDIR}/samples+unittests.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build test TESTING)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc readme.md
	dodoc releasenotes.txt
	if use examples ; then
		docinto "samples"
		dodoc samples/*
	fi
}
