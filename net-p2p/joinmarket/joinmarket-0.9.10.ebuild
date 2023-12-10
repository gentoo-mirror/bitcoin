# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="sqlite,ssl"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit desktop distutils-r1 qmake-utils

MyPN=${PN}-clientserver

DESCRIPTION="JoinMarket CoinJoin client and daemon"
HOMEPAGE="https://github.com/JoinMarket-Org/joinmarket-clientserver"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/JoinMarket-Org/miniircd/archive/20a391f490a58ba9ef295b0d813a95a7e9337382.tar.gz -> ${PN}-miniircd.tar.gz
	)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+client +daemon qt5"
REQUIRED_USE="
	client? ( daemon )
	qt5? ( client )
	test? ( client )
"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/chromalog-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/pyaes-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/service-identity-21.1.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-22.4.0[${PYTHON_USEDEP}]
		>=dev-python/txtorcon-22.0.0[${PYTHON_USEDEP}]

		client? (
			>=dev-python/autobahn-20.12.3[${PYTHON_USEDEP}]
			>=dev-python/argon2-cffi-21.3.0[${PYTHON_USEDEP}]
			>=dev-python/bencoder-pyx-3.0.1[${PYTHON_USEDEP}]
			>=dev-python/klein-20.6.0[${PYTHON_USEDEP}]
			>=dev-python/mnemonic-0.20[${PYTHON_USEDEP}]
			>=dev-python/pyjwt-2.4.0[${PYTHON_USEDEP}]
			>=dev-python/python-bitcointx-1.1.3[${PYTHON_USEDEP}]
			>=dev-python/werkzeug-2.2.3[${PYTHON_USEDEP}]
		)

		daemon? (
			>=dev-python/cryptography-3.3.2[${PYTHON_USEDEP}]
			amd64? ( >=dev-python/cryptography-41.0.2[${PYTHON_USEDEP}] )
			arm64? ( >=dev-python/cryptography-41.0.2[${PYTHON_USEDEP}] )
			>=dev-python/libnacl-1.8.0[${PYTHON_USEDEP}]
			>=dev-python/pyopenssl-23.2.0[${PYTHON_USEDEP}]
		)

		qt5? (
			dev-python/pillow[${PYTHON_USEDEP}]
			>=dev-python/pyside2-5.14.2[gui,widgets,${PYTHON_USEDEP}]
			>=dev-python/qrcode-7.3.1[${PYTHON_USEDEP}]
			>=dev-python/qt5reactor-0.6_pre20181201[${PYTHON_USEDEP}]
		)
	')

	client? (
		>=dev-libs/libsecp256k1-0.1_pre20211204[ecdh,recovery]
	)
"
DEPEND=""
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pexpect[${PYTHON_USEDEP}]
			>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
			!!<dev-python/pytest-twisted-1.13.4-r1[${PYTHON_USEDEP}]
		)
	')

	qt5? (
		dev-qt/qtwidgets
	)

	test? (
		|| (
			>=net-p2p/bitcoin-core-0.20[berkdb(-),bitcoin-cli(-),daemon(-)]
			(
				>=net-p2p/bitcoin-cli-0.20
				>=net-p2p/bitcoind-0.20[berkdb,wallet]
			)
		)
	)
"

S="${WORKDIR}/${MyPN}-${PV}"

distutils_enable_tests pytest

python_foreach_subdir() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd "${subdir}" >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
}

pkg_setup() {
	PYTHON_SUBDIRS=( jmbase )
	use client && PYTHON_SUBDIRS+=( jmbitcoin jmclient )
	use daemon && PYTHON_SUBDIRS+=( jmdaemon )
	use qt5 && PYTHON_SUBDIRS+=( jmqtui )

	python-single-r1_pkg_setup
}

src_unpack() {
	default
	use !test || mv miniircd-* "${S}/miniircd" || die
}

src_prepare() {
	sed -e 's|^\(Exec=\).*$|\1joinmarket-qt.py|' \
			-e '/^Name=/a Categories=Network;P2P;Qt;' \
			-i joinmarket-qt.desktop || die

	# Gentoo is not affected by https://bugreports.qt.io/browse/QTBUG-88688
	sed -e 's/\(PySide2\|PyQt5\)!=5\.15\.0,!=5\.15\.1,!=5\.15\.2,!=6\.0/\1/' \
			-e '/QTBUG-88688$/d' \
			-i requirements/gui.txt \
			-i jmqtui/setup.py || die

	# PySide2 no longer ships pyside2-uic in favor of 'uic -g python'
	# https://bugreports.qt.io/browse/PYSIDE-1098
	local UIC="$(qt5_get_bindir)/uic"
	sed -e 's/^#\(import os\)$/\1/' \
			-e 's:^#\?\(os\.system('\''\)pyside2-uic:\1'"${UIC//:/\\:}"' -g python:' \
			-i jmqtui/setup.py || die

	# https://github.com/JoinMarket-Org/joinmarket-clientserver/commit/c8eef50e9347bb14d0e30ea046b6d59898fbb65e
	mkdir test/unified || die
	mv test/*.py test/unified/ || die
	local each ; for each in */test/ ; do
		mv --no-clobber --no-target-directory -- "${each%/}" "test/${each%/test/}" || die
	done

	distutils-r1_src_prepare
}

