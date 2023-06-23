# Copyright 2010-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( {10..15} )

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_SUBDIRS=( contrib/{pyln-proto,pyln-spec/bolt{1,2,4,7},pyln-client} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=poetry

CARGO_OPTIONAL=1
CRATES="
	aho-corasick-1.0.1
	anyhow-1.0.71
	asn1-rs-0.5.2
	asn1-rs-derive-0.4.0
	asn1-rs-impl-0.1.0
	async-stream-0.3.5
	async-stream-impl-0.3.5
	async-trait-0.1.68
	autocfg-1.1.0
	axum-0.6.18
	axum-core-0.3.4
	base64-0.13.1
	base64-0.21.2
	bech32-0.9.1
	bitcoin-0.29.2
	bitcoin_hashes-0.11.0
	bitflags-1.3.2
	bumpalo-3.13.0
	bytes-1.4.0
	cc-1.0.79
	cfg-if-1.0.0
	data-encoding-2.4.0
	der-parser-8.2.0
	displaydoc-0.2.4
	either-1.8.1
	env_logger-0.10.0
	errno-0.3.1
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	fixedbitset-0.4.2
	fnv-1.0.7
	futures-0.3.28
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-executor-0.3.28
	futures-io-0.3.28
	futures-macro-0.3.28
	futures-sink-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	getrandom-0.2.9
	h2-0.3.19
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hex-0.4.3
	http-0.2.9
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.26
	hyper-timeout-0.4.1
	indexmap-1.9.3
	instant-0.1.12
	io-lifetimes-1.0.11
	is-terminal-0.4.7
	itertools-0.10.5
	itoa-1.0.6
	js-sys-0.3.63
	lazy_static-1.4.0
	libc-0.2.144
	linux-raw-sys-0.3.8
	log-0.4.18
	matchit-0.7.0
	memchr-2.5.0
	mime-0.3.17
	minimal-lexical-0.2.1
	mio-0.8.8
	multimap-0.8.3
	nom-7.1.3
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.15.0
	oid-registry-0.6.1
	once_cell-1.17.2
	pem-1.1.1
	percent-encoding-2.2.0
	petgraph-0.6.3
	pin-project-1.1.0
	pin-project-internal-1.1.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.17
	prettyplease-0.1.25
	proc-macro2-1.0.59
	prost-0.11.9
	prost-build-0.11.9
	prost-derive-0.11.9
	prost-types-0.11.9
	quote-1.0.28
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rcgen-0.10.0
	redox_syscall-0.3.5
	regex-1.8.3
	regex-syntax-0.7.2
	ring-0.16.20
	rusticata-macros-4.1.0
	rustix-0.37.19
	rustls-0.20.8
	rustls-pemfile-1.0.2
	rustversion-1.0.12
	ryu-1.0.13
	sct-0.7.0
	secp256k1-0.24.3
	secp256k1-sys-0.6.1
	serde-1.0.163
	serde_derive-1.0.163
	serde_json-1.0.96
	slab-0.4.8
	socket2-0.4.9
	spin-0.5.2
	syn-1.0.109
	syn-2.0.18
	sync_wrapper-0.1.2
	synstructure-0.12.6
	tempfile-3.5.0
	termcolor-1.2.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	time-0.3.21
	time-core-0.1.1
	time-macros-0.2.9
	tokio-1.28.2
	tokio-io-timeout-1.2.0
	tokio-macros-2.1.0
	tokio-rustls-0.23.4
	tokio-stream-0.1.14
	tokio-util-0.7.8
	tonic-0.8.3
	tonic-build-0.8.4
	tower-0.4.13
	tower-layer-0.3.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.24
	tracing-core-0.1.31
	tracing-futures-0.2.5
	try-lock-0.2.4
	unicode-ident-1.0.9
	unicode-xid-0.2.4
	untrusted-0.7.1
	want-0.3.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.86
	wasm-bindgen-backend-0.2.86
	wasm-bindgen-macro-0.2.86
	wasm-bindgen-macro-support-0.2.86
	wasm-bindgen-shared-0.2.86
	web-sys-0.3.63
	webpki-0.22.0
	which-4.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	x509-parser-0.14.0
	yasna-0.5.2
"

inherit bash-completion-r1 cargo distutils-r1 git-r3 postgres toolchain-funcs

MyPN=lightning
EGIT_REPO_URI=( "https://github.com/ElementsProject/${MyPN}.git" )
EGIT_SUBMODULES=( '-*' external/gheap )

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="${EGIT_REPO_URI[*]%.git}"
SRC_URI="https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	rust? ( $(cargo_crate_uris) )"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
IUSE="developer doc +man +mkdocs postgres python rust sqlite test"
RESTRICT="!test? ( test )"

CDEPEND="
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-0.9.0:=[elements]
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.13:=
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.29.0:= )
"
PYTHON_DEPEND="
	>=dev-python/base58-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/bitstring-3[${PYTHON_USEDEP}]
	>=dev-python/coincurve-18[${PYTHON_USEDEP}]
	>=dev-python/cryptography-41[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1[${PYTHON_USEDEP}]
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
		rust? (
			>=dev-python/grpcio-tools-1[${PYTHON_USEDEP}]
			>=dev-python/protobuf-python-4.21.12[${PYTHON_USEDEP}]
		)
	')
	doc? (
		$(python_gen_any_dep '
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
		mkdocs? ( $(python_gen_any_dep '
			>=dev-python/jinja-3.1.0[${PYTHON_USEDEP}]
			dev-python/mkdocs[${PYTHON_USEDEP}]
			dev-python/mkdocs-exclude[${PYTHON_USEDEP}]
			dev-python/mkdocs-material[${PYTHON_USEDEP}]
		') )
	)
	net-misc/curl[ssl]
	python? (
		${DISTUTILS_DEPS}
		>=dev-python/installer-0.4.0_p20220124[${PYTHON_USEDEP}]
		>=dev-python/poetry-core-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
		test? (
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			${PYTHON_DEPEND}
		)
	)
	rust? (
		${RUST_DEPEND}
		>=dev-libs/protobuf-4
	)
	sys-devel/gettext
	virtual/pkgconfig
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"
# FIXME: bundled deps: ccan

PATCHES=(
)

DOCS=( CHANGELOG.md README.md doc/{BACKUP,FAQ,GOSSIP_STORE,PLUGINS,TOR}.md )

python_check_deps() {
	{ [[ " ${python_need} " != *' mako '* ]] || {
		python_has_version "dev-python/mako[${PYTHON_USEDEP}]" &&
		{ ! use rust || python_has_version dev-python/{grpcio-tools,protobuf-python}"[${PYTHON_USEDEP}]" ; } ; } ; } &&
	{ [[ " ${python_need} " != *' mkdocs '* ]] || python_has_version \
		dev-python/{jinja,mkdocs{,-exclude,-material}}"[${PYTHON_USEDEP}]" ; } &&
	{ [[ " ${python_need} " != *' sphinx '* ]] || python_has_version \
		dev-python/{recommonmark,sphinx{,-rtd-theme}}"[${PYTHON_USEDEP}]" ; }
}

python_foreach_subdir() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd "${subdir}" >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
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
	git-r3_src_unpack
	find "${S}/external" -depth -mindepth 1 -maxdepth 1 -type d ! -name 'gheap' -delete || die
	cd "${S}/external" || die
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,} || die

	if use rust ; then
		set ${CRATES}
		local A="${*/%/.crate}"
		cargo_src_unpack
	fi
}

src_prepare() {
	default

	# hack to suppress tools/refresh-submodules.sh
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' -i external/Makefile || die

	if ! use sqlite ; then
		sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die
	fi

	# delete all pre-generated files; they're often stale anyway
	rm -f cln-grpc/{src/{convert,server}.rs,proto/node.proto} \
		cln-rpc/src/model.rs \
		contrib/pyln-testing/pyln/testing/{node_pb2{,_grpc},primitives_pb2}.py \
		doc/*.[0-9] || die

	# only run 'install' command if there are actually files to install
	sed -e 's/^\t\$(INSTALL_DATA) \(\$([^)]\+)\).*$/ifneq (\1,)\n\0\nendif/' \
		-i Makefile || die

	# don't look for headers or libraries beneath /usr/local
	sed -e '/"Darwin-arm64"/,/^$/d' \
		-e 's/ *\(-[IL]\$(\?\(CPATH\|LIBRARY_PATH\))\? *\)\+/ /g' \
		-i configure Makefile || die

	# we'll strip the binaries ourselves
	sed -e '/^[[:space:]]*strip[[:space:]]*=/d' -i Cargo.toml || die

	use python && distutils-r1_src_prepare
}

src_configure() {
	local BUNDLED_LIBS="external/build-${CHOST}/libjsmn.a"
	. "${FILESDIR}/compat_vars.bash"
	CLIGHTNING_MAKEOPTS=(
		V=1
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
		if use mkdocs ; then
			local python_need='mkdocs'
			python_setup
			"${EPYTHON}" -m mkdocs build || die 'mkdocs failed'
			rm -f site/sitemap.xml.gz  # avoid QA notice
			HTML_DOCS+=( site/. )
			if use python ; then
				python_need='sphinx'
				python_setup
			fi
		else
			local python_need='sphinx'
			python_setup
			build_sphinx doc
		fi
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
	newins "${FILESDIR}/lightningd-23.02.conf" lightningd.conf
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
