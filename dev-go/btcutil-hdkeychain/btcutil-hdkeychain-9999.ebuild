# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcutil/hdkeychain"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="An API for bitcoin hierarchical deterministic extended keys (BIP0032)"
HOMEPAGE="https://github.com/btcsuite/btcutil/tree/master/hdkeychain"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="
    dev-go/btcutil
    dev-go/btcec
	dev-go/btcd-chaincfg
	dev-go/btcd-wire
	dev-go/btcutil-base58"
RDEPEND=""

src_prepare() {
        # extendedkey (dependency) won't compile without these files present in ${S}
        cp -a /usr/lib/go-gentoo/src/github.com/btcsuite/btcutil ${S}/src/github.com/btcsuite
}

golang-build_src_install() {
        debug-print-function ${FUNCNAME} "$@"

        ego_pn_check
        set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
                go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
        echo "$@"
        "$@" || die

        # Clean up files to avoid file collision problems
        mkdir "${T}/horrible_hack" || die

        # Clean up non-hdkeychain src files
        mv "${S}/src/github.com/btcsuite/btcutil/hdkeychain" "${T}/horrible_hack" || die
        rm -r "${S}/src/github.com/btcsuite/btcutil" || die
        mkdir "${S}/src/github.com/btcsuite/btcutil" || die
        mv "${T}/horrible_hack/hdkeychain" "${S}/src/github.com/btcsuite/btcutil" || die

        golang_install_pkgs

        # Clean up non-hdkeychain pkg files
	mv "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/github.com/btcsuite/btcutil/hdkeychain.a" "${T}/horrible_hack" || die
        rm -r "${D}"/usr/lib/go-gentoo/pkg/linux_"${ARCH}"/github.com/btcsuite/btcutil/*.a || die
        rm "${D}"/usr/lib/go-gentoo/pkg/linux_"${ARCH}"/github.com/btcsuite/btcutil.a || die
	mv "${T}/horrible_hack/hdkeychain.a" "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/github.com/btcsuite/btcutil" || die
}

