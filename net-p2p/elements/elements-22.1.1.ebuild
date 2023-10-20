# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools backports db-use desktop python-any-r1 systemd xdg-utils

BACKPORTS=(
	0f95247246344510c9a51810c14c633abb382e95:resolve-conflicts	# Integrate univalue into our buildsystem
	17ae2601c786e6863cee1bd62297d79521219295	# build: remove build stubs for external leveldb
	cf7292597e18ffca06b0fbf8bcd545aec387e380	# configure.ac: remove Bashism
)

DESCRIPTION="Implementation of advanced blockchain features extending the Bitcoin protocol"
HOMEPAGE="https://elementsproject.org/"
BACKPORTS_BASE_URI="https://github.com/bitcoin/bitcoin/commit/"
SRC_URI="https://github.com/ElementsProject/elements/releases/download/${P}/${P}.tar.gz
	$(backports_patch_uris)
	https://github.com/bitcoin/bitcoin/raw/304319367595b51abfd69f1c4abddeef0acca3a9/src/univalue/sources.mk -> ${P}-univalue-sources.mk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm +berkdb +cli +daemon dbus examples +external-signer gui +man nat-pmp +qrcode +sqlite system-leveldb +system-libsecp256k1 systemtap test upnp zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( gui )
	qrcode? ( gui )
	system-leveldb? ( || ( daemon gui ) )
