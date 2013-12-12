# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils git-r3 java-pkg-opt-2 autotools-utils python-r1

DESCRIPTION="Financial cryptography library, API, CLI, and prototype server."
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/FellowTraveler/Open-Transactions.git \
			   https://github.com/FellowTraveler/Open-Transactions.git"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS=""
IUSE="doc gnome-keyring go java kwallet python"
REQUIRED_USE="gnome-keyring? ( !kwallet ) kwallet? ( !gnome-keyring )"

COMMON_DEP="dev-libs/boost
			>dev-libs/chaiscript-5
			dev-libs/msgpack
			dev-libs/openssl:0
			>=dev-libs/protobuf-2.4.1
			<net-libs/zeromq-3.0.0
			gnome-keyring? ( gnome-base/gnome-keyring )
			kwallet? ( kde-base/kwallet )"

RDEPEND="java? ( >=virtual/jre-1.4 )
		 ${COMMON_DEP}"

DEPEND="java? ( >=virtual/jdk-1.4 )
		${COMMON_DEP}"

AUTOTOOLS_AUTORECONF=0

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	autotools-utils_src_prepare
}

src_configure() {
	use java && local JAVAC="javac"
	local myeconfargs=(
		$(use_with go)
		$(use_with java)
		$(use_with python))
	use gnome-keyring && myeconfargs=(${myeconfargs[@]} '--with-keyring=gnome')
	use kwallet && myeconfargs=(${myeconfargs[@]} '--with-keyring=kwallet')
	myeconfargs=(${myeconfargs[@]} '--enable-cxx11')
	myeconfargs=(${myeconfargs[@]} '--disable-boost')
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	if use python ; then
		python_export_best
		python_domodule swig/glue/python/otapi.py
		dosym ../../_otapi.so "$(python_get_sitedir)/_otapi.so"
	fi
	dodoc README.md
	cd docs
	for docfile in ./*.txt ; do
		if [ ${docfile/#"INSTALL"/""} == ${docfile} ] ; then
			dodoc ${docfile}
		fi
	done
}
