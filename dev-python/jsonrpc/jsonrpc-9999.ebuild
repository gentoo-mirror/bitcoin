# Copyright 2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

EAPI=3
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="JSON-RPC for Python"
HOMEPAGE="http://json-rpc.org/wiki/python-json-rpc"
LICENSE="LGPL-2.1"

ESVN_REPO_URI="http://svn.json-rpc.org/trunk/python-jsonrpc"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""