"
RDEPEND="
	>=dev-libs/boost-1.71.0:=
	>=dev-libs/libevent-2.1.12:=
	berkdb? ( >=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=[cxx] )
	daemon? (
		acct-group/elements
		acct-user/elements
	)
	gui? (
		>=dev-qt/qtcore-5.12.11:5
		>=dev-qt/qtgui-5.12.11:5
		>=dev-qt/qtnetwork-5.12.11:5
		>=dev-qt/qtwidgets-5.12.11:5
		dbus? ( >=dev-qt/qtdbus-5.12.11:5 )
	)
	nat-pmp? ( >=net-libs/libnatpmp-20200924:= )
	qrcode? ( >=media-gfx/qrencode-3.4.4:= )
	sqlite? ( >=dev-db/sqlite-3.32.1:= )
	system-leveldb? ( virtual/bitcoin-leveldb )
	system-libsecp256k1? ( >=dev-libs/libsecp256k1-zkp-0.1.0_pre20220406:=[ecdh,extrakeys,rangeproof,recovery,schnorrsig,surjectionproof] )
	upnp? ( >=net-libs/miniupnpc-2.2.2:= )
	zeromq? ( >=net-libs/zeromq-4.3.1:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( >=dev-util/systemtap-4.8 )
"
BDEPEND="
	virtual/pkgconfig
	daemon? (
		acct-group/elements
		acct-user/elements
	)
	gui? ( >=dev-qt/linguist-tools-5.12.11:5 )
	test? ( ${PYTHON_DEPS} )
"
IDEPEND="
	gui? ( dev-util/desktop-file-utils )
"

DOCS=(
	doc/bips.md
	doc/bitcoin-conf.md
	doc/descriptors.md
	doc/files.md
	doc/i2p.md
	doc/JSON-RPC-interface.md
	doc/psbt.md
	doc/reduce-memory.md
	doc/reduce-traffic.md
	doc/release-notes.md
	doc/REST-interface.md
	doc/tor.md
)

PATCHES=(
	"${FILESDIR}/22.1.1-syslibs.patch"
)

efmt() {
	: ${1:?} ; local l ; while read -r l ; do "${!#}" "${l}" ; done < <(fmt "${@:1:$#-1}")
}

pkg_pretend() {
	if ! use daemon && ! use gui && ! has_version "${CATEGORY}/${PN}[-daemon,-gui]" ; then
		efmt ewarn <<-EOF
			You are enabling neither USE="daemon" nor USE="gui". This is a valid
			configuration, but you will be unable to run an Elements node using this
			installation.
		EOF
	fi
	if use daemon && ! use cli && ! has_version "${CATEGORY}/${PN}[daemon,-cli]" ; then
		efmt ewarn <<-EOF
			You are enabling USE="daemon" but not USE="cli". This is a valid
			configuration, but you will be unable to interact with your elementsd node
			via the command line using this installation.
		EOF
	fi
	if ! use berkdb && ! use sqlite &&
		{ { use daemon && ! has_version "${CATEGORY}/${PN}[daemon,-berkdb,-sqlite]" ; } ||
		  { use gui && ! has_version "${CATEGORY}/${PN}[gui,-berkdb,-sqlite]" ; } ; }
	then
		efmt ewarn <<-EOF
			You are enabling neither USE="berkdb" nor USE="sqlite". This is a valid
			configuration, but your Elements node will be unable to open any wallets.
		EOF
	fi
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/${P}-univalue-sources.mk" "${S}/src/univalue/sources.mk" || die
}

src_prepare() {
	backports_apply_patches
	default
	! use system-leveldb || rm -r src/leveldb || die
	if use system-libsecp256k1 ; then
		rm -r src/secp256k1 || die
		sed -e '/^DIST_SUBDIRS *=/s/\bsecp256k1\b//' -i src/Makefile.am || die
	else
		pushd src/secp256k1 >/dev/null || die
		AT_NOELIBTOOLIZE=yes eautoreconf
		popd >/dev/null || die
	fi
	eautoreconf

	# we say --disable-util-util, so we can't test elements-util
	sed -ne '/^  {/{h;:0;n;H;/^  }/!b0;g;\|"exec": *"\./elements-util"|d};p' \
		-i test/util/data/bitcoin-util-test.json || die
}

src_configure() {
	local wallet ; if use berkdb || use sqlite ; then wallet=enable ; else wallet=disable ; fi
	local myeconfargs=(
		--disable-static
		--${wallet}-wallet
		$(use_with sqlite)
		$(use_with berkdb bdb)
		$(use_enable systemtap ebpf)
		$(use_with upnp miniupnpc)
		$(use_with nat-pmp natpmp)
		$(use_enable test tests)
		--disable-bench
		--disable-fuzz{,-binary}
		$(use_with qrcode qrencode)
		--disable-ccache
		$(use_enable asm)
		$(use_enable zeromq zmq)
		$(use_enable man)
		$(use_enable external-signer)
		--with-utils
		$(use_enable {,util-}cli)
		--enable-util-tx
		--${wallet}-util-wallet
		--disable-util-util
		--without-libs
		$(use_with daemon)
		$(use_with gui gui qt5)
		$(use_with dbus qtdbus)
		$(use_with system-leveldb)
		$(use_with system-libsecp256k1)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use external-signer && DOCS+=( doc/external-signer.md )
	use zeromq && DOCS+=( doc/zmq.md )

	default

	find "${ED}" -type f -name '*.la' -delete || die
	! use test || rm -f -- "${ED}"/usr/bin/test_elements{,-qt} || die

	if use daemon ; then
		insinto /etc/elements
		sed -e 's/Bitcoin/Elements/g' -e 's/bitcoin\([^s]\)/elements\1/g' \
			-e '3a mainchainrpccookiefile=/var/lib/bitcoind/.cookie\' \
			-e 'rpccookiefile=/var/lib/elementsd/.cookie' \
			share/examples/bitcoin.conf >"${ED}/etc/elements/elements.conf" || die
		fowners elements:elements /etc/elements/elements.conf
		fperms 0660 /etc/elements/elements.conf

		newconfd "${FILESDIR}/elementsd.openrcconf" elementsd
		newinitd "${FILESDIR}/elementsd.openrc" elementsd
		systemd_dounit "${FILESDIR}/elementsd.service"

		keepdir /var/lib/elementsd
		fperms 0750 /var/lib/elementsd
		fowners elements:elements /var/lib/elementsd
		dosym -r {/etc/elements,/var/lib/elementsd}/elements.conf

		insinto /etc/logrotate.d
		newins "${FILESDIR}/elementsd.logrotate-r1" elementsd
	fi

	if use gui ; then
		insinto /usr/share/icons/hicolor/scalable/apps
		newins src/qt/res/src/bitcoin.svg elements.svg

		domenu "${FILESDIR}/org.elementsproject.elements-qt.desktop"
	fi

	if use examples ; then
		docinto examples
		dodoc -r contrib/{linearize,qos}
		use zeromq && dodoc -r contrib/zmq
	fi
}

pkg_postinst() {
	# we don't use xdg.eclass because it adds unconditional IDEPENDs
	if use gui ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi

	if use cli && use daemon ; then
		efmt -su elog <<-EOF
			To use elements-cli with the /etc/init.d/elementsd service:
			 - Add your user(s) to the 'elements' group.
			 - Symlink ~/.elements to /var/lib/elementsd.
		EOF
	fi
}

pkg_postrm() {
	if use gui ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
