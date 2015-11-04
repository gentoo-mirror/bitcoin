# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcd"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	die
fi
inherit golang-build user systemd

DESCRIPTION="An alternative full node btcd implementation written in Go (golang)"
HOMEPAGE="https://github.com/btcsuite/btcd/blob/master/README.md"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btclog
	dev-go/btcutil
	dev-go/btcutil-bloom
	dev-go/fastsha256
	dev-go/btcsuite-flags
	dev-go/btcsuite-socks
	dev-go/btcsuite-ripemd160
	dev-go/btcsuite-leveldb
	dev-go/btcsuite-seelog
	dev-go/btcsuite-websocket
	dev-go/go-spew"
RDEPEND=""

PUSER="btcd"
PUG="${PUSER}:${PUSER}"
PHOME="/var/lib/${PUSER}"
PCONFDIR="/etc/btcd"
PCONFFILE="${PCONFDIR}/btcd.conf"

pkg_setup() {
        enewgroup "${PUSER}"
        enewuser "${PUSER}" -1 -1 "${PHOME}" "${PUSER}"
}

src_install() {
	exeinto /usr/bin
	doexe "${S}/btcd"
	dodoc -r "${S}/src/${EGO_PN}/docs"

	insinto "${PCONFDIR}"
	newins "${FILESDIR}/btcd.conf" btcd.conf
	fowners "${PUG}" "${PCONFFILE}"
	fperms 600 "${PCONFFILE}"

	systemd_dounit "${FILESDIR}/btcd.service"

	keepdir "${PHOME}"/.btcd
	fperms 700 "${PHOME}"
	fowners "${PUG}" "${PHOME}"
	fowners "${PUG}" "${PHOME}"/.btcd
	dosym "${PCONFFILE}" "${PHOME}"/.btcd/btcd.conf

}

