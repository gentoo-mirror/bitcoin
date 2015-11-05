# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcutil"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Provides bitcoin-specific convenience functions and types "
HOMEPAGE="https://github.com/btcsuite/btcutil"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcec
	dev-go/btcd-chaincfg
	dev-go/btcd-wire
	dev-go/fastsha256
	dev-go/btcsuite-ripemd160"
RDEPEND=""

src_install()
{
        # avoid file collisions with btcutil-bloom
	golang-build_src_install
	rm -r "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/${EGO_PN}/base58.a"
	rm -r "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/${EGO_PN}/bloom.a"
	rm -r "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/${EGO_PN}/hdkeychain.a"
        rm -r "${D}/usr/lib/go-gentoo/src/${EGO_PN}/base58"
        rm -r "${D}/usr/lib/go-gentoo/src/${EGO_PN}/bloom"
        rm -r "${D}/usr/lib/go-gentoo/src/${EGO_PN}/hdkeychain"
}
