# Copyright 2010-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.24.2
	adler2-2.0.0
	aho-corasick-1.1.3
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anyhow-1.0.97
	arrayvec-0.7.6
	autocfg-1.4.0
	backtrace-0.3.74
	bech32-0.10.0-beta
	bitcoin-0.31.2
	bitcoin-internals-0.2.0
	bitcoin_hashes-0.13.0
	bitflags-2.9.0
	bumpalo-3.17.0
	bytecount-0.6.8
	bytes-1.10.1
	cc-1.2.16
	cfg-if-1.0.0
	chrono-0.4.40
	cln-plugin-0.4.0
	cln-rpc-0.4.0
	core-foundation-sys-0.8.7
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
	getrandom-0.3.1
	gimli-0.31.1
	heck-0.5.0
	hex-0.4.3
	hex-conservative-0.1.2
	hex_lit-0.1.1
	iana-time-zone-0.1.61
	iana-time-zone-haiku-0.1.2
	itoa-1.0.15
	js-sys-0.3.77
	lazy_static-1.5.0
	libc-0.2.171
	lock_api-0.4.12
	log-0.4.26
	log-panics-2.1.0
	matchers-0.1.0
	memchr-2.7.4
	miniz_oxide-0.8.5
	mio-1.0.3
	nu-ansi-term-0.46.0
	num-format-0.4.4
	num-traits-0.2.19
	object-0.36.7
	once_cell-1.21.0
	overload-0.1.1
	papergrid-0.14.0
	parking_lot-0.12.3
	parking_lot_core-0.9.10
	pin-project-lite-0.2.16
	pin-utils-0.1.0
	ppv-lite86-0.2.21
	proc-macro-error-attr2-2.0.0
	proc-macro-error2-2.0.1
	proc-macro2-1.0.94
	quote-1.0.39
	rand-0.9.0
	rand_chacha-0.9.0
	rand_core-0.9.3
	redox_syscall-0.5.10
	regex-1.11.1
	regex-automata-0.1.10
	regex-automata-0.4.9
	regex-syntax-0.6.29
	regex-syntax-0.8.5
	rustc-demangle-0.1.24
	rustversion-1.0.20
	ryu-1.0.20
	scopeguard-1.2.0
	secp256k1-0.28.2
	secp256k1-sys-0.9.2
	serde-1.0.219
	serde_derive-1.0.219
	serde_json-1.0.140
	sharded-slab-0.1.7
	shlex-1.3.0
	slab-0.4.9
	smallvec-1.14.0
	socket2-0.5.8
	syn-2.0.100
	tabled-0.18.0
	tabled_derive-0.10.0
	thread_local-1.1.8
	tikv-jemalloc-sys-0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
	tikv-jemallocator-0.6.0
	tokio-1.44.0
	tokio-macros-2.5.0
	tokio-stream-0.1.17
	tokio-util-0.7.13
	tracing-0.1.41
	tracing-attributes-0.1.28
	tracing-core-0.1.33
	tracing-log-0.2.0
	tracing-subscriber-0.3.19
	unicode-ident-1.0.18
	unicode-width-0.2.0
	valuable-0.1.1
	wasi-0.11.0+wasi-snapshot-preview1
	wasi-0.13.3+wasi-0.2.2
	wasm-bindgen-0.2.100
	wasm-bindgen-backend-0.2.100
	wasm-bindgen-macro-0.2.100
	wasm-bindgen-macro-support-0.2.100
	wasm-bindgen-shared-0.2.100
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-core-0.52.0
	windows-link-0.1.0
	windows-sys-0.52.0
	windows-targets-0.52.6
	windows_aarch64_gnullvm-0.52.6
	windows_aarch64_msvc-0.52.6
	windows_i686_gnu-0.52.6
	windows_i686_gnullvm-0.52.6
	windows_i686_msvc-0.52.6
	windows_x86_64_gnu-0.52.6
	windows_x86_64_gnullvm-0.52.6
	windows_x86_64_msvc-0.52.6
	wit-bindgen-rt-0.33.0
	zerocopy-0.8.23
	zerocopy-derive-0.8.23
"

inherit cargo

DESCRIPTION="A Core Lightning plugin to automatically rebalance multiple channels"
HOMEPAGE="https://github.com/daywalker90/sling"
SRC_URI="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

RDEPEND="
	>=net-p2p/core-lightning-23.11
"

src_install() {
	cargo_src_install
	insinto /usr/libexec/c-lightning/plugins
	mv -- "${ED}/usr/bin/sling" "${ED}/usr/libexec/c-lightning/plugins/" || die
}
