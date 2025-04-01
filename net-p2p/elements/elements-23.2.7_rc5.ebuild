# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools backports check-reqs db-use desktop edo python-any-r1 systemd toolchain-funcs xdg-utils

BACKPORTS=(
	1c7e820ded0846ef6ab4be9616b0de452336ef64	# script: add script to generate example bitcoin.conf
)

MyPV="${PN}-${PV/_}"
DESCRIPTION="Implementation of advanced blockchain features extending the Bitcoin protocol"
HOMEPAGE="https://elementsproject.org/"
BACKPORTS_BASE_URI="https://github.com/bitcoin/bitcoin/commit/"
SRC_URI="https://github.com/ElementsProject/${PN}/archive/refs/tags/${MyPV}.tar.gz
	$(backports_patch_uris)"
S="${WORKDIR}/${PN}-${MyPV}"

LICENSE="MIT"
SLOT="0"
if [[ "${PV}" != *_rc* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi
IUSE="+asm +berkdb +cli +daemon dbus examples +external-signer gui +man nat-pmp +qrcode +sqlite +system-libsecp256k1 systemtap test upnp zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( gui )
	qrcode? ( gui )
"
RDEPEND="
	>=dev-libs/boost-1.81.0:=
	>=dev-libs/libevent-2.1.12:=
	berkdb? ( >=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=[cxx] )
	daemon? (
		acct-group/elements
		acct-user/elements
	)
	gui? (
		>=dev-qt/qtcore-5.15.3:5
		>=dev-qt/qtgui-5.15.3:5
		>=dev-qt/qtnetwork-5.15.3:5
		>=dev-qt/qtwidgets-5.15.3:5
		dbus? ( >=dev-qt/qtdbus-5.15.3:5 )
	)
	nat-pmp? ( >=net-libs/libnatpmp-20200924:= )
	qrcode? ( >=media-gfx/qrencode-3.4.4:= )
	sqlite? ( >=dev-db/sqlite-3.32.1:= )
	system-libsecp256k1? ( >=dev-libs/libsecp256k1-zkp-0.1.0_pre20220406:=[ecdh,extrakeys,rangeproof,recovery,schnorrsig,surjectionproof] )
	upnp? ( >=net-libs/miniupnpc-2.2.2:= )
	zeromq? ( >=net-libs/zeromq-4.3.1:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( >=dev-debug/systemtap-4.5 )
"
BDEPEND="
	virtual/pkgconfig
	daemon? (
		acct-group/elements
		acct-user/elements
	)
	gui? ( >=dev-qt/linguist-tools-5.15.3:5 )
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
	"${FILESDIR}/23.2.1-syslibs.patch"
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

	# test/functional/feature_pruning.py requires 4 GB disk space
	use test && CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
}

pkg_setup() {
	if use test ; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_setup
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	backports_apply_patches
	default
	if use system-libsecp256k1 ; then
		rm -r src/secp256k1 || die
		sed -e '/^DIST_SUBDIRS *=/s/\bsecp256k1\b//' -i src/Makefile.am || die
	else
		pushd src/secp256k1 >/dev/null || die
		AT_NOELIBTOOLIZE=yes eautoreconf
		popd >/dev/null || die
	fi
	eautoreconf

	mv contrib/devtools/gen-{bitcoin,elements}-conf.sh || die
	sed -e 's/bitcoin/elements/g' \
		-i contrib/devtools/gen-elements-conf.sh || die

	mv share/examples/{bitcoin,elements}.conf || die
	sed -e 's/Bitcoin/Elements/g' -e 's/bitcoin\([^s]\)/elements\1/g' \
		-e '3a mainchainrpccookiefile=/var/lib/bitcoind/.cookie\' \
		-e 'rpccookiefile=/var/lib/elementsd/.cookie' \
		-i share/examples/elements.conf || die

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
		$(use_enable {,util-}cli)
		--enable-util-tx
		--${wallet}-util-wallet
		--disable-util-util
		# syscall sandbox is missing faccessat2 and pselect6, causing test failures;
		# removed upstream for 26.0 in https://github.com/bitcoin/bitcoin/commit/32e2ffc39374f61bb2435da507f285459985df9e
		--without-seccomp
		--without-libs
		$(use_with daemon)
		$(use_with gui gui qt5)
		$(use_with dbus qtdbus)
		$(use_with system-libsecp256k1)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use daemon && ! tc-is-cross-compiler ; then
		TOPDIR="${S}" bash contrib/devtools/gen-elements-conf.sh || die
		sed -e 's:^#\?\(mainchainrpccookiefile=\).*$:\1/var/lib/bitcoind/.cookie:;tp' \
			-e 's:^#\?\(rpccookiefile=\).*$:\1/var/lib/elementsd/.cookie:;tp' \
			-e 's/ To use, copy this file$//p;Tp;:0;n;/save the file\.$/!b0;d;:p;p' \
			-ni share/examples/elements.conf || die
	fi
}

src_test() {
	emake check

	# --extended fails
	# https://github.com/ElementsProject/elements/issues/1296
	# https://github.com/ElementsProject/elements/issues/1297
	use daemon && edo "${PYTHON}" test/functional/test_runner.py \
			--ansi --jobs="$(get_makeopts_jobs)" --timeout-factor="${TIMEOUT_FACTOR:-15}"
}

src_install() {
	use external-signer && DOCS+=( doc/external-signer.md )
	use berkdb || use sqlite && DOCS+=( doc/managing-wallets.md )
	use systemtap && DOCS+=( doc/tracing.md )
	use zeromq && DOCS+=( doc/zmq.md )

	if use daemon ; then
		# https://bugs.gentoo.org/757102
		DOCS+=( share/rpcauth/rpcauth.py )
		docompress -x "/usr/share/doc/${PF}/rpcauth.py"
	fi

	default

	find "${ED}" -type f -name '*.la' -delete || die
	! use test || rm -f -- "${ED}"/usr/bin/test_{bitcoin,elements}{,-qt} || die

	if use daemon ; then
		insinto /etc/elements
		doins share/examples/elements.conf
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
