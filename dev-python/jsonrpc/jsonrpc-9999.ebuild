# Copyright 2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="JSON-RPC for Python"
HOMEPAGE="http://json-rpc.org/wiki/python-json-rpc"
LICENSE="LGPL-2.1"
PYTHON_MODNAME="jsonrpc"

ESVN_REPO_URI="http://svn.json-rpc.org/trunk/python-jsonrpc"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"
