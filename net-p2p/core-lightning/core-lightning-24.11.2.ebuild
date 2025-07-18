# Copyright 2010-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( {11..16} )

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_SUBDIRS=( contrib/{pyln-proto,pyln-spec/bolt{1,2,4,7},pyln-client} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=poetry

CARGO_OPTIONAL=1
CRATES="
	addr2line-0.24.2
	adler2-2.0.0
	aho-corasick-1.1.3
	anyhow-1.0.93
	asn1-rs-0.6.2
	asn1-rs-derive-0.5.1
	asn1-rs-impl-0.2.0
	async-stream-0.3.6
	async-stream-impl-0.3.6
	async-trait-0.1.83
	autocfg-1.4.0
	axum-0.6.20
	axum-core-0.3.4
	backtrace-0.3.74
	base64-0.21.7
	base64-0.22.1
	bech32-0.10.0-beta
	bitcoin-0.31.2
	bitcoin-internals-0.2.0
	bitcoin_hashes-0.13.0
	bitflags-1.3.2
	bitflags-2.6.0
	byteorder-1.5.0
	bytes-1.8.0
	cc-1.1.37
	cfg-if-1.0.0
	data-encoding-2.6.0
	der-parser-9.0.0
	deranged-0.3.11
	displaydoc-0.2.5
	either-1.13.0
	env_logger-0.10.2
	equivalent-1.0.1
	errno-0.3.9
	fastrand-2.2.0
	fixedbitset-0.4.2
	fnv-1.0.7
	futures-0.3.31
	futures-channel-0.3.31
	futures-core-0.3.31
	futures-executor-0.3.31
	futures-io-0.3.31
	futures-macro-0.3.31
	futures-sink-0.3.31
	futures-task-0.3.31
	futures-util-0.3.31
	getrandom-0.2.15
	gimli-0.31.1
	h2-0.3.26
	hashbrown-0.12.3
	hashbrown-0.15.1
	heck-0.5.0
	hermit-abi-0.3.9
	hermit-abi-0.4.0
	hex-0.4.3
	hex-conservative-0.1.2
	hex_lit-0.1.1
	http-0.2.12
	http-body-0.4.6
	httparse-1.9.5
	httpdate-1.0.3
	humantime-2.1.0
	hyper-0.14.31
	hyper-timeout-0.4.1
	indexmap-1.9.3
	indexmap-2.6.0
	is-terminal-0.4.13
	itertools-0.12.1
	itoa-1.0.11
	lazy_static-1.5.0
	libc-0.2.162
	linux-raw-sys-0.4.14
	log-0.4.22
	matchers-0.1.0
	matchit-0.7.3
	memchr-2.7.4
	mime-0.3.17
	minimal-lexical-0.2.1
	miniz_oxide-0.8.0
	mio-1.0.2
	multimap-0.10.0
	nom-7.1.3
	nu-ansi-term-0.46.0
	num-bigint-0.4.6
	num-conv-0.1.0
	num-integer-0.1.46
	num-traits-0.2.19
	object-0.36.5
	oid-registry-0.7.1
	once_cell-1.20.2
	overload-0.1.1
	pem-3.0.4
	percent-encoding-2.3.1
	petgraph-0.6.5
	pin-project-1.1.7
	pin-project-internal-1.1.7
	pin-project-lite-0.2.15
	pin-utils-0.1.0
	powerfmt-0.2.0
	ppv-lite86-0.2.20
	prettyplease-0.2.25
	proc-macro2-1.0.89
	prost-0.12.6
	prost-build-0.12.6
	prost-derive-0.12.6
	prost-types-0.12.6
	quote-1.0.37
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rcgen-0.13.1
	regex-1.11.1
	regex-automata-0.1.10
	regex-automata-0.4.8
	regex-syntax-0.6.29
	regex-syntax-0.8.5
	ring-0.17.8
	rustc-demangle-0.1.24
	rusticata-macros-4.1.0
	rustix-0.38.39
	rustls-0.22.4
	rustls-pemfile-2.2.0
	rustls-pki-types-1.10.0
	rustls-webpki-0.102.8
	rustversion-1.0.18
	ryu-1.0.18
	secp256k1-0.28.2
	secp256k1-sys-0.9.2
	serde-1.0.214
	serde_derive-1.0.214
	serde_json-1.0.132
	sharded-slab-0.1.7
	shlex-1.3.0
	slab-0.4.9
	smallvec-1.13.2
	socket2-0.5.7
	spin-0.9.8
	subtle-2.6.1
	syn-2.0.87
	sync_wrapper-0.1.2
	synstructure-0.13.1
	tempfile-3.14.0
	termcolor-1.4.1
	thiserror-1.0.68
	thiserror-impl-1.0.68
	thread_local-1.1.8
	time-0.3.36
	time-core-0.1.2
	time-macros-0.2.18
	tokio-1.41.1
	tokio-io-timeout-1.2.0
	tokio-macros-2.4.0
	tokio-rustls-0.25.0
	tokio-stream-0.1.16
	tokio-test-0.4.4
	tokio-util-0.7.12
	tonic-0.11.0
	tonic-build-0.11.0
	tower-0.4.13
	tower-layer-0.3.3
	tower-service-0.3.3
	tracing-0.1.40
	tracing-attributes-0.1.27
	tracing-core-0.1.32
	tracing-log-0.2.0
	tracing-subscriber-0.3.18
	try-lock-0.2.5
	unicode-ident-1.0.13
	untrusted-0.9.0
	valuable-0.1.0
	want-0.3.1
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.9
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.52.0
	windows-sys-0.59.0
	windows-targets-0.52.6
	windows_aarch64_gnullvm-0.52.6
	windows_aarch64_msvc-0.52.6
	windows_i686_gnu-0.52.6
	windows_i686_gnullvm-0.52.6
	windows_i686_msvc-0.52.6
	windows_x86_64_gnu-0.52.6
	windows_x86_64_gnullvm-0.52.6
	windows_x86_64_msvc-0.52.6
	x509-parser-0.16.0
	yasna-0.5.2
	zerocopy-0.7.35
	zerocopy-derive-0.7.35
	zeroize-1.8.1
"

inherit backports bash-completion-r1 cargo distutils-r1 edo postgres toolchain-funcs

MyPN=lightning
MyPV=${PV/_}
MyPVR=${MyPV}-gentoo-${PR}

BACKPORTS=(
	a98ff02c199fdb4f42a5ca82c8415951eb001c25	# cln-rpc/Makefile: fix typo CLN_RPC_GEN_ALL=>CLN_RPC_GENALL￼
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
BACKPORTS_BASE_URI="${HOMEPAGE}/commit/"
SRC_URI="${HOMEPAGE}/archive/refs/tags/v${MyPV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	https://github.com/valyala/gheap/archive/67fc83bc953324f4759e52951921d730d7e65099.tar.gz -> gheap-67fc83b.tar.gz
	rust? ( $(cargo_crate_uris) )
	$(backports_patch_uris)
"
S="${WORKDIR}/${MyPN}-${MyPV}"

LICENSE="MIT BSD-2 CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
if [[ "${PV}" != *_rc* ]] ; then
	KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
fi
IUSE="debug doc +man postgres python rust sqlite test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	|| ( net-libs/libwally-core:0/6[elements] >=net-libs/libwally-core-1.3.0:0/1[elements] )
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.13:=
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.29.0:= )
"
PYTHON_DEPEND="
	>=dev-python/base58-2.1.1[${PYTHON_USEDEP}]
	|| (
		>=dev-python/bitstring-4.2.2[${PYTHON_USEDEP}]
		<dev-python/bitstring-4.2[${PYTHON_USEDEP}]
	)
	!<dev-python/bitstring-4.1
	>=dev-python/coincurve-20[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42[${PYTHON_USEDEP}]
	>=dev-python/pysocks-1[${PYTHON_USEDEP}]
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
	>=app-misc/jq-1.6
	man? ( app-text/lowdown )
	$(python_gen_any_dep '
		>=dev-python/mako-1.1.6[${PYTHON_USEDEP}]
	')
	doc? (
		python? ( $(python_gen_any_dep '
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		') )
		$(python_gen_any_dep '
			>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
			dev-python/mkdocs[${PYTHON_USEDEP}]
			dev-python/mkdocs-exclude[${PYTHON_USEDEP}]
			dev-python/mkdocs-material[${PYTHON_USEDEP}]
		')
	)
	python? (
		${DISTUTILS_DEPS}
		test? (
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			${PYTHON_DEPEND}
		)
	)
	rust? (
		${RUST_DEPEND}
		>=dev-libs/protobuf-4[protoc(+)]
	)
	sys-devel/gettext
	virtual/pkgconfig
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE/||/^^} )
	python? ( ${PYTHON_REQUIRED_USE} )
"
# FIXME: bundled deps: ccan

PATCHES=(
)

DOCS=( CHANGELOG.md README.md SECURITY.md )

python_check_deps() {
	{ [[ " ${python_need} " != *' mako '* ]] || python_has_version \
		dev-python/mako"[${PYTHON_USEDEP}]" ; } &&
	{ [[ " ${python_need} " != *' mkdocs '* ]] || python_has_version \
		dev-python/{jinja2,mkdocs{,-exclude,-material}}"[${PYTHON_USEDEP}]" ; } &&
	{ [[ " ${python_need} " != *' sphinx '* ]] || python_has_version \
		dev-python/{recommonmark,sphinx{,-rtd-theme}}"[${PYTHON_USEDEP}]" ; }
}

python_foreach_subdir() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd -- "${subdir}" >/dev/null || die
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
	use rust && rust_pkg_setup
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
	backports_apply_patches
	default

	# hack to suppress tools/refresh-submodules.sh
	# and spurious rebuilds due to missing lowdown sources
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' \
		-e '/\bexternal\/lowdown\b/d' \
		-i external/Makefile || die

	if ! use sqlite ; then
		sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die
	fi

	# only run 'install' command if there are actually files to install
	# and don't unconditionally regenerate Python sources
	sed -e 's/^\t\$(INSTALL_DATA) \(\$([^)]\+)\).*$/ifneq (\1,)\n\0\nendif/' \
		-e '/^default:/s/\bgen\b\|\$(PYTHON_GENERATED)//g' \
		-i Makefile || die

	# don't look for headers or libraries beneath /usr/local
	sed -e '/"Darwin-arm64"/,/^$/d' \
		-e 's/ *\(-[IL]\$(\?\(CPATH\|LIBRARY_PATH\))\? *\)\+/ /g' \
		-i configure Makefile || die

	# we'll strip the binaries ourselves
	sed -e '/^[[:space:]]*strip[[:space:]]*=/d' -i Cargo.toml || die

	# our VERSION="${MyPVR}" confuses is_released_version()
	[[ ${PV} != *([.[:digit:]]) ]] ||
		sed -ne '/^bool is_released_version(void)/{a { return true; }
			p;:x;n;/^}$/d;bx};p' -i common/version.c || die

	# don't require running in a Git worktree
	rm conftest.py || die

	use python && distutils-r1_src_prepare
}

src_configure() {
	local BUNDLED_LIBS="external/build-${CHOST}/libjsmn.a"
	. "${FILESDIR}/compat_vars.bash"
	CLIGHTNING_MAKEOPTS=(
		V=1
		VERSION="${MyPVR}"
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
	edo ./configure \
		CC="$(tc-getCC)" \
		CONFIGURATOR_CC="$(tc-getBUILD_CC)" \
		CWARNFLAGS= \
		CDEBUGFLAGS='-std=gnu11' \
		COPTFLAGS="${CFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		$(use_enable debug{,build}) \
		--disable-compat \
		--disable-valgrind \
		--disable-static \
		--disable-coverage \
		--disable-address-sanitizer \
		--disable-ub-sanitize \
		--disable-fuzzing \
		$(use_enable rust)

	use python && distutils-r1_src_configure
	use rust && cargo_src_configure
}

src_compile() {
	python_need='mako' python_setup
	emake "${CLIGHTNING_MAKEOPTS[@]}" RUST=0

	if use doc ; then
		local python_need='mkdocs'
		python_setup
		"${EPYTHON}" -m mkdocs build || die 'mkdocs failed'
		rm -f site/sitemap.xml.gz  # avoid QA notice
		HTML_DOCS+=( site/. )
		if use python ; then
			python_need='sphinx'
			python_setup
		fi
	fi

	use python && distutils-r1_src_compile

	if use rust ; then
		# these sources weren't generated above because we set RUST=0
		emake "${CLIGHTNING_MAKEOPTS[@]}" cln-{,g}rpc-all
		cargo_src_compile
		use test && cargo_src_test --no-run
	fi
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
	newins "${FILESDIR}/lightningd-24.11.conf" lightningd.conf
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
