# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_5,3_6,3_7,3_8} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MyPN=${PN}-clientserver

DESCRIPTION="JoinMarket CoinJoin client and daemon"
HOMEPAGE="https://github.com/JoinMarket-Org/joinmarket-clientserver"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client daemon"

RDEPEND="
	>=dev-python/chromalog-1.0.5[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	>=dev-python/twisted-19.7.0[${PYTHON_USEDEP}]

	client? (
		dev-python/argon2_cffi[${PYTHON_USEDEP}]
		dev-python/bencoder-pyx[${PYTHON_USEDEP}]
		dev-python/coincurve[${PYTHON_USEDEP}]
		dev-python/mnemonic[${PYTHON_USEDEP}]
		dev-python/pyaes[${PYTHON_USEDEP}]
	)

	daemon? (
		dev-python/libnacl[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/txtorcon[${PYTHON_USEDEP}]
	)
"
DEPEND="
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MyPN}-${PV}"

do_python_phase() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd "${subdir}" >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
}

src_prepare() {
	PYTHON_SUBDIRS=( jmbase )
	use client && PYTHON_SUBDIRS+=( jmbitcoin jmclient )
	use daemon && PYTHON_SUBDIRS+=( jmdaemon )

	sed -e '1i#!/usr/bin/python3' -i scripts/*.py

	do_python_phase distutils-r1_src_prepare
}

src_configure() {
	do_python_phase distutils-r1_src_configure
}

src_compile() {
	do_python_phase distutils-r1_src_compile
}

src_install() {
	do_python_phase distutils-r1_src_install

	python_doscript scripts/*.py
}
