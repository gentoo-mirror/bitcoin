# Copyright 2010-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85"
CRATES="
	addr2line-0.24.2
	adler2-2.0.1
	aho-corasick-1.1.3
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anyhow-1.0.99
	arrayvec-0.7.6
	autocfg-1.5.0
	backtrace-0.3.75
	bech32-0.10.0-beta
	bitcoin-0.31.2
	bitcoin-internals-0.2.0
	bitcoin_hashes-0.13.0
	bitflags-2.9.4
	bumpalo-3.19.0
	bytecount-0.6.9
	bytes-1.10.1
	cc-1.2.35
	cfg-if-1.0.3
	chrono-0.4.41
	core-foundation-sys-0.8.7
	find-msvc-tools-0.1.0
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
	getrandom-0.3.3
	gimli-0.31.1
	heck-0.5.0
	hex-0.4.3
	hex-conservative-0.1.2
	hex_lit-0.1.1
	iana-time-zone-0.1.63
	iana-time-zone-haiku-0.1.2
	io-uring-0.7.10
	itoa-1.0.15
	js-sys-0.3.77
	lazy_static-1.5.0
	libc-0.2.175
	libmimalloc-sys-0.1.44
	lock_api-0.4.13
	log-0.4.28
	log-panics-2.1.0
	matchers-0.2.0
	memchr-2.7.5
	mimalloc-0.1.48
	miniz_oxide-0.8.9
	mio-1.0.4
	nu-ansi-term-0.50.1
	num-format-0.4.4
	num-traits-0.2.19
	object-0.36.7
	once_cell-1.21.3
	papergrid-0.17.0
	parking_lot-0.12.4
	parking_lot_core-0.9.11
	pin-project-lite-0.2.16
	pin-utils-0.1.0
	ppv-lite86-0.2.21
	proc-macro-error-attr2-2.0.0
	proc-macro-error2-2.0.1
	proc-macro2-1.0.101
	quote-1.0.40
	r-efi-5.3.0
	rand-0.9.2
	rand_chacha-0.9.0
	rand_core-0.9.3
	redox_syscall-0.5.17
	regex-automata-0.4.10
	regex-syntax-0.8.6
	rustc-demangle-0.1.26
	rustversion-1.0.22
	ryu-1.0.20
	scopeguard-1.2.0
	secp256k1-0.28.2
	secp256k1-sys-0.9.2
	serde-1.0.219
	serde_derive-1.0.219
	serde_json-1.0.143
	sharded-slab-0.1.7
	shlex-1.3.0
	slab-0.4.11
	smallvec-1.15.1
	socket2-0.6.0
	syn-2.0.106
	tabled-0.20.0
	tabled_derive-0.11.0
	testing_table-0.3.0
	thread_local-1.1.9
	tokio-1.47.1
	tokio-macros-2.5.0
	tokio-stream-0.1.17
	tokio-util-0.7.16
	tracing-0.1.41
	tracing-attributes-0.1.30
	tracing-core-0.1.34
	tracing-log-0.2.0
	tracing-subscriber-0.3.20
	unicode-ident-1.0.18
	unicode-width-0.2.1
	valuable-0.1.1
	wasi-0.11.1+wasi-snapshot-preview1
	wasi-0.14.3+wasi-0.2.4
	wasm-bindgen-0.2.100
	wasm-bindgen-backend-0.2.100
	wasm-bindgen-macro-0.2.100
	wasm-bindgen-macro-support-0.2.100
	wasm-bindgen-shared-0.2.100
	windows-core-0.61.2
	windows-implement-0.60.0
	windows-interface-0.59.1
	windows-link-0.1.3
	windows-result-0.3.4
	windows-strings-0.4.2
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
	wit-bindgen-0.45.0
	zerocopy-0.8.26
	zerocopy-derive-0.8.26
"
# additional crates from cln-plugin, cln-rpc
CRATES+="
	async-stream-0.3.6
	async-stream-impl-0.3.6
	env_logger-0.10.2
	hermit-abi-0.4.0
	humantime-2.1.0
	is-terminal-0.4.13
	termcolor-1.4.1
	tokio-test-0.4.4
	winapi-util-0.1.9
"

inherit cargo edo

CLN_PV=25.05

DESCRIPTION="A Core Lightning plugin to automatically rebalance multiple channels"
HOMEPAGE="https://github.com/daywalker90/sling"
SRC_URI="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ElementsProject/lightning/archive/refs/tags/v${CLN_PV}.tar.gz -> core-lightning-${CLN_PV}.tar.gz
	$(cargo_crate_uris)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

RDEPEND="
	>=net-p2p/core-lightning-23.11
"

PATCHES=(
	"${FILESDIR}/support-version-without-v.patch"
)

efmt() {
	: ${1:?} ; local l ; while read -r l ; do "${!#}" "${l}" ; done < <(fmt "${@:1:$#-1}")
}

cargo_toml_pkg_ver() {
	sed -ne '/^\[package\]$/,/^$/s/^\s*version\s*=\s*"\(.*\)"$/\1/p' -- "${1:?}"
}

src_unpack() {
	local A=" ${A} " ; A="${A/ core-lightning-${CLN_PV}.tar.gz / }"
	cargo_src_unpack

	# It appears that the CLN release engineer forgot to bump the crate
	# versions, so we have to extract the sources of cln-plugin and cln-rpc
	# manually from the CLN tarball into our vendor repository.
	edo tar -xz -f "${DISTDIR}/core-lightning-${CLN_PV}.tar.gz" --strip-components=1 \
			"lightning-${CLN_PV}"/{cln-rpc,plugins} || die
	echo '{"package":"","files":{}}' >cln-rpc/.cargo-checksum.json || die
	echo '{"package":"","files":{}}' >plugins/.cargo-checksum.json || die
	mv -- cln-rpc "${ECARGO_VENDOR}/cln-rpc-$(cargo_toml_pkg_ver cln-rpc/Cargo.toml)" || die
	mv -- plugins "${ECARGO_VENDOR}/cln-plugin-$(cargo_toml_pkg_ver plugins/Cargo.toml)" || die
}

src_prepare() {
	default

	# don't use explicitly sourced dependencies; use our local registry
	sed -Ee 's/^#\s*(cln-\w+\s*=\s*")/\1/' -e 's/^\s*cln-\w+\s*=\s*\{/# \0/' -i Cargo.toml || die
}

src_install() {
	cargo_src_install
	insinto /usr/libexec/c-lightning/plugins
	mv -- "${ED}/usr/bin/sling" "${ED}/usr/libexec/c-lightning/plugins/" || die
}

pkg_postinst() {
	local v ; for v in ${REPLACING_VERSIONS} ; do
		if ver_test "${v}" -lt 4.0.0 ; then
			efmt ewarn <<-EOF
				This version of ${CATEGORY}/${PN} drops the config variables
				sling-refresh-peers-interval and sling-refresh-gossmap-interval.
				You will need to remove these from your lightningd.conf if they are present.
			EOF
			break
		fi
	done
}
