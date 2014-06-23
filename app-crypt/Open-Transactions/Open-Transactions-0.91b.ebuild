# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils git-r3 java-pkg-opt-2 autotools-utils python-r1

DESCRIPTION="Financial cryptography library, API, CLI, and prototype server."
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/Open-Transactions/Open-Transactions.git \
			 https://github.com/Open-Transactions/Open-Transactions.git"
EGIT_COMMIT="adec807824040fe7216ece00484e1709e7ea26c8"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE="doc gnome-keyring go java kwallet python"
REQUIRED_USE="gnome-keyring? ( !kwallet ) kwallet? ( !gnome-keyring )"

COMMON_DEP="dev-libs/boost
			dev-libs/msgpack
			dev-libs/openssl:0
			>=dev-libs/protobuf-2.4.1
			<net-libs/zeromq-3.0.0
			gnome-keyring? ( gnome-base/gnome-keyring )
			kwallet? ( kde-base/kwallet )"

RDEPEND="java? ( >=virtual/jre-1.4 )
		 ${COMMON_DEP}"

DEPEND="java? ( >=virtual/jdk-1.4 )
		 >=sys-devel/autoconf-2.65
		${COMMON_DEP}"

AUTOTOOLS_AUTORECONF=0

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	local required_version="4.7"
	einfo "checking current gcc profile"
	if ! version_is_at_least ${required_version} $(gcc-version) ; then
		eerror "${P} requires gcc-${required_version} or greater to build."
		eerror "Have you gcc-config'ed to the latest version?"
		die "current gcc profile is less than ${required_version}"
	fi

	autotools-utils_src_prepare
}

src_configure() {
	use java && local JAVAC="javac"
	local myeconfargs=(
		$(use_with go)
		$(use_with java)
		$(use_with python)
		$(use gnome-keyring && echo "--with-keyring=gnome")
		$(use kwallet && echo "--with-keyring=kwallet")
	)
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
