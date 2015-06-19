# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1

inherit git-2 python

DESCRIPTION="Python module for working with arbitrary rational numbers, in any radix"
HOMEPAGE="https://gitorious.org/anynumber"
EGIT_REPO_URI="git://gitorious.org/anynumber/python.git"

SLOT="0"
KEYWORDS="~x86 ~amd64"

src_install() {
	myinstall() {
		insinto $(python_get_sitedir)
		doins anynumber.py || die 'doins failed'
	}
	python_execute_function myinstall
}

pkg_postinst() {
	python_mod_optimize anynumber.py
}

pkg_postrm() {
	python_mod_cleanup anynumber.py
}
