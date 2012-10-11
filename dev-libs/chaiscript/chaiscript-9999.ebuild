# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils git-2 versionator

DESCRIPTION="ECMAScript-inspired, embedded functional-like scripting language."
HOMEPAGE="http://${PN}.com"
EGIT_REPO_URI="git://github.com/ChaiScript/ChaiScript.git \
			   https://github.com/ChaiScript/ChaiScript.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="examples test"

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-Source"

src_prepare() {
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
	dodoc releasenotes.txt
	if use examples ; then
		docinto "samples"
		dodoc samples/*
	fi
}
