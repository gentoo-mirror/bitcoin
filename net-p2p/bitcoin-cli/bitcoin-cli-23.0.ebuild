# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 flag-o-matic

BITCOINCORE_COMMITHASH="fcf6c8f4eb217763545ede1766831a6b93f583bd"
KNOTS_PV="${PV}.knots20220529"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Command-line JSON-RPC client specifically for interfacing with bitcoind"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/23.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
	!knots? ( https://raw.githubusercontent.com/bitcoin/bitcoin/8779adbdda7658d109556d2e3397e59869a4532a/doc/release-notes/release-notes-23.0.md -> bitcoin-v${PV}-release-notes-Core.md )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+knots"

RDEPEND="
	>=dev-libs/boost-1.77.0:=[threads(+)]
	dev-libs/libevent:=
	>=dev-libs/univalue-1.0.4:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-8.1[cxx] >=sys-devel/clang-7 )
"

DOCS=()

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/23.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2022/04/25/release-${PV}/"
	fi

	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if ! test-flag-CXX -std=c++17 ; then
			die "Building ${CATEGORY}/${P} requires at least GCC 8.1 or Clang 7"
		fi
	fi
}

src_prepare() {
	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${knots_patchdir}/${KNOTS_P}_p1-syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}_p2-fixes.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p3-features.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p4-branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p5-ts.patch"
	fi

	default

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		--disable-asm
		--without-qtdbus
		--disable-usdt
		--without-natpmp
		--without-qrencode
		--without-seccomp
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--enable-util-cli
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--without-gui
		--disable-fuzz
		--disable-fuzz-binary
		--disable-ccache
		--disable-static
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	if use knots; then
		dodoc doc/release-notes.md
	else
		# Bitcoin Core forgot to commit the release notes to git
		newdoc "${DISTDIR}/bitcoin-v${PV}-release-notes-Core.md" "release-notes.md"
	fi

	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}
}