python_compile_subdir() {
	distutils-r1_python_compile
	rm -rf -- "${BUILD_DIR}/build" || die
}

python_compile() {
	python_foreach_subdir python_compile_subdir
}

src_test() {
	# avoid package occlusion when running tests
	rm -rf -- "${PYTHON_SUBDIRS[@]}" || die

	distutils-r1_src_test
}

python_test() {
	ln -sfn test/regtest_joinmarket.cfg joinmarket.cfg || die

	local jm_test_datadir=${T}/jm_test_home/.bitcoin
	rm -rf -- "${jm_test_datadir}" || die
	mkdir -p -- "${jm_test_datadir}" || die

	local btcconf=${jm_test_datadir}/bitcoin.conf
	cp -f -- test/bitcoin.conf "${btcconf}" || die
	echo "datadir=${jm_test_datadir}" >>"${btcconf}" || die

	# https://github.com/bitcoin/bitcoin/pull/28597
	if has_version '>=net-p2p/bitcoin-core-26' ; then
		echo 'deprecatedrpc=create_bdb' >>"${btcconf}" || die
	fi

	epytest \
		test \
		--nirc=2 \
		--btcconf="${btcconf}" \
		$(sed -n \
			-e 's/^rpcuser=\(.*\)$/--btcuser=\1/p' \
			-e 's/^rpcpassword=\(.*\)$/--btcpwd=\1/p' \
			"${btcconf}")
}

src_install() {
	distutils-r1_src_install

	scripts_to_install() {
		{
			ls -1 scripts/*.py
			find scripts/*.py "${@}" -perm /0111
			use client || grep -l '\bjmclient\b' scripts/*.py
			use daemon || grep -l '\bjmdaemon\b' scripts/*.py
			use qt5 || grep -l '\bPySide2\b' scripts/*.py
		} | sort | uniq -u
	}

	local install=( $(scripts_to_install) )
	(( ${#install[@]} )) && python_domodule "${install[@]}"
	local install=( $(scripts_to_install !) )
	(( ${#install[@]} )) && python_doscript "${install[@]}"

	dodoc -r README.md docs/{*.md,images,release-notes}
	newdoc scripts{/,-}README.md

	if use qt5 ; then
		doicon docs/images/joinmarket_logo.png
		domenu joinmarket-qt.desktop
	fi
}

pkg_preinst() {
	has_version '<net-p2p/joinmarket-0.6.2' && had_pre_0_6_2=1
	has_version '<net-p2p/joinmarket-0.8.0' && had_pre_0_8_0=1
	has_version '<net-p2p/joinmarket-0.9.0' && had_pre_0_9_0=1
}

pkg_postinst() {
	elog "It is always a good idea to back up your ${PORTAGE_COLOR_HILITE-${HILITE}}joinmarket.cfg${PORTAGE_COLOR_NORMAL-${NORMAL}}, re-create a"
	elog 'default one, and then reapply your changes, as this will populate any'
	elog 'newly introduced config settings and update any default values. Please'
	elog 'see the release notes for more information and important announcements:'
	elog "${HOMEPAGE}/blob/master/docs/release-notes/release-notes-${PV}.md"
	if [[ ${had_pre_0_6_2} ]] ; then
		ewarn 'This release of JoinMarket moves the user data directory to ~/.joinmarket.'
		ewarn 'You must manually move any existing data files. See the release notes:'
		ewarn "${HOMEPAGE}/blob/master/docs/release-notes/release-notes-0.6.2.md#move-user-data-to-home-directory"
	fi
	if [[ ${had_pre_0_8_0} ]] ; then
		ewarn 'JoinMarket is migrating to native SegWit wallets and transactions.'
		ewarn 'Please follow the upgrade guide at:'
		ewarn "${HOMEPAGE}/blob/master/docs/NATIVE-SEGWIT-UPGRADE.md"
	fi
	if [[ ${had_pre_0_9_0} ]] ; then
		ewarn 'JoinMarket has introduced fidelity bonds as a means of improving Sybil attack'
		ewarn 'resistance. You must manually update your wallet to a fidelity bond wallet if'
		ewarn 'you wish to take advantage of this new privacy-enhancing feature. See the'
		ewarn 'release notes for more information.'
	fi
}
