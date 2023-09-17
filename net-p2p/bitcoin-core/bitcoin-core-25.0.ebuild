# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 db-use desktop systemd xdg-utils

DESCRIPTION="Reference implementation of the Bitcoin cryptocurrency"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="https://bitcoincore.org/bin/${P}/${P/-core}.tar.gz"
S="${WORKDIR}/${P/-core}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
# IUSE="+cli" doesn't work due to https://bugs.gentoo.org/831045#c3
IUSE="+asm +berkdb +bitcoin-cli +daemon dbus examples +external-signer kde libs +man nat-pmp +qrcode qt5 +sqlite system-leveldb +system-libsecp256k1 systemtap test upnp zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( qt5 )
	kde? ( qt5 )
	qrcode? ( qt5 )
	system-leveldb? ( || ( daemon qt5 ) )
"
# dev-libs/univalue is now bundled, as upstream dropped support for system copy
# and their version in the Bitcoin repo has deviated a fair bit from upstream.
# Upstream also seems very inactive.
RDEPEND="
	!dev-util/bitcoin-tx[-bitcoin-core(-)]
	>=dev-libs/boost-1.81.0:=
	>=dev-libs/libevent-2.1.12:=
	berkdb? ( >=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=[cxx] )
	bitcoin-cli? ( !net-p2p/bitcoin-cli[-bitcoin-core(-)] )
	daemon? (
		!net-p2p/bitcoind[-bitcoin-core(-)]
		acct-group/bitcoin
		acct-user/bitcoin
	)
	libs? ( !net-libs/libbitcoinconsensus[-bitcoin-core(-)] )
	nat-pmp? ( >=net-libs/libnatpmp-20220705:= )
	qrcode? ( >=media-gfx/qrencode-4.1.1:= )
	qt5? (
		!net-p2p/bitcoin-qt[-bitcoin-core(-)]
		>=dev-qt/qtcore-5.15.5:5
		>=dev-qt/qtgui-5.15.5:5
		>=dev-qt/qtnetwork-5.15.5:5
		>=dev-qt/qtwidgets-5.15.5:5
		dbus? ( >=dev-qt/qtdbus-5.15.5:5 )
	)
	sqlite? ( >=dev-db/sqlite-3.38.5:= )
	system-leveldb? ( virtual/bitcoin-leveldb )
	system-libsecp256k1? ( >=dev-libs/libsecp256k1-0.3.1:=[recovery,schnorr] )
	upnp? ( >=net-libs/miniupnpc-2.2.2:= )
	zeromq? ( >=net-libs/zeromq-4.3.4:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( >=dev-util/systemtap-4.8 )
"
BDEPEND="
	virtual/pkgconfig
	daemon? (
		acct-group/bitcoin
		acct-user/bitcoin
	)
	qt5? ( >=dev-qt/linguist-tools-5.15.5:5 )
	test? ( dev-lang/python )
"
IDEPEND="
	qt5? ( dev-util/desktop-file-utils )
"

DOCS=(
	doc/bips.md
	doc/bitcoin-conf.md
	doc/descriptors.md
	doc/files.md
	doc/i2p.md
	doc/JSON-RPC-interface.md
	doc/multisig-tutorial.md
	doc/p2p-bad-ports.md
	doc/psbt.md
	doc/reduce-memory.md
	doc/reduce-traffic.md
	doc/release-notes.md
	doc/REST-interface.md
	doc/tor.md
)

PATCHES=(
	"${FILESDIR}/25.0-syslibs.patch"
	"${FILESDIR}/init.patch"
)

src_prepare() {
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

	# we say --disable-util-util, so we can't test bitcoin-util
	sed -ne '/^  {/{h;:0;n;H;/^  }/!b0;g;\|"exec": *"\./bitcoin-util"|d};p' \
		-i test/util/data/bitcoin-util-test.json || die

	sed -e 's/^\(complete -F _bitcoind\b\).*$/\1'"$(usev daemon ' bitcoind')$(usev qt5 ' bitcoin-qt')/" \
		-i contrib/completions/bash/bitcoind.bash-completion || die
}

src_configure() {
	local wallet ; if use berkdb || use sqlite ; then wallet=enable ; else wallet=disable ; fi
	local myeconfargs=(
		--disable-static
		--${wallet}-wallet
		$(use_with sqlite)
		$(use_with berkdb bdb)
		$(use_enable systemtap usdt)
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
		$(use_enable {bitcoin,util}-cli)
		--enable-util-tx
		--${wallet}-util-wallet
		--disable-util-util
		$(use_with libs)
		$(use_with daemon)
		$(use_with qt5 gui qt5)
		$(use_with dbus qtdbus)
		$(use_with system-leveldb)
		$(use_with system-libsecp256k1)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use external-signer && DOCS+=( doc/external-signer.md )
	use berkdb || use sqlite && DOCS+=( doc/managing-wallets.md )
	use libs && DOCS+=( doc/shared-libraries.md )
	use systemtap && DOCS+=( doc/tracing.md )
	use zeromq && DOCS+=( doc/zmq.md )

	default

	! use libs || find "${ED}" -name '*.la' -delete || die
	! use test || rm -f -- "${ED}"/usr/bin/test_bitcoin{,-qt} || die

	newbashcomp contrib/completions/bash/bitcoin-tx.bash-completion bitcoin-tx
	use bitcoin-cli && newbashcomp contrib/completions/bash/bitcoin-cli.bash-completion bitcoin-cli
	use daemon || use qt5 && newbashcomp contrib/completions/bash/bitcoind.bash-completion bitcoind

	if use daemon ; then
		insinto /etc/bitcoin
		sed -ne 's/ To use, copy this file$//p;Tp;:0;n;/save the file\.$/!b0;d;:p;p' \
			share/examples/bitcoin.conf >"${ED}/etc/bitcoin/bitcoin.conf" || die
		fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
		fperms 600 /etc/bitcoin/bitcoin.conf

		newconfd contrib/init/bitcoind.openrcconf bitcoind
		newinitd "${FILESDIR}/bitcoind.openrc" bitcoind
		systemd_newunit contrib/init/bitcoind.service bitcoind.service

		keepdir /var/lib/bitcoind
		fperms 700 /var/lib/bitcoind
		fowners bitcoin:bitcoin /var/lib/bitcoind
		dosym -r /etc/bitcoin/bitcoin.conf /var/lib/bitcoind/bitcoin.conf
		dosym -r /var/lib/bitcoind /var/lib/bitcoin/.bitcoin

		doman "${FILESDIR}/bitcoin.conf.5"

		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoind.logrotate-r1" bitcoind
	fi

	if use qt5 ; then
		insinto /usr/share/icons/hicolor/scalable/apps
		newins src/qt/res/src/bitcoin.svg bitcoin128.svg

		domenu "${FILESDIR}/org.bitcoin.bitcoin-qt.desktop"

		if use kde ; then
			insinto /usr/share/kservices5
			doins "${FILESDIR}/bitcoin-qt.protocol"
			dosym ../../kservices5/bitcoin-qt.protocol /usr/share/kde4/services/bitcoin-qt.protocol
		fi
	fi

	if use examples ; then
		docinto examples
		dodoc -r contrib/{linearize,qos}
		use zeromq && dodoc -r contrib/zmq
	fi
}

pkg_preinst() {
	if use daemon ; then
		if [[ ! -d "${EROOT%/}/var/lib/bitcoin/.bitcoin" ]] ; then
			rm -r -- "${ED}/var/lib/bitcoin" || die
		elif [[ ! -e "${EROOT%/}/var/lib/bitcoind" ]] ; then
			elog "Moving your ${PORTAGE_COLOR_HILITE-${HILITE}}${EPREFIX%/}/var/lib/bitcoin/.bitcoin${PORTAGE_COLOR_NORMAL-${NORMAL}} to ${PORTAGE_COLOR_HILITE-${HILITE}}${EPREFIX%/}/var/lib/bitcoind${PORTAGE_COLOR_NORMAL-${NORMAL}}."
			mv --no-clobber --no-target-directory -- "${EROOT%/}"/var/lib/bitcoin{/.bitcoin,d} || die
			elog 'A transitional symlink will be installed for your convenience.'
		fi
	fi

	if use kde && [[ ! -d "${EROOT%/}/usr/share/kde4" ]] ; then
		rm -r -- "${ED}/usr/share/kde4" || die
	fi
}

pkg_postinst() {
	# we don't use xdg.eclass because it adds unconditional IDEPENDs
	if use qt5 ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi

	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' set up"
	elog "correctly, and:"
	elog "- Using an init script: add the 'bitcoin' user to the 'tor' user group."
	elog "- Running bitcoind directly: add that user to the 'tor' user group."
}

pkg_postrm() {
	if use qt5 ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
