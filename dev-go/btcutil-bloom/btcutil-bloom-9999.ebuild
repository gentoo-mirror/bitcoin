# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/btcsuite/btcutil/bloom"

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        die
fi
inherit golang-build

DESCRIPTION="Provides provides an API for dealing with bitcoin-specific bloom filters."
HOMEPAGE="https://github.com/btcsuite/btcutil/bloom"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="dev-go/btcutil
	dev-go/btcd-blockchain
	dev-go/btcd-txscript
	dev-go/btcd-wire"
RDEPEND=""

src_prepare() {
	# btcd-database (dependency) won't compile without these files present in ${S}
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
	mkdir "${T}/horrible_hack"

	# Clean up non-bloom pkg files
	mv "${S}/pkg/linux_${ARCH}/github.com/btcsuite/btcutil/bloom" "${T}/horrible_hack"
	rm -r "${S}/pkg/linux_${ARCH}/github.com/btcsuite/btcutil"
	mkdir "${S}/pkg/linux_${ARCH}/github.com/btcsuite/btcutil"
	mv "${T}/horrible_hack/bloom" "${S}/pkg/linux_${ARCH}/github.com/btcsuite/btcutil"

	# Clean up non-bloom src files
	mv "${S}/src/github.com/btcsuite/btcutil/bloom" "${T}/horrible_hack"
	rm -r "${S}/src/github.com/btcsuite/btcutil"
	mkdir "${S}/src/github.com/btcsuite/btcutil"
	mv "${T}/horrible_hack/bloom" "${S}/src/github.com/btcsuite/btcutil"

        golang_install_pkgs

	rm "${D}/usr/lib/go-gentoo/pkg/linux_${ARCH}/github.com/btcsuite/btcutil.a"
}
