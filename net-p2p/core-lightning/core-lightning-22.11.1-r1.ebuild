# Copyright 2010-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( {10..15} )

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_SUBDIRS=( contrib/{pyln-proto,pyln-spec/bolt{1,2,4,7},pyln-client} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=poetry

CARGO_OPTIONAL=1
CRATES="
	aho-corasick-0.7.19
	anyhow-1.0.66
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.58
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.1
	bitcoin_hashes-0.10.0
	bitflags-1.3.2
	bumpalo-3.11.1
	bytes-1.2.1
	cc-1.0.76
	cfg-if-1.0.0
	chrono-0.4.22
	data-encoding-2.3.2
	der-oid-macro-0.5.0
	der-parser-6.0.1
	either-1.8.0
	env_logger-0.9.3
	fastrand-1.8.0
	fixedbitset-0.2.0
	fnv-1.0.7
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	getrandom-0.2.8
	h2-0.3.15
	hashbrown-0.12.3
	heck-0.3.3
	hermit-abi-0.1.19
	hex-0.4.3
	http-0.2.8
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.23
	hyper-timeout-0.4.1
	indexmap-1.9.1
	instant-0.1.12
	itertools-0.10.5
	itoa-1.0.4
	js-sys-0.3.60
	lazy_static-1.4.0
	libc-0.2.137
	log-0.4.17
	memchr-2.5.0
	minimal-lexical-0.2.1
	mio-0.8.5
	multimap-0.8.3
	nom-7.1.1
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.14.0
	oid-registry-0.2.0
	once_cell-1.16.0
	pem-1.1.0
	percent-encoding-2.2.0
	petgraph-0.5.1
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.17
	proc-macro2-1.0.47
	prost-0.8.0
	prost-build-0.8.0
	prost-derive-0.8.0
	prost-types-0.8.0
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rcgen-0.8.14
	redox_syscall-0.2.16
	regex-1.7.0
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	ring-0.16.20
	rusticata-macros-4.1.0
	rustls-0.19.1
	ryu-1.0.11
	sct-0.6.1
	secp256k1-0.22.2
	secp256k1-sys-0.5.2
	serde-1.0.147
	serde_derive-1.0.147
	serde_json-1.0.87
	slab-0.4.7
	socket2-0.4.7
	spin-0.5.2
	syn-1.0.103
	tempfile-3.3.0
	termcolor-1.1.3
	thiserror-1.0.37
	thiserror-impl-1.0.37
	tokio-1.21.2
	tokio-io-timeout-1.2.0
	tokio-macros-1.8.0
	tokio-rustls-0.22.0
	tokio-stream-0.1.11
	tokio-util-0.6.10
	tokio-util-0.7.4
	tonic-0.5.2
	tonic-build-0.5.2
	tower-0.4.13
	tower-layer-0.3.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-futures-0.2.5
	try-lock-0.2.3
	unicode-ident-1.0.5
	unicode-segmentation-1.10.0
	untrusted-0.7.1
	want-0.3.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	web-sys-0.3.60
	webpki-0.21.4
	which-4.3.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.42.0
	x509-parser-0.12.0
	yasna-0.4.0
"

inherit bash-completion-r1 cargo distutils-r1 postgres toolchain-funcs

MyPN=lightning
MyPV=${PV/_}
PATCH_HASHES=(
	ed4815527aba7a3d11bd9f33b441372edd56310e	# gossipd: avoid gossipd crash due to double freeing timer
	8315c7c906a0d54f2157009665d0b091d746dcbe	# lightningd: don't send channeld message to onchaind.
)
PATCH_FILES=( "${PATCH_HASHES[@]/%/.patch}" )
PATCHES=(
	"${PATCH_FILES[@]/#/${DISTDIR%/}/}"
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="${HOMEPAGE}/archive/v${MyPV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	https://github.com/valyala/gheap/archive/67fc83bc953324f4759e52951921d730d7e65099.tar.gz -> gheap-67fc83b.tar.gz
	rust? ( $(cargo_crate_uris) )
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="developer doc experimental +man postgres python rust sqlite test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
	>=dev-libs/gmp-6.1.2:=
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-0.8.5:0/0.8.2[elements]
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.13:=
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.29.0:= )
"
PYTHON_DEPEND="
	>=dev-python/base58-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/bitstring-3.1.9[${PYTHON_USEDEP}]
	>=dev-python/coincurve-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}
	acct-group/lightning
	acct-user/lightning
	python? ( ${PYTHON_DEPEND} )
