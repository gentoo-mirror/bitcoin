# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1

inherit python

DESCRIPTION="Efficient JSON-RPC for Python"
HOMEPAGE="http://yyz.us/bitcoin/"
MyPV="${PV}-g8ce7bce1"
MyP="python-${PN}-${MyPV}"
SRC_URI="http://yyz.us/bitcoin/${MyP}.tar.gz"
MyPy="jsonrpc/authproxy.py"

SLOT="0"
KEYWORDS="~x86 ~amd64"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MyP}"

src_install() {
	myinstall() {
		insinto "$(python_get_sitedir)/jsonrpc"
		doins -r ${MyPy} || die 'doins failed'
	}
	python_execute_function myinstall
}

pkg_postinst() {
	python_mod_optimize ${MyPy}
}

pkg_postrm() {
	python_mod_cleanup ${MyPy}
}
