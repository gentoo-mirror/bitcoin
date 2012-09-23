# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

MY_PN="ChaiScript"

DESCRIPTION="ECMAScript-inspired, embedded functional-like scripting language."
HOMEPAGE="http://${PN}.com"
SRC_URI="https://github.com/downloads/${MY_PN}/${MY_PN}/${P}-Source.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples test"

DEPEND=">=sys-devel/gcc-4.6
		sys-libs/readline"
RDEPEND="sys-libs/readline"

S="${WORKDIR}/${P}-Source"

src_prepare() {
	einfo "checking current gcc profile"
	if [[ $(gcc-major-version)$(gcc-minor-version) -lt 46 ]] ; then
		eerror "${P} requires gcc-4.6 or greater"
		eerror "have you gcc-config'ed to the latest version?"
		die "current gcc profile is less than 4.6"
	fi
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
	dodoc readme.txt
	dodoc releasenotes.txt
	if use examples ; then
		docinto "samples"
		dodoc samples/*
	fi
}