"
DEPEND="${CDEPEND}
"
BDEPEND="
	acct-group/lightning
	acct-user/lightning
	man? ( app-text/lowdown )
	$(python_gen_any_dep '
		>=dev-python/mako-1.1.6[${PYTHON_USEDEP}]
	')
	doc? ( $(python_gen_any_dep '
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	') )
	python? (
		>=dev-python/installer-0.4.0_p20220124[${PYTHON_USEDEP}]
		>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
		test? (
			>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
			${PYTHON_DEPEND}
		)
	)
	rust? ( ${RUST_DEPEND} )
	sys-devel/gettext
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"
# FIXME: bundled deps: ccan

S=${WORKDIR}/${MyPN}-${MyPV}
DOCS=( CHANGELOG.md README.md doc/{BACKUP,FAQ,PLUGINS,TOR}.md )

python_check_deps() {
	{ [[ " ${python_need} " != *' mako '* ]] || python_has_version \
		"dev-python/mako[${PYTHON_USEDEP}]" ; } &&
	{ [[ " ${python_need} " != *' sphinx '* ]] || python_has_version \
		dev-python/{recommonmark,sphinx{,_rtd_theme}}"[${PYTHON_USEDEP}]" ; }
}

python_foreach_subdir() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd "${subdir}" >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
}

pkg_pretend() {
	if [[ ! "${REPLACE_RUNNING_CLIGHTNING}" ]] &&
		[[ -x "${EROOT%/}/usr/bin/lightningd" ]] &&
		{ has_version "<${CATEGORY}/${PN}-$(ver_cut 1-3)" ||
			has_version ">=${CATEGORY}/${PN}-$(ver_cut 1-2).$(($(ver_cut 3)+1))" ; } &&
		[[ "$(find /proc/[0-9]*/exe -xtype f -lname "${EROOT%/}/usr/bin/lightningd*" -print -quit 2>/dev/null)" ||
			-x "${EROOT%/}/run/openrc/started/lightningd" ]]
	then
		eerror "A potentially incompatible version of the lightningd daemon is currently" \
			'\n'"running. Installing version ${PV} would likely cause the running daemon" \
			'\n'"to fail when it next spawns a subdaemon process. Please stop the running" \
			'\n'"daemon and reattempt this installation, or set REPLACE_RUNNING_CLIGHTNING=1" \
			'\n'"if you are certain you know what you are doing."
		die 'lightningd is running'
	fi
}

pkg_setup() {
	if use postgres ; then
		postgres_pkg_setup
	else
		export PG_CONFIG=
	fi
	use test && tc-ld-disable-gold	# mock magic doesn't support gold
}

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/external" || die
	rm -r */ || die
	unpack jsmn-1.0.0.tar.gz gheap-67fc83b.tar.gz
	mv jsmn{-1.0.0,} || die
	mv gheap{-*,} || die

	if use rust ; then
		set ${CRATES}
		local A="${*/%/.crate}"
		cargo_src_unpack
	fi
}

src_prepare() {
	# hack to suppress tools/refresh-submodules.sh
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' -i external/Makefile || die

	if ! use sqlite ; then
		sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die
	fi

	default

	# only run 'install' command if there are actually files to install
	sed -e 's/^\t\$(INSTALL_DATA) \(\$([^)]\+)\).*$/ifneq (\1,)\n\0\nendif/' \
		-i Makefile || die

	# don't look for headers or libraries beneath /usr/local
	sed -e '/"Darwin-arm64"/,/^$/d' \
		-e 's/ *\(-[IL]\$(\?\(CPATH\|LIBRARY_PATH\))\? *\)\+/ /g' \
		-i configure Makefile || die

	# we'll strip the binaries ourselves
	sed -e '/^[[:space:]]*strip[[:space:]]*=/d' -i Cargo.toml || die

	# don't require running in a Git worktree
	sed -e '/^import subprocess$/d' \
		-e 's/^\(version = \).*$/\1"'"$(ver_cut 1-3)"'"/' \
		-e 's/^\(release = \).*$/\1"'"${MyPV}-gentoo-${PR}"'"/' \
		-i doc/conf.py || die

	# our VERSION="${MyPV}-gentoo-${PR}" confuses is_released_version()
	[[ ${PV} != *([.[:digit:]]) ]] ||
		sed -ne '/^static bool is_released_version(void)/{a { return true; }
			p;:x;n;/^}$/d;bx};p' -i wallet/db.c || die

	use python && distutils-r1_src_prepare

	if use rust && ! has_version -b 'virtual/rust[rustfmt]' ; then
		# suppress transitive dependency on rustfmt
		sed -e 's/^\(tonic-build = \)\(.*\)$/\1{ version = \2, default-features = false, features = ["prost", "transport"] }/' \
			-i cln-grpc/Cargo.toml || die
	fi
}

