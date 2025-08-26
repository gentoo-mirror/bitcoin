# Copyright 2010-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( {11..17} )

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_SUBDIRS=( contrib/{pyln-proto,pyln-spec/bolt{1,2,4,7},pyln-client} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=hatchling

RUST_MIN_VER="1.75.0"
CARGO_OPTIONAL=1
CRATES="
	addr2line-0.24.2
	adler2-2.0.1
	aho-corasick-1.1.3
	anyhow-1.0.98
	arbitrary-1.4.1
	arc-swap-1.7.1
	arrayvec-0.7.6
	asn1-rs-0.6.2
	asn1-rs-derive-0.5.1
	asn1-rs-impl-0.2.0
	async-stream-0.3.6
	async-stream-impl-0.3.6
	async-trait-0.1.88
	atomic-waker-1.1.2
	autocfg-1.5.0
	axum-0.6.20
	axum-0.8.4
	axum-core-0.3.4
	axum-core-0.5.2
	axum-server-0.6.0
	backtrace-0.3.74
	base58ck-0.1.0
	base64-0.21.7
	base64-0.22.1
	bech32-0.10.0-beta
	bech32-0.11.0
	bitcoin-0.31.2
	bitcoin-0.32.6
	bitcoin-internals-0.2.0
	bitcoin-internals-0.3.0
	bitcoin-io-0.1.3
	bitcoin-units-0.1.2
	bitcoin_hashes-0.13.0
	bitcoin_hashes-0.14.0
	bitflags-1.3.2
	bitflags-2.9.1
	block-buffer-0.10.4
	bumpalo-3.19.0
	byteorder-1.5.0
	bytes-1.10.1
	cc-1.2.30
	cfg-if-1.0.1
	core-foundation-0.9.4
	core-foundation-sys-0.8.7
	cpufeatures-0.2.17
	crc32fast-1.5.0
	crypto-common-0.1.6
	data-encoding-2.9.0
	der-parser-9.0.0
	deranged-0.4.0
	derive_arbitrary-1.4.1
	digest-0.10.7
	displaydoc-0.2.5
	dnssec-prover-0.6.7
	either-1.15.0
	encoding_rs-0.8.35
	engineioxide-0.15.2
	env_logger-0.10.2
	equivalent-1.0.2
	errno-0.3.13
	fastrand-2.3.0
	fixedbitset-0.4.2
	flate2-1.1.2
	fnv-1.0.7
	form_urlencoded-1.2.1
	futures-0.3.31
	futures-channel-0.3.31
	futures-core-0.3.31
	futures-executor-0.3.31
	futures-io-0.3.31
	futures-macro-0.3.31
	futures-sink-0.3.31
	futures-task-0.3.31
	futures-util-0.3.31
	generic-array-0.14.7
	getrandom-0.2.16
	getrandom-0.3.3
	gimli-0.31.1
	h2-0.3.27
	h2-0.4.11
	hashbrown-0.12.3
	hashbrown-0.13.2
	hashbrown-0.15.4
	heck-0.5.0
	hermit-abi-0.5.2
	hex-0.4.3
	hex-conservative-0.1.2
	hex-conservative-0.2.1
	hex_lit-0.1.1
	http-0.2.12
	http-1.3.1
	http-body-0.4.6
	http-body-1.0.1
	http-body-util-0.1.3
	httparse-1.10.1
	httpdate-1.0.3
	humantime-2.2.0
	hyper-0.14.32
	hyper-1.6.0
	hyper-rustls-0.24.2
	hyper-timeout-0.4.1
	hyper-util-0.1.16
	icu_collections-1.5.0
	icu_locid-1.5.0
	icu_locid_transform-1.5.0
	icu_locid_transform_data-1.5.1
	icu_normalizer-1.5.0
	icu_normalizer_data-1.5.1
	icu_properties-1.5.1
	icu_properties_data-1.5.1
	icu_provider-1.5.0
	icu_provider_macros-1.5.0
	idna-1.0.3
	idna_adapter-1.2.0
	indexmap-1.9.3
	indexmap-2.10.0
	io-uring-0.7.9
	ipnet-2.11.0
	is-terminal-0.4.16
	itertools-0.12.1
	itoa-1.0.15
	js-sys-0.3.77
	lazy_static-1.5.0
	libc-0.2.174
	libm-0.2.15
	libyml-0.0.5
	libz-rs-sys-0.5.1
	lightning-0.1.5
	lightning-invoice-0.33.2
	lightning-types-0.2.0
	linux-raw-sys-0.9.4
	litemap-0.7.4
	lock_api-0.4.13
	log-0.4.27
	log-panics-2.1.0
	matchers-0.1.0
	matchit-0.7.3
	matchit-0.8.4
	memchr-2.7.5
	mime-0.3.17
	mime_guess-2.0.5
	minimal-lexical-0.2.1
	miniz_oxide-0.8.9
	mio-1.0.4
	multimap-0.10.1
	nom-7.1.3
	nu-ansi-term-0.46.0
	num-bigint-0.4.6
	num-conv-0.1.0
	num-integer-0.1.46
	num-traits-0.2.19
	object-0.36.7
	oid-registry-0.7.1
	once_cell-1.21.3
	overload-0.1.1
	parking_lot-0.12.4
	parking_lot_core-0.9.11
	pem-3.0.5
	percent-encoding-2.3.1
	petgraph-0.6.5
	pin-project-1.1.10
	pin-project-internal-1.1.10
	pin-project-lite-0.2.16
	pin-utils-0.1.0
	possiblyrandom-0.2.0
	powerfmt-0.2.0
	ppv-lite86-0.2.21
	prettyplease-0.2.36
	proc-macro2-1.0.95
	prost-0.12.6
	prost-build-0.12.6
	prost-derive-0.12.6
	prost-types-0.12.6
	quick-xml-0.37.5
	quote-1.0.40
	r-efi-5.3.0
	rand-0.8.5
	rand-0.9.2
	rand_chacha-0.3.1
	rand_chacha-0.9.0
	rand_core-0.6.4
	rand_core-0.9.3
	rcgen-0.13.2
	redox_syscall-0.5.15
	regex-1.11.1
	regex-automata-0.1.10
	regex-automata-0.4.9
	regex-syntax-0.6.29
	regex-syntax-0.8.5
	reqwest-0.11.27
	ring-0.17.14
	roxmltree-0.20.0
	roxmltree_to_serde-0.6.2
	rust-embed-8.7.2
	rust-embed-impl-8.7.2
	rust-embed-utils-8.7.2
	rustc-demangle-0.1.25
	rusticata-macros-4.1.0
	rustix-1.0.8
	rustls-0.21.12
	rustls-0.22.4
	rustls-0.23.29
	rustls-pemfile-1.0.4
	rustls-pemfile-2.2.0
	rustls-pki-types-1.12.0
	rustls-webpki-0.101.7
	rustls-webpki-0.102.8
	rustls-webpki-0.103.4
	rustversion-1.0.21
	ryu-1.0.20
	same-file-1.0.6
	scopeguard-1.2.0
	sct-0.7.1
	secp256k1-0.28.2
	secp256k1-0.29.1
	secp256k1-sys-0.9.2
	secp256k1-sys-0.10.1
	serde-1.0.219
	serde_derive-1.0.219
	serde_json-1.0.141
	serde_path_to_error-0.1.17
	serde_qs-0.15.0
	serde_urlencoded-0.7.1
	serde_yml-0.0.12
	sha1-0.10.6
	sha2-0.10.9
	sharded-slab-0.1.7
	shlex-1.3.0
	signal-hook-registry-1.4.5
	simd-adler32-0.3.7
	slab-0.4.10
	smallvec-1.15.1
	socket2-0.5.10
	socketioxide-0.15.2
	socketioxide-core-0.15.2
	socketioxide-parser-common-0.15.2
	stable_deref_trait-1.2.0
	subtle-2.6.1
	syn-2.0.104
	sync_wrapper-0.1.2
	sync_wrapper-1.0.2
	synstructure-0.13.2
	system-configuration-0.5.1
	system-configuration-sys-0.5.0
	tempfile-3.20.0
	termcolor-1.4.1
	thiserror-1.0.69
	thiserror-2.0.12
	thiserror-impl-1.0.69
	thiserror-impl-2.0.12
	thread_local-1.1.9
	time-0.3.41
	time-core-0.1.4
	time-macros-0.2.22
	tinystr-0.7.6
	tokio-1.46.1
	tokio-io-timeout-1.2.1
	tokio-macros-2.5.0
	tokio-rustls-0.24.1
	tokio-rustls-0.25.0
	tokio-rustls-0.26.2
	tokio-socks-0.5.2
	tokio-stream-0.1.17
	tokio-test-0.4.4
	tokio-tungstenite-0.24.0
	tokio-tungstenite-0.26.2
	tokio-util-0.7.15
	tonic-0.11.0
	tonic-build-0.11.0
	tower-0.4.13
	tower-0.5.2
	tower-http-0.6.6
	tower-layer-0.3.3
	tower-service-0.3.3
	tracing-0.1.41
	tracing-attributes-0.1.30
	tracing-core-0.1.34
	tracing-log-0.2.0
	tracing-subscriber-0.3.19
	try-lock-0.2.5
	tungstenite-0.24.0
	tungstenite-0.26.2
	typenum-1.18.0
	unicase-2.8.1
	unicode-ident-1.0.18
	untrusted-0.9.0
	url-2.5.4
	utf-8-0.7.6
	utf16_iter-1.0.5
	utf8_iter-1.0.4
	utoipa-5.4.0
	utoipa-gen-5.4.0
	utoipa-swagger-ui-9.0.2
	utoipa-swagger-ui-vendored-0.1.2
	valuable-0.1.1
	version_check-0.9.5
	walkdir-2.5.0
	want-0.3.1
	wasi-0.11.1+wasi-snapshot-preview1
	wasi-0.14.2+wasi-0.2.4
	wasm-bindgen-0.2.100
	wasm-bindgen-backend-0.2.100
	wasm-bindgen-futures-0.4.50
	wasm-bindgen-macro-0.2.100
	wasm-bindgen-macro-support-0.2.100
	wasm-bindgen-shared-0.2.100
	web-sys-0.3.77
	webpki-roots-0.25.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.9
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-sys-0.52.0
	windows-sys-0.59.0
	windows-sys-0.60.2
	windows-targets-0.48.5
	windows-targets-0.52.6
	windows-targets-0.53.2
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_gnullvm-0.52.6
	windows_aarch64_gnullvm-0.53.0
	windows_aarch64_msvc-0.48.5
	windows_aarch64_msvc-0.52.6
	windows_aarch64_msvc-0.53.0
	windows_i686_gnu-0.48.5
	windows_i686_gnu-0.52.6
	windows_i686_gnu-0.53.0
	windows_i686_gnullvm-0.52.6
	windows_i686_gnullvm-0.53.0
	windows_i686_msvc-0.48.5
	windows_i686_msvc-0.52.6
	windows_i686_msvc-0.53.0
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnu-0.52.6
	windows_x86_64_gnu-0.53.0
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_gnullvm-0.52.6
	windows_x86_64_gnullvm-0.53.0
	windows_x86_64_msvc-0.48.5
	windows_x86_64_msvc-0.52.6
	windows_x86_64_msvc-0.53.0
	winreg-0.50.0
	wit-bindgen-rt-0.39.0
	write16-1.0.0
	writeable-0.5.5
	x509-parser-0.16.0
	yasna-0.5.2
	yoke-0.7.5
	yoke-derive-0.7.5
	zerocopy-0.8.26
	zerocopy-derive-0.8.26
	zerofrom-0.1.5
	zerofrom-derive-0.1.6
	zeroize-1.8.1
	zerovec-0.10.4
	zerovec-derive-0.10.3
	zip-3.0.0
	zlib-rs-0.5.1
	zopfli-0.8.2
"
declare -A GIT_CRATES=(
	[bitcoin-payment-instructions]="https://github.com/rust-bitcoin/bitcoin-payment-instructions;d071ce27734ca13be2471f81abf8699d902c3a10"
)

inherit backports bash-completion-r1 cargo depends distutils-r1 edo git-r3 postgres toolchain-funcs

MyPN=lightning
EGIT_REPO_URI=( "https://github.com/ElementsProject/${MyPN}.git" )
EGIT_SUBMODULES=( '-*' external/gheap )

BACKPORTS=(
	51b6be302976e7302a8760b64d4beb716d87a0ad	# pyln-client: don't leak dirfd after connecting Unix socket
	af5caec88bb3549ec6ecfb9edf1b632cd81aa301	# pyln-testing: close 'config.vars' after reading
	d045e4acf0ee4f725c73c206a0fa17f1f4419b95	# pyln-testing: close log files when tearing down node_factory
	b29efab74a96c969a39af03d6b60827578546cde	# pyln-testing: don't leak file descriptor in GossipStore
	24c9abb92c019d6178fa73edf8affd564ed8e52e	# tests: do not leak file descriptors
	93ac98db224a05825d8d848390f919ecb7dbf70d	# tests: skip certain tests if RUST is not enabled
	324302d27b2d818c65c89267104b8719bdf6b489	# tests: work around socket path name too long on Linux
	eed6aa8059b56cf3d0cece7641f82fdeae8e24da	# pyln-testing: pass timeout to BitcoinProxy
	c27dd25d2e181ff166b1fd61461a6c908a636930	# test_coinmoves.py: use pytest.approx for change amount
	cdd75f5742b1784761f019941a8c0e6eb08a55de	# test_renepay.py: use test-specific temp dir, not /tmp
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="${EGIT_REPO_URI[*]%.git}"
BACKPORTS_BASE_URI="${EGIT_REPO_URI[0]%.git}/commit/"
SRC_URI="https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	rust? ( ${CARGO_CRATE_URIS} )
	$(backports_patch_uris)
"

LICENSE="MIT BSD-2 CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
IUSE="debug doc +man postgres python rust sqlite test test-full"
RESTRICT="!test? ( test )"

CDEPEND="
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-1.4.0:0/6[elements]
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.13:=
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.29.0:= )
"
PYTHON_DEPEND='
	>=dev-python/base58-2.1.1[${PYTHON_USEDEP}]
	|| (
		>=dev-python/bitstring-4.2.2[${PYTHON_USEDEP}]
		<dev-python/bitstring-4.2[${PYTHON_USEDEP}]
	)
	!<dev-python/bitstring-4.1
	>=dev-python/coincurve-20[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42[${PYTHON_USEDEP}]
	>=dev-python/pysocks-1[${PYTHON_USEDEP}]
'
MAKO_DEPEND='
	>=dev-python/mako-1.1.6[${PYTHON_USEDEP}]
'
MKDOCS_DEPEND='
	>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
	dev-python/mkdocs[${PYTHON_USEDEP}]
	dev-python/mkdocs-exclude[${PYTHON_USEDEP}]
	dev-python/mkdocs-material[${PYTHON_USEDEP}]
'
SPHINX_DEPEND='
	dev-python/recommonmark[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
'
TEST_FULL_DEPEND="${PYTHON_DEPEND}"'
	>=dev-python/cheroot-8[${PYTHON_USEDEP}]
	>=dev-python/ephemeral-port-reserve-1.1.4[${PYTHON_USEDEP}]
	>=dev-python/flask-2[${PYTHON_USEDEP}]
	>=dev-python/grpcio-1[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-5.29.4[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.9:2[${PYTHON_USEDEP}]
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
	dev-python/pytest-xdist[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-1.2.3[${PYTHON_USEDEP}]
'
RDEPEND="${CDEPEND}
	acct-group/lightning
	acct-user/lightning
	python? ( ${PYTHON_DEPEND//'${PYTHON_USEDEP}'/${PYTHON_USEDEP}} )
"
DEPEND="${CDEPEND}
"
BDEPEND="
	acct-group/lightning
	acct-user/lightning
	>=app-misc/jq-1.6
	man? ( app-text/lowdown )
	$(python_gen_any_dep "${MAKO_DEPEND}")
	doc? (
		$(python_gen_any_dep "${MKDOCS_DEPEND}")
		python? ( $(python_gen_any_dep "${SPHINX_DEPEND}") )
	)
	net-misc/curl[ssl]
	python? (
		${DISTUTILS_DEPS}
		test? (
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			${PYTHON_DEPEND//'${PYTHON_USEDEP}'/${PYTHON_USEDEP}}
		)
	)
	rust? (
		${RUST_DEPEND}
		>=dev-libs/protobuf-4[protoc(+)]
	)
	sys-devel/gettext
	virtual/pkgconfig
	test-full? (
		net-p2p/bitcoin-core[cli,daemon,sqlite(+),wallet(+)]
		$(PYTHON_REQ_USE='sqlite' python_gen_any_dep "${TEST_FULL_DEPEND}")
	)
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE/||/^^} )
	python? ( ${PYTHON_REQUIRED_USE} )
	test-full? ( test )
"
# FIXME: bundled deps: ccan

PATCHES=(
	"${FILESDIR}/python-bitcointx.patch"
)

DOCS=( CHANGELOG.md README.md SECURITY.md )

EPYTEST_PLUGINS=( )
EPYTEST_DESELECT=(
	# test depends on machine being "reasonably fast," which we can't guarantee
	test_connection.py::test_no_delay

	# these tests require Internet access, which we don't provide
	test_cln_rs.py::test_bip353
	test_gossip.py::test_announce_{dns_suppressed,and_connect_via_dns}
)
EPYTEST_IGNORE=(
	# we don't depend on any of the installers that Reckless wants
	tests/test_reckless.py
)

efmt() {
	: ${1:?} ; local l ; while read -r l ; do "${!#}" "${l}" ; done < <(fmt "${@:1:$#-1}")
}

re_match() {
	local -n var="${1:?}" ; local regex="${2:?}" ; shift 2
	var=( )
	local each ; for each ; do
		[[ "${each}" =~ ${regex} ]] && var+=( "${each}" )
	done
	(( "${#var[@]}" ))
}

python_check_deps() {
	{ [[ " ${python_need} " != *' mako '* ]] || has_depends -p \
		${MAKO_DEPEND//'${PYTHON_USEDEP}'/"${PYTHON_USEDEP}"} ; } &&
	{ [[ " ${python_need} " != *' mkdocs '* ]] || has_depends -p \
		${MKDOCS_DEPEND//'${PYTHON_USEDEP}'/"${PYTHON_USEDEP}"} ; } &&
	{ [[ " ${python_need} " != *' sphinx '* ]] || has_depends -p \
		${SPHINX_DEPEND//'${PYTHON_USEDEP}'/"${PYTHON_USEDEP}"} ; } &&
	{ [[ " ${python_need} " != *' test-full '* ]] || has_depends -p \
		${TEST_FULL_DEPEND//'${PYTHON_USEDEP}'/"${PYTHON_USEDEP}"} ; }
}

python_foreach_subdir() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd -- "${subdir}" >/dev/null || die
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
	use rust && rust_pkg_setup
}

src_unpack() {
	local -a git_crates
	re_match git_crates '\.gh\.tar\.gz$' ${A} && unpack "${git_crates[@]}"
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
	backports_apply_patches
	default

	# hack to suppress tools/refresh-submodules.sh
	# and spurious rebuilds due to missing lowdown sources
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' \
		-e '/\bexternal\/lowdown\b/d' \
		-i external/Makefile || die

	if ! use sqlite ; then
		sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die
		# https://github.com/ElementsProject/lightning/issues/8473
		rm plugins/bkpr/test/run-recorder.c || die
	fi

	# delete all pre-generated files; they're often stale anyway
# 	rm -f cln-grpc/{src/{convert,server}.rs,proto/node.proto} \
# 		cln-rpc/src/model.rs \
# 		doc/*.[0-9] || die
	# we can't delete contrib/pyln-grpc-proto/pyln/grpc/{node_pb2{,_grpc},primitives_pb2}.py
	# because regenerating them requires dev-python/grpcio-tools, which is a huge PITA

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

	# save our SSDs! ("cp" -> "cp -l")
	local shopt_pop=$(shopt -p globstar)
	shopt -s globstar
	sed -e 's/\bcp\b/cp -l/g' -i -- **/Makefile || die
	${shopt_pop}

	use python && distutils-r1_src_prepare
}

src_configure() {
	local BUNDLED_LIBS="external/build-${CHOST}/libjsmn.a"
	. "${FILESDIR}/compat_vars.bash"
	CLIGHTNING_MAKEOPTS=(
		V=1
		DISTRO=Gentoo
		DEFAULT_TARGETS=
		COVERAGE=
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
	use test-full || CLIGHTNING_MAKEOPTS+=(
		DEVTOOLS=
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
		CLNREST_EXAMPLES=
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
	emake "${CLIGHTNING_MAKEOPTS[@]}"

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
		# these sources weren't generated above because we set DEFAULT_TARGETS=
		emake "${CLIGHTNING_MAKEOPTS[@]}" cln-{,g}rpc-all
		cargo_src_compile
		use test && cargo_src_test --no-run
		# link all the Cargo-built plugins into the plugins directory
		emake "${CLIGHTNING_MAKEOPTS[@]}" $(sed -ne 's/^PLUGINS += \(.*\)$/\1/p' plugins/Makefile)
	fi
}

python_compile() {
	python_foreach_subdir python_compile_subdir
}

python_compile_subdir() {
	distutils-r1_python_compile
	rm -f -- "${BUILD_DIR}/install$(python_get_sitedir)/pyln"{,/spec}/{__init__.py,__pycache__/__init__.*.pyc} || die
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
	local -x SLOW_MACHINE=1
	emake "${CLIGHTNING_MAKEOPTS[@]}" check-units

	use python && distutils-r1_src_test
	use rust && cargo_src_test

	if use test-full ; then
		python_need='test-full'
		python_setup
		local EPYTEST_XDIST=1
		# double up, as these tests are surprisingly ineffective at saturating the CPU
		[[ -v EPYTEST_JOBS ]] || local -i EPYTEST_JOBS="$(makeopts_jobs)*2"
		local -a pythonpath
		mapfile -t pythonpath <<<"$(readlink -e -- "${PYTHON_SUBDIRS[@]}" contrib/pyln-{grpc-proto,testing})"
		local -x PYTHONPATH="$(IFS=: ; printf '%s' "${pythonpath[*]}")" RUST_PROFILE=release
		TEST_DIR="${T}" epytest tests
	fi
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
	newins "${FILESDIR}/lightningd-25.09.conf" lightningd.conf
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
	efmt -su elog <<-EOF
		To use lightning-cli with the /etc/init.d/lightningd service:
		 - Add your user(s) to the 'lightning' group.
		 - Symlink ~/.lightning to /var/lib/lightning.
	EOF
}
