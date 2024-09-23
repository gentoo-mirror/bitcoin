# Copyright 2010-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.22.0
	adler-1.0.2
	aho-corasick-1.1.3
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anyhow-1.0.86
	arrayvec-0.7.4
	autocfg-1.3.0
	backtrace-0.3.72
	bech32-0.9.1
	bitcoin-0.30.2
	bitcoin-private-0.1.0
	bitcoin_hashes-0.12.0
	bitflags-2.5.0
	bumpalo-3.16.0
	bytecount-0.6.8
	bytes-1.6.0
	cc-1.0.98
	cfg-if-1.0.0
	chrono-0.4.38
	cln-plugin-0.1.9
	cln-rpc-0.1.9
	core-foundation-sys-0.8.6
	fnv-1.0.7
	futures-0.3.30
	futures-channel-0.3.30
	futures-core-0.3.30
	futures-executor-0.3.30
	futures-io-0.3.30
	futures-macro-0.3.30
	futures-sink-0.3.30
	futures-task-0.3.30
	futures-util-0.3.30
	getrandom-0.2.15
	gimli-0.29.0
	heck-0.4.1
	hermit-abi-0.3.9
	hex-0.4.3
	hex_lit-0.1.1
	iana-time-zone-0.1.60
	iana-time-zone-haiku-0.1.2
	itoa-1.0.11
	js-sys-0.3.69
	lazy_static-1.4.0
	libc-0.2.155
	lock_api-0.4.12
	log-0.4.21
	log-panics-2.1.0
	matchers-0.1.0
	memchr-2.7.2
	miniz_oxide-0.7.3
	mio-0.8.11
	nu-ansi-term-0.46.0
	num-format-0.4.4
	num-traits-0.2.19
	num_cpus-1.16.0
	object-0.35.0
	once_cell-1.19.0
	overload-0.1.1
	papergrid-0.11.0
	parking_lot-0.12.3
	parking_lot_core-0.9.10
	pin-project-lite-0.2.14
	pin-utils-0.1.0
	ppv-lite86-0.2.17
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.85
	quote-1.0.36
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.5.1
	regex-1.10.4
	regex-automata-0.1.10
	regex-automata-0.4.6
	regex-syntax-0.6.29
	regex-syntax-0.8.3
	rustc-demangle-0.1.24
	ryu-1.0.18
	scopeguard-1.2.0
	secp256k1-0.27.0
	secp256k1-sys-0.8.1
	serde-1.0.203
	serde_derive-1.0.203
	serde_json-1.0.117
	sharded-slab-0.1.7
	slab-0.4.9
	smallvec-1.13.2
	socket2-0.5.7
	syn-1.0.109
	syn-2.0.66
	tabled-0.15.0
	tabled_derive-0.7.0
	thread_local-1.1.8
	tikv-jemalloc-sys-0.5.4+5.3.0-patched
	tikv-jemallocator-0.5.4
	tokio-1.38.0
	tokio-macros-2.3.0
	tokio-stream-0.1.15
	tokio-util-0.7.11
	tracing-0.1.40
	tracing-attributes-0.1.27
	tracing-core-0.1.32
	tracing-log-0.2.0
	tracing-subscriber-0.3.18
	unicode-ident-1.0.12
	unicode-width-0.1.12
	valuable-0.1.0
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.92
	wasm-bindgen-backend-0.2.92
	wasm-bindgen-macro-0.2.92
	wasm-bindgen-macro-support-0.2.92
	wasm-bindgen-shared-0.2.92
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-core-0.52.0
	windows-sys-0.48.0
	windows-sys-0.52.0
	windows-targets-0.48.5
	windows-targets-0.52.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_gnullvm-0.52.5
	windows_aarch64_msvc-0.48.5
	windows_aarch64_msvc-0.52.5
	windows_i686_gnu-0.48.5
	windows_i686_gnu-0.52.5
	windows_i686_gnullvm-0.52.5
	windows_i686_msvc-0.48.5
	windows_i686_msvc-0.52.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnu-0.52.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_gnullvm-0.52.5
	windows_x86_64_msvc-0.48.5
	windows_x86_64_msvc-0.52.5
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
