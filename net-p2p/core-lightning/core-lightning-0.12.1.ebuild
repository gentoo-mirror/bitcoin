# Copyright 2010-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 1{0..4} )

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_SUBDIRS=( contrib/{pyln-proto,pyln-spec/bolt{1,2,4,7},pyln-client} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=poetry

CARGO_OPTIONAL=1
CRATES="
	aho-corasick-0.7.18
	anyhow-1.0.57
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.53
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	bumpalo-3.9.1
	bytes-1.1.0
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.19
	data-encoding-2.3.2
	der-oid-macro-0.5.0
	der-parser-6.0.1
	either-1.6.1
	env_logger-0.9.0
	fastrand-1.7.0
	fixedbitset-0.2.0
	fnv-1.0.7
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	getrandom-0.2.6
	h2-0.3.13
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	hex-0.4.3
	http-0.2.7
	http-body-0.4.4
	httparse-1.7.1
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.18
	hyper-timeout-0.4.1
	indexmap-1.8.1
	instant-0.1.12
	itertools-0.10.3
	itoa-1.0.1
	js-sys-0.3.57
	lazy_static-1.4.0
	libc-0.2.125
	log-0.4.17
	memchr-2.5.0
	minimal-lexical-0.2.1
	mio-0.8.3
	multimap-0.8.3
	nom-7.1.1
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.13.1
	oid-registry-0.2.0
	once_cell-1.10.0
	pem-1.0.2
	percent-encoding-2.1.0
	petgraph-0.5.1
	pin-project-1.0.10
	pin-project-internal-1.0.10
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.16
	proc-macro2-1.0.38
	prost-0.8.0
	prost-build-0.8.0
	prost-derive-0.8.0
	prost-types-0.8.0
	quote-1.0.18
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rcgen-0.8.14
	redox_syscall-0.2.13
	regex-1.5.5
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ring-0.16.20
	rusticata-macros-4.1.0
	rustls-0.19.1
	ryu-1.0.9
	sct-0.6.1
	serde-1.0.137
	serde_derive-1.0.137
	serde_json-1.0.81
	slab-0.4.6
	socket2-0.4.4
	spin-0.5.2
	syn-1.0.94
	tempfile-3.3.0
	termcolor-1.1.3
	thiserror-1.0.31
	thiserror-impl-1.0.31
	tokio-1.18.2
	tokio-io-timeout-1.2.0
	tokio-macros-1.7.0
	tokio-rustls-0.22.0
	tokio-stream-0.1.8
	tokio-util-0.6.9
	tokio-util-0.7.1
	tonic-0.5.2
	tonic-build-0.5.2
	tower-0.4.12
	tower-layer-0.3.1
	tower-service-0.3.1
	tracing-0.1.34
	tracing-attributes-0.1.21
	tracing-core-0.1.26
	tracing-futures-0.2.5
	try-lock-0.2.3
	unicode-segmentation-1.9.0
	unicode-xid-0.2.3
	untrusted-0.7.1
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	webpki-0.21.4
	which-4.2.5
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	x509-parser-0.12.0
	yasna-0.4.0
"

inherit bash-completion-r1 cargo distutils-r1 postgres toolchain-funcs

MyPN=lightning
MyPV=${PV/[-_]rc/rc}
PATCH_HASHES=(
	2ac775f9f4343338a0782a07d446920582f576b8	# lightningd: fix crash with -O3 -flto.
	6a48ed9e826efed1ea53b18a8308f97c2d5bbe34	# gossmap: fail to get capacity of locally-added chans (don't crash!).
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
IUSE="developer doc experimental postgres python +recent-libsecp256k1 rust sqlite test"
RESTRICT="!test? ( test )"

CDEPEND="
	>=dev-libs/gmp-6.1.2:=
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-0.8.5:=[elements]
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.12:=
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.26.0:= )
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
	doc? ( app-text/lowdown )
	$(python_gen_any_dep '
		>=dev-python/mako-1.1.6[${PYTHON_USEDEP}]
	')
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
DOCS=( CHANGELOG.md doc/{BACKUP,FAQ,PLUGINS,TOR}.md )

python_check_deps() {
	python_has_version "dev-python/mako[${PYTHON_USEDEP}]"
}

do_python_phase() {
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
	rm -r */
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,} || die
	unpack gheap-67fc83b.tar.gz
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

	python_setup
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

	use python && do_python_phase distutils-r1_src_configure
	use rust && cargo_src_configure
}

src_compile() {
	python_setup
	emake "${CLIGHTNING_MAKEOPTS[@]}" \
		all-programs \
		$(usex test 'all-test-programs' '') \
		$(usex doc doc-all '') \
		default-targets

	use python && do_python_phase distutils-r1_src_compile
}

python_compile() {
	# distutils-r1_python_compile() isn't designed to be called multiple
	# times for the same EPYTHON, so do some cleanup between invocations
	rm -rf -- "${BUILD_DIR}/install${EPREFIX}/usr/bin" || die

	distutils-r1_python_compile
}

src_test() {
	# disable flaky bitcoin/test/run-secret_eq_consttime
	SLOW_MACHINE=1 \
	emake "${CLIGHTNING_MAKEOPTS[@]}" check-units

	use python && do_python_phase distutils-r1_src_test
}

python_test() {
	epytest
}

python_install_all() {
	use doc &&
	do_python_phase python_install_subdir_docs
}

python_install_subdir_docs() {
	shopt -s nullglob
	local -a docs=( README* )
	shopt -u nullglob
	if (( ${#docs[@]} )) ; then
		docinto "${PWD##*/}"
		dodoc "${docs[@]}"
	fi
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" $(usex doc install 'install-program installdirs')

	einstalldocs
	if ! use doc ; then
		# Normally README.md gets installed by `make install`, but not if we're skipping doc installation
		dodoc README.md
	fi

	insinto /etc/lightning
	newins "${FILESDIR}/lightningd-0.12.0.conf" lightningd.conf
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
	has_version "<${CATEGORY}/${PN}-0.8" && had_pre_0_8_0=1

	if [[ -e ${EROOT%/}/etc/lightning/config && ! -e ${EROOT%/}/etc/lightning/lightningd.conf ]] ; then
		elog "Moving your /etc/lightning/config to /etc/lightning/lightningd.conf"
		mv --no-clobber -- "${EROOT%/}/etc/lightning/"{config,lightningd.conf}
	fi

	[[ -e ${EROOT%/}/usr/bin/hsmtool ]] && had_hsmtool=1
}

pkg_postinst() {
	elog 'To use lightning-cli with the /etc/init.d/lightningd service:'
	elog " - Add your user(s) to the 'lightning' group."
	elog ' - Symlink ~/.lightning to /var/lib/lightning.'

	# warn when upgrading from pre-0.8.0
	if [[ ${had_pre_0_8_0} || -e ${EROOT%/}/var/lib/lightning/hsm_secret ]] ; then
		ewarn 'This version of Core Lightning maintains its data files in network-specific'
		ewarn 'subdirectories of its base directory. Your existing data files will be'
		ewarn 'migrated automatically upon first startup of the new version.'
	fi

	if [[ ${had_hsmtool} ]] ; then
		ewarn "Upstream has renamed the ${PORTAGE_COLOR_HILITE-${HILITE}}hsmtool${PORTAGE_COLOR_NORMAL-${NORMAL}} executable to ${PORTAGE_COLOR_HILITE-${HILITE}}lightning-hsmtool${PORTAGE_COLOR_NORMAL-${NORMAL}}."
		ewarn 'Please adjust your scripts and workflows accordingly.'
	fi
}