src_configure() {
	local BUNDLED_LIBS="external/${CHOST}/libjsmn.a"
	. "${FILESDIR}/compat_vars.bash"
	CLIGHTNING_MAKEOPTS=(
		V=1
		VERSION="${MyPV}-gentoo-${PR}"
		DISTRO=Gentoo
		COVERAGE=
		DEVTOOLS=
		DOC_DATA=
		BOLTDIR="${WORKDIR}/does_not_exist"
		COMPAT_CFLAGS="${COMPAT_CFLAGS[*]}"
		LIBSODIUM_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		LIBBACKTRACE_HEADERS=
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ -I external/gheap/ $("$(tc-getPKG_CONFIG)" --cflags libsodium wallycore libsecp256k1_zkp)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $("$(tc-getPKG_CONFIG)" --libs libsodium wallycore libsecp256k1_zkp) -lbacktrace"
		docdir="/usr/share/doc/${PF}"
	)

	use man || CLIGHTNING_MAKEOPTS+=(
		MANPAGES=
	)

	use test || CLIGHTNING_MAKEOPTS+=(
		ALL_TEST_PROGRAMS=
	)

	use sqlite || CLIGHTNING_MAKEOPTS+=(
		SQLITE3_CFLAGS=
		SQLITE3_LDLIBS=
	)

	use rust && CLIGHTNING_MAKEOPTS+=(
		RUST_PROFILE=release
		CARGO_OPTS=--profile=release
		CLN_RPC_EXAMPLES=
		CLN_GRPC_EXAMPLES=
		CLN_PLUGIN_EXAMPLES=
	)

	python_need='mako' python_setup
	set ./configure \
		CC="$(tc-getCC)" \
		CONFIGURATOR_CC="$(tc-getBUILD_CC)" \
		CWARNFLAGS= \
		CDEBUGFLAGS='-std=gnu11' \
		COPTFLAGS="${CFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		$(use_enable developer) \
		$(use_enable experimental{,-features}) \
		--disable-compat \
		--disable-valgrind \
		--disable-static \
		--disable-address-sanitizer \
		--disable-ub-sanitize \
		--disable-fuzzing \
		$(use_enable rust)
	echo "${@}"
	"${@}" || die 'configure failed'

	use python && distutils-r1_src_configure
	use rust && cargo_src_configure
}

src_compile() {
	python_need='mako' python_setup
	emake "${CLIGHTNING_MAKEOPTS[@]}"

	if use doc ; then
		local python_need='sphinx'
		python_setup
		build_sphinx doc
	fi

	use python && distutils-r1_src_compile
}

python_compile() {
	python_foreach_subdir distutils-r1_python_compile
}

python_compile_all() {
	use doc && python_foreach_subdir python_compile_subdir_docs
}

python_compile_subdir_docs() {
	local -a HTML_DOCS
	[[ -f docs/conf.py ]] && build_sphinx docs
}

src_test() {
	# disable flaky bitcoin/test/run-secret_eq_consttime
	SLOW_MACHINE=1 \
	emake "${CLIGHTNING_MAKEOPTS[@]}" check-units

	use python && distutils-r1_src_test
	use rust && cargo_src_test
}

python_test() {
	epytest "${PYTHON_SUBDIRS[@]}"
}

python_install_all() {
	python_foreach_subdir python_install_subdir_docs
}

python_install_subdir_docs() {
	local shopt_pop=$(shopt -p nullglob)
	shopt -s nullglob
	local -a docs=( README* )
	${shopt_pop}
	docinto "${PWD##*/}"
	(( ${#docs[@]} )) && dodoc "${docs[@]}"
	use doc && [[ -d docs/_build/html ]] && dodoc -r docs/_build/html
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install
	einstalldocs

	insinto /etc/lightning
	newins "${FILESDIR}/lightningd-22.11.1.conf" lightningd.conf
	fowners :lightning /etc/lightning/lightningd.conf
	fperms 0640 /etc/lightning/lightningd.conf

	newinitd "${FILESDIR}/init.d-lightningd" lightningd
	newconfd "${FILESDIR}/conf.d-lightningd" lightningd

	newbashcomp contrib/lightning-cli.bash-completion lightning-cli

	use python && distutils-r1_src_install

	insinto "/etc/portage/savedconfig/${CATEGORY}"
	newins compat.vars "${PN}"
}

pkg_preinst() {
	if [[ -e ${EROOT%/}/etc/lightning/config && ! -e ${EROOT%/}/etc/lightning/lightningd.conf ]] ; then
		elog "Moving your /etc/lightning/config to /etc/lightning/lightningd.conf"
		mv --no-clobber -- "${EROOT%/}/etc/lightning/"{config,lightningd.conf}
	fi
}

pkg_postinst() {
	elog 'To use lightning-cli with the /etc/init.d/lightningd service:'
	elog " - Add your user(s) to the 'lightning' group."
	elog ' - Symlink ~/.lightning to /var/lib/lightning.'
}
