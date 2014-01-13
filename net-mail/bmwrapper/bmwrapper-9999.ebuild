# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7} )

inherit eutils python-any-r1 git-2

DESCRIPTION="bmwrapper is a poorly hacked together python script to let Thunderbird and PyBitmessage communicate."
HOMEPAGE="https://github.com/Arceliar/bmwrapper"
EGIT_REPO_URI="git://github.com/Arceliar/bmwrapper"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMON_DEPEND="${PYTHON_DEPS}"

DEPEND="${COMMON_DEPEND}
		net-im/bitmessage"

RDEPEND="${COMMON_DEPEND}
		net-im/bitmessage"

src_install() {
	python_moduleinto ${PN}
	python_domodule main.py bminterface.py incoming.py outgoing.py

	echo "#!/bin/sh" > "${T}/bmwrapper"
	echo "exec python2 $(python_get_sitedir)/bmwrapper/main.py" >> "${T}/bmwrapper"
	dobin "${T}/bmwrapper"
	doinitd ${FILESDIR}/bmwrapper
	doconfd ${FILESDIR}/bmwrapper.conf
}
