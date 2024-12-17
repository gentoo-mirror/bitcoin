# Copyright 2010-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.24.2
	adler2-2.0.0
	aho-corasick-1.1.3
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anyhow-1.0.94
	arrayvec-0.7.6
	autocfg-1.4.0
	backtrace-0.3.74
	bech32-0.10.0-beta
	bitcoin-0.31.2
	bitcoin-internals-0.2.0
	bitcoin_hashes-0.13.0
	bitflags-2.6.0
	bumpalo-3.16.0
	bytecount-0.6.8
	byteorder-1.5.0
	bytes-1.9.0
	cc-1.2.3
	cfg-if-1.0.0
	chrono-0.4.39
	cln-plugin-0.3.0
	cln-rpc-0.3.0
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
	getrandom-0.2.15
	gimli-0.31.1
	heck-0.4.1
	hex-0.4.3
	hex-conservative-0.1.2
	hex_lit-0.1.1
	iana-time-zone-0.1.61
	iana-time-zone-haiku-0.1.2
	itoa-1.0.14
	js-sys-0.3.76
	lazy_static-1.5.0
	libc-0.2.168
	lock_api-0.4.12
	log-0.4.22
	log-panics-2.1.0
	matchers-0.1.0
	memchr-2.7.4
	miniz_oxide-0.8.0
	mio-1.0.3
	nu-ansi-term-0.46.0
	num-format-0.4.4
	num-traits-0.2.19
	object-0.36.5
	once_cell-1.20.2
	overload-0.1.1
	papergrid-0.13.0
	parking_lot-0.12.3
	parking_lot_core-0.9.10
	pin-project-lite-0.2.15
	pin-utils-0.1.0
	ppv-lite86-0.2.20
	proc-macro-error-attr2-2.0.0
	proc-macro-error2-2.0.1
	proc-macro2-1.0.92
	quote-1.0.37
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.5.7
	regex-1.11.1
	regex-automata-0.1.10
	regex-automata-0.4.9
	regex-syntax-0.6.29
	regex-syntax-0.8.5
	rustc-demangle-0.1.24
	ryu-1.0.18
	scopeguard-1.2.0
	secp256k1-0.28.2
	secp256k1-sys-0.9.2
	serde-1.0.215
	serde_derive-1.0.215
	serde_json-1.0.133
	sharded-slab-0.1.7
	shlex-1.3.0
	slab-0.4.9
	smallvec-1.13.2
	socket2-0.5.8
	syn-1.0.109
	syn-2.0.90
	tabled-0.17.0
	tabled_derive-0.9.0
	thread_local-1.1.8
	tikv-jemalloc-sys-0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
	tikv-jemallocator-0.6.0
	tokio-1.42.0
	tokio-macros-2.4.0
	tokio-stream-0.1.17
	tokio-util-0.7.13
	tracing-0.1.41
	tracing-attributes-0.1.28
	tracing-core-0.1.33
	tracing-log-0.2.0
	tracing-subscriber-0.3.19
	unicode-ident-1.0.14
	unicode-width-0.2.0
	valuable-0.1.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.99
	wasm-bindgen-backend-0.2.99
	wasm-bindgen-macro-0.2.99
	wasm-bindgen-macro-support-0.2.99
	wasm-bindgen-shared-0.2.99
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-core-0.52.0
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
	zerocopy-0.7.35
	zerocopy-derive-0.7.35
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