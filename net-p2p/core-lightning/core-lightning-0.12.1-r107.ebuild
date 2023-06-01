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
	aho-corasick-0.7.20
	anyhow-1.0.68
	asn1-rs-0.5.1
	asn1-rs-derive-0.4.0
	asn1-rs-impl-0.1.0
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.60
	autocfg-1.1.0
	axum-0.6.1
	axum-core-0.3.0
	base64-0.13.1
	bech32-0.9.1
	bitcoin-0.29.2
	bitcoin_hashes-0.11.0
	bitflags-1.3.2
	bumpalo-3.11.1
	bytes-1.3.0
	cc-1.0.78
	cfg-if-1.0.0
	data-encoding-2.3.3
	der-parser-8.1.0
	displaydoc-0.2.3
	either-1.8.0
	env_logger-0.10.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	fixedbitset-0.4.2
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
	heck-0.4.0
	hermit-abi-0.2.6
	hex-0.4.3
	http-0.2.8
	http-body-0.4.5
	http-range-header-0.3.0
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.23
	hyper-timeout-0.4.1
	indexmap-1.9.2
	instant-0.1.12
	io-lifetimes-1.0.3
	is-terminal-0.4.2
	itertools-0.10.5
	itoa-1.0.5
	js-sys-0.3.60
	lazy_static-1.4.0
	libc-0.2.139
	linux-raw-sys-0.1.4
	log-0.4.17
	matchit-0.7.0
	memchr-2.5.0
	mime-0.3.16
	minimal-lexical-0.2.1
	mio-0.8.5
	multimap-0.8.3
	nom-7.1.1
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.15.0
	oid-registry-0.6.1
	once_cell-1.16.0
	pem-1.1.0
	percent-encoding-2.2.0
	petgraph-0.6.2
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.17
	prettyplease-0.1.22
	proc-macro2-1.0.49
	prost-0.11.5
	prost-build-0.11.5
	prost-derive-0.11.5
	prost-types-0.11.5
	quote-1.0.23
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rcgen-0.10.0
	redox_syscall-0.2.16
	regex-1.7.0
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	ring-0.16.20
	rusticata-macros-4.1.0
	rustix-0.36.5
	rustls-0.20.7
	rustls-pemfile-1.0.1
	rustversion-1.0.11
	ryu-1.0.12
	sct-0.7.0
	secp256k1-0.24.2
	secp256k1-sys-0.6.1
	serde-1.0.151
	serde_derive-1.0.151
	serde_json-1.0.91
	slab-0.4.7
	socket2-0.4.7
	spin-0.5.2
	syn-1.0.107
	sync_wrapper-0.1.1
	synstructure-0.12.6
	tempfile-3.3.0
	termcolor-1.1.3
	thiserror-1.0.38
	thiserror-impl-1.0.38
	time-0.3.17
	time-core-0.1.0
	time-macros-0.2.6
	tokio-1.24.2
	tokio-io-timeout-1.2.0
	tokio-macros-1.8.2
	tokio-rustls-0.23.4
	tokio-stream-0.1.11
	tokio-util-0.7.4
	tonic-0.8.3
	tonic-build-0.8.4
	tower-0.4.13
	tower-http-0.3.5
	tower-layer-0.3.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-futures-0.2.5
	try-lock-0.2.3
	unicode-ident-1.0.6
	unicode-xid-0.2.4
	untrusted-0.7.1
	want-0.3.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	web-sys-0.3.60
	webpki-0.22.0
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
	x509-parser-0.14.0
	yasna-0.5.1
"

inherit backports bash-completion-r1 cargo distutils-r1 postgres toolchain-funcs

MyPN=lightning
MyPV=${PV/[-_]rc/rc}
BACKPORTS=(
#	397c8804261690e1e8864c533b263d273fbb6f4b	# Add Arch Linux build instructions
#	ba76854e2964365cdb534fd55e7f60f647761ce9	# Add Arch Linux build instructions
#	299a99ed6745bf618d9897700fd45f21ba1539c0	# Use unordered list
#	d4a04ba8b316e7653c909eb0af0490d41f966bc8	# Simplify poetry interactions
	6a7d40f51a9ba74f1bbb1621cc5a7b1d06580cca	# ccan: update to get -Wshadow=local clean build.
	6fe570820e66491778b9e60d2b2942bbffbee813	# Remove general shadowed variables.
	44d9e8d9c5e738f99eba29d194e8972799c57e7e	# Remove names of parameters of callbacks which confuse gcc.
#	2c722291069dd5cf5a65288ed3131f96daed5b05	# configure: add -Wshadow=local flag.
#	0d5808b6f6ed23e724e8b1c283c557d69a4adaa6	# pytest: fix test_channel_state_change_history
#	ea414320a3db540889eb9ec0854638a685850ad2	# build, shadows: fix broken build (no shadows)
	c4203e7de6f35ed1cd1658d7c898b8b6bfaac2df	# pyln-client: allow 'msat' fields to be 'null'
#	50056ce9182d4c8865395e5a50e294c59124be6b	# doc: remove mrkd requirement, add lowdown requirement.
#	9de458b23b5b761cb98307f62c5fa8fceea1e55c	# docs: Clear up Ubutu documentation
	e0259b246e6f372cf585446ce239b3a7bdc6d4b1	# test: fix tlvs test in funding_locked tlv.
	a56b17c759c53e7705fd6f002d53e809c03e4c26	# wire/test: neaten and complete tlv checks.
	6c33f7db65caf619c2c9ceea1071b38c05e3357d	# common: remove unused parameter "allow_deprecated" from parse_wireaddr_internal.
#	bfe342c64b5fb298f6739e940ddcaf778af3ba33	# lightningd: remove double-wrapped rpc_command hook.
	43b037ab0b372397cecc477a50fef201b0b313ed	# lightningd: always require "jsonrpc": "2.0"  in request.
#	a45ec78c36c869534b78cbfa238befdb64107666	# lightningd: don't allow old listforwards arg order.
#	15751ea1b8c10186dd3ac4fec679a6699d1d7d01	# lightningd: do inline parsing for listforwards status parameter
#	733ce81bd4d115779450f87a8e2287af0c55574e	# plugins: require usage for plugin APIs.
#	29264e83fbac59771164ece2361a135a15140b20	# lightningd: remove `use_proxy_always` parameter to plugin init.
	318650a6275d7246c4a2aa6c663aecac5070dd5e	# listchannels: don't show "htlc_maximum_msat" if channel_update didn't set it.
	136d0c8005ed56d9a36a91656bb00d8f3b4a86f4	# offers: update to remove "vendor" and "timestamp" fields.
	6cf3d4750526a6d4f5d70bd6a47e16a8aab30529	# offers: remove backwards-compatiblity invoice_request signatures.
#	1a0f7ddb0dd501d5eb69a9a836018b33f0f71c1c	# hsmtool: remove hsm_secret passwords on cmdline support in `dumponchaindescriptors`.
#	fbcdf2c565b6b5fb59c761ca36bf8d5637d7b0f5	# devtools/bolt-catchup.sh: a tool to update the specs, one commit at a time.
	341bbdfcbe75331d12d84410a5893d199d19b552	# doc: increase BOLT level to 03468e17563650fb9bfe58b2da4d1e5d28e92009
	1b30ea4b82b1fe5adbdedfc31322bcf3e0c8ac08	# doc: update BOLTs to bc86304b4b0af5fd5ce9d24f74e2ebbceb7e2730
#	5b7f14a7cb2cf4fd097a9169a115efb6575dd48e	# channeld/dualopend/lightningd: use channel_ready everywhere.
	b208c0d8dd4bc6d7b0291183c3e36cd87dac0de8	# doc: upgrade to BOLTs 2ecc091f3484f7a3450e7f5543ae851edd1e0761
	3cc6d0ec2c9cdcce975309382cf5c115c4a9c113	# doc: upgrade to BOLTs 341ec844f13c0c0abc4fe849059fbb98173f9766
#	4ca1203eb8c5d5d447b1972722c98980e9b9111a	# doc: include recent BOLT recommendation on grace period.
	2ac775f9f4343338a0782a07d446920582f576b8	# lightningd: fix crash with -O3 -flto.
	2c3d4e46fcb16e89c48df7ecc54056bc5cdde317	# tools/test: fix very confused code.
	bef2a47ab7a1acb01582d33db406cf0b6e06b8ac	# db: fix renaming/deleting cols of DBs when there are UNIQUE(x, b, c) constraints.
	fb433a70f8b0de0e771de1f3378ee8f3e3bbef58:scrub-stamps	# doc: escape output types (esp `short_channel_id`).
	b3b5b740694f28c6daf4846d26ee9e1967ba3596	# libplugin: allow NULL calllbacks for jsonrpc_set_datastore.
#	6438ee41267bfb7f7adb1f9fd938ee744dfb3840	# doc: disallow additional properties in sendcustommsg.
	d7aa2749c3f2d596a33f8e86de8d276410b4aa9b	# db: fix migrations which write to db.
	e853cdc3ff3732629c912eb5b4ab880944d3ccff	# db: fix sqlite3 code which manipulates columns.
	375215a141f60ed2d458cd8606933098de397152	# lightningd: more graceful shutdown.
	e0d6f3ceb1775a96672d9a7eee730f2b6c6a1e2f	# connectd: DNS Bolt7 #911 no longer EXPERIMENTAL
#	daeec66bd7815d73f0e00b8610bd024d54be7ba8	# db: Add completed_at field to payments
#	cb3ee0ac2ea126092775e46b56e4ed8650b4c23c	# wallet: Load and value `completed_at` timestamp from DB
	a80211e960f6e8135170d9753953e1703d85403c	# doc: Update generated artifacts to match master
#	246e1fb0b3db11af1c9286e0f0ae635658c14f33	# wallet: Set the `completed_at` timestamp when updating the status
#	f64d755e435dd739b041ff05c062959e4f84c048	# pay: Aggregate `completed_at` in `listpays` and `pay`
	746b5f3691525a37f837fdabd8bd967e8683834b	# Makefile: fix msggen regeneration when schemas change.
#	897245e3b7646987980a3246de03c089e3e82bd1	# pytest: test for escapes in commando values.
	1f9730748cf747655783adacabba4ae6c65d53aa	# CCAN: update to get latest rune decode fix.
	d57d87ea3a5f5d30e855cdc6e4a131ee3af70f62:strip=tests/	# commando: unmangle JSON.
	a6d4756d0876fba4d9739d22b75cc314dce23206:strip=tests/	# commando: make rune alternatives a JSON array.
	023a688e3f1ebdf1b41ea97720b0ccccf7ccbfaa	# lightningd: fix spurious leak report.
	9b33a921f04b70a25c0979db3ad4c98f49db98c6	# Add plugin notification topic "block_processed".
	1ef8fb7ef8b9f52d8167dd35e00776cab8cfb222	# rename `block_processed` to `block_added`
	0a856778bcbf3bfeffc3d0bc6eaa57ce2cdf1f11	# plugins/bcli: load RPC password from stdin instead of an argument
	4ca6b36439074f41729da679815792ee73b5fb24:scrub-stamps	# lightningd: refuse to upgrade db on non-released versions by default.
	532544ce4fa859037faf177b0af4b01a9025e3c1	# gossipd: rename remote_addr to discovered_ip within gossipd
	5d259348657324dbfb2e3bcb4bf8a6280e8d6533	# plugins/Makefile: regenerate plugins list when config changes.
	88354b79bd5bd067abea32781865a2644cc74bcd	# common: helper to get id field as a string.
	6c07f1365fa8adfb1e8f5f896177c88ec15be924	# lightning-cli: don't consume 100% CPU if lightningd crashes.
	2d7cf153ad4b99656e34eea5e8348d829c77fe23	# lightningd: log JSON request ids.
	87112415356ac08ac59de05af3b9a17e418feab3	# lightning-cli: use cli:<method>-<pid> for all requests.
	db89a3413592eafcf424d7d8cdabc0be2ba52178	# libplugin: allow lightningd to give us non-numeric ids.
	ce0b765c9604e8bb74a3dc88db1451ace9a3f378	# cln-rpc: allow id to be any token.
	99f2019a24738fa4f7b003d345e73813c76d393e	# lightningd: add jsonrpc_request_start_raw instead of NULL method.
	ed3f700991ce9c8b1a41cdff24d5d250f8190426	# lightningd: use string as json req ids when we create them.
	8fcf880e0ff6acd37e1d887a9e46166c260fb23e	# lightningd: explicitly remember if JSON id was a string.
	a9557d5194f8aa6b41c2c35a6e17d47bf9d87e37	# lightningd: derive JSONRPC ids from incoming id (append /cln:<method>#NNN).
	ea7903f69a2df3ac51e25422f7d111bea9f693c7	# lightningd: trace JSON id prefixes through sendrawtx.
	eceb9f432814830b7b84e8a9b1f4c9eefdbe60cd	# lightningd: wire plugin command JSON id through to plugin commands.
	e8ef42b7418c23e68b9ed8e9f8b990dd5daf05d5	# plugin: wire JSON id for commands which caused hooks to fire.
	d360075d2231865b7a20645cbd4ec07ed04a27fb:resolve-conflicts	# libplugin: use string ids correctly.
	f1f2c1322d750361c2751cd63acb8dff51580c6b	# contrib/pyln-client: construct JSON ID correctly.
	fdc59dc94a69066a5b4c4a2209f9a352214a6ddd	# contrib/pyln-testing: pass through id correctly.
	bf54d6dcf58733399d240fbddf99380882f49674:resolve-conflicts	# libplugin: use proper JSON id for rpc_scan().
	caecd1ee0aad1b391b3019c78a7e075165061bcf	# lightningd: don't log JSON ids as debug, use log io.
	bbe1711e1683739dbfea07c81dabe594d7c98b08	# lightningd: use jcon logging for commands where possible.
#	74cd0a72801967f2c459c7613c4d8ca604f17fb9	# gci: Use stable rust instead of nightly
#	37c07ddfe5cbe63dadbddb4e6d29ef9ec76221f2	# pyln: Add grpcio and protobuf dependencies to pyln-testing
#	37fc0d8c6f9b6b7de6e9dbffe61d3d3db162cb3a	# docker: use pip install + poetry export instead of poetry update
#	05e23171421eb47466af7920af36eaa74deac21b	# doc/install: get rid of out of date mrkd / mistune install instructions
#	3aeac0a58c938e0afa26d358ea9fd123d761cdd1	# docs: Correct a command typo for Ubuntuu
#	9bba7ba1a43fabc910cad71f93bd825b61bbd33a	# Update doc/INSTALL.md
#	a99a72be9b1e07d5fe2feb1372f58a122da9499c	# contrib/startup_regtest.sh: misc fixes and add destroy_ln, print usage.
#	d2edeff6984b0a0ac2355f9f071d829257163281	# contrib/giantnode.py: populate three regtest nodes with many invoices/forwards/payments.
#	7fa13646458418b80bf46c512086700d6b7a7727	# build: allow DEVELOPER builds with -Og and gcc 9.4.0
	2da5244e8390b8d9b5bdb12651a35cd559ad8283	# jsonrpc: make error codes an enum.
	6a48ed9e826efed1ea53b18a8308f97c2d5bbe34	# gossmap: fail to get capacity of locally-added chans (don't crash!).
	016e332304af6576d44124494c97c0e7c2a1a06c	# gossmap: add functions to map index back to node/chan.
	4cdb4167d2e3c3052d42e1a38a0dfebef496d48a	# gossmap: make local_addchan create private channel_announcement in correct order.
	fd71dfc7f79e71b5e3b8017dbdd11d469415bf7a	# gossmap: optimize asserts().
	3380f559f9cca7f6085c3b01af6a74fe1eac04a4	# memleak: simplify API.
	701dd3dcefd7a005e042c310a902f4b3dea15e61	# memleak: remove exclusions from memleak_start()
	5b58eda7486d2fe613396e197d9a538f84a85820	# libplugin: mark the cmd notleak() whenever command_still_pending() called.
	248d60d7bd7e9a1961e70a3579ea93a0d496d6cc	# Don't report redundant feerates to subdaemons
#	ab95d2718f1dfa1f0190159e2ba56c5ffdfc84fc	# pyln: Reduce dependency strictness for pyln-testing
#	fcd2320de7be182af0ed4c04409165bae912d38d	# gha: Make the setup and build scripts exit if anything fails
	7159a25e7358a6eae4ca2f3d1c64407ac304bb96	# openingd: Add method to set absolute reserve
	5c1de8029a0b48ab69f394384e750dc89c1a89b3:strip=contrib/pyln-testing/	# openingd: Add `reserve` to `fundchannel` and `multifundchannel`
	9a97f8c154dfc84e69d494a1a72bfdc00041de5a	# plugin: Add `reserve` to `openchannel` hook result
	8d6423389a4d58bafde6af417c7b52add0475d32	# openingd: Wire `reserve` value through to `openingd`
	5a54f450bdc5f659f9e8dfae27d931cebe9d462c	# openingd: Pass `reserve` down to openingd when funding
	2def843dcea8ea70b9b5a80763a10f4cc6378bdd	# pay: Allow using a channel on equality of estimated capacity
	c3e9cb7a47a1497a32c0c0fdc49209674d1155de	# openingd: Add zeroconf-no-really-zero mode
#	c5b2aee5c69071141fb99ead92a437d7b3e46816	# pytest: Add a zeroreserve test
	67467213cb246386c9615add6ecff3dbca7c2249	# opening: Add `dev-allowdustreserve` option to opt into dust reserves
	1bd3d8d9f98991c1958dda66ffaae3e0887fbd98	# openingd: Remove dust check for reserve imposed on us
	54b4baabb00d046c0725aeabb2b1737143a896c1:strip=tests/:scrub-stamps	# opening: Add `dev-allowdustreserve` option to opt into dust reserves
#	bdda62e1a44ce4be0cc6a3ec9507d21cef291b91	# pytest: Add test for mixed zeroreserve funding
	759fcb64a8c28a90a7659c2b1791ce9993067796	# pay: If the channel_hint matches our allocation allow it
#	493a0dfcd4e4ec8f53389b837b07c85be82efb30	# pytest: Exercise all dust zeroreserve case
	75fe1c1a668cc80e63ca13bb80cd448f2ad7491f	# common: Add multiplication primitives for amount_msat and amount_sat
	774d16a72e125e4ae4e312b9e3307261983bec0e:strip=tests/	# openingd: Fail if dust and max_htlcs result in 0output commitment tx
	5a1c2447cb9d4bfe3970ecac6df6d5849bfab0c4	# pyln-client: use f strings to concatenate JSON ids, handle older integer ids.
#	0db01c882f11de1f683ee1cf00e91c4f7fc5d725	# pytest: fix flake in test_sendcustommsg
#	43556126467126ee60fd629482db6747b15ade08	# gh: Mark some derived files as such
#	41502be60ac619dd78b64b15987029182171a134	# Fix a small typo
	ce0f5440733901984672757c9e4b1f93854c4e97	# keysend: try to find description in TLV.
	df4b477e88d2b93bb030d27b23ea9f12c9b3031c	# keysend: allow extratlvs parameter, even in non-experimental mode.
	0868fa9f1edb2cb7430ca5ecf436ecfead0ac459:scrub-stamps	# lightningd: allow extra tlv types in non-experimental mode.
	775d6ba193497dac5526fd6e6b6f9bc8eb656dee	# doc: Fix wrong_funding description in manpage and type in schema
	b9a7f36ab3cc44b3b69711592002490088ceb3f8:strip=contrib/pyln-testing/	# msggen: Add conversion from cln-rpc to cln-grpc for Option<Outpoint>
#	3c80b22d6fd6d6c0e4cfcd550adeaf7da7e3652d	# pyln: use poetry version, add target to check version, use poetry publish.
#	0514269f48f37c49c2df49a5733fc15dcb09f647	# Makefile: add targets to upgrade pyln versions, push releases.
#	7c2c100145eea0abacffabe42bbbfde3fead1fd3	# pyln: results of make update-pyln-versions NEW_VERSION=0.12.0
#	aace5b51efbc10e6908c7e6242de6c1264dee7a6	# pyln: Adjust the auto-publish task to trigger on tags
#	8ae0af7962b4e19064d5bfa6341ef7816dc749b1	# pyln: Bump pyln-client dependency in pyln-testing
#	4693803c355db5cfa93ebd188a8a2232ca6e9535	# ci: Use the new make upgrade-version target to manage versions
#	bd76a196f57773fce539472a1af5118e7fe4c7c9	# autoclean: new interface
#	17858c94902e505e491e16255a8b256bb4ed6b6b	# lightningd: deprecated "delexpiredinvoice", put functionality in autoclean plugin.
#	7da51892e828cbf629d79f048697aa9805282c4e	# autoclean: save stats on how much we cleaned.
#	660c9af1d9e1966080cfe066924abdc39e380301	# autoclean: allow cleaning of paid invoices too.
#	4cab396cc8f9eb9894f3c5745366058bd058d881	# autoclean: handle cleaning of old payments (not just invoices).
#	2a5660b3bca78b8f49f5c57ea3ed7083efdfc423	# lightningd: index to speed up sendpay / listsendpays
	2022e4a7a9d02473b521a24258c210a2ce357368:resolve-conflicts	# wallet: simplify payments lookup so sqlite3 uses index.
#	63457229cbe287cb04ddf907898794a12288d721	# wallet: replace forwarded_payments table with forwards table.
	33a6b188919ffb6f0abfc5902eb50f8bc564641e	# db/bindings: rename db_bind_short_channel_id to db_bind_short_channel_id_str, add db_bind_scid.
	e286c38c6ff66680638384e0c22210ccd86fb49d:resolve-conflicts	# wallet: use db_col_scid / db_bind_scid where possible.
#	2752e04f8f24f68c7e55244fe39d6fc27677222f	# db: add `scid` field to channels table.
#	d7c1325e38dfa15ccb2021430d118ee6a14dd1ee	# wallet: use scid not string for failchannel (now failscid) in payments table.
	311807ff1f4f3574413b2ef86f63bf28e5363ee2:strip=contrib/pyln-testing/:scrub-stamps:resolve-conflicts	# lightningd: add in_htlc_id / out_htlc_id to listforwards.
	7420a7021f4805d8b8058e86eec791f4ce3e27fa:scrub-stamps	# lightningd: add `listhtlcs` to list all the HTLCs we know about.
#	3079afb024e9307a696046d0e936ff240a5f4c86	# lightningd: add `delforward` command.
#	a15f1be5f88bdae5a6e816026e35a035791875e8	# autoclean: clean up listforwards as well.
#	399288db3f2a90e52fcea587424c1287705c69d1	# autoclean: use config variables, not commands.
#	612f3de0d4a07851c8f25ed8e2c359ecea7e3e2f	# doc: manpages and schemas for autoclean-status.
#	13e10877de9dde1b5aa784894a15a4611b62a46a	# autoclean: add autoclean-once command.
#	540a6e4b99c5c0b5b49dbd6b1c604f599eb45718	# autoclean: remove per-delete debugging messages.
	4d8c3215174e1436dccb66d60fa69536f3b4d31a	# libplugin: optimize parsing lightningd rpc responses.
	8b7a8265e7ad80bb0e1882ad5dffada14f7425df	# libplugin: avoid memmove if we have many outputs to lightningd.
	555b8a2f7a2bd728efa15dda8302084e477aa8c9	# lightningd: don't always wrap each command in a db transaction.
	fa7d732ba6f6cbba035f8162df3ad32ec8cabbd9:scrub-stamps:resolve-conflicts	# lightningd: allow a connection to specify db batching.
	05095313f5c30a2fc20e1b188f78398c7a717863:strip=contrib/pyln-testing/:scrub-stamps	# lightningd: listsendpays always has groupid.
	f52ff07558709bd1f7ed0cdca65c891d80b1a785:strip=plugins/autoclean	# lightningd: allow delpay to delete a specific payment.
	939a7b2b1881a0658ee9f9711cf6b808aedc9f29	# db/postgres: avoid memleak.
#	e0218841c26015322b6a223894d8b2742af26b4d	# db: set now-unused channels.short_channel_id text column to NULL after migration
#	651753bbd57b4f02769f102aa3531271d90eb63a	# pytest: slow down test_autoclean.
#	c04de577abfa5bd4e2acfab0dd4f24c7373e22ae	# pyln-spec: update Makefile to use poetry for release, generate versions
#	264b4e02fa86e122c6a6d941a56db8ccfc57254d	# pyln-spec: update to latest spec.
	9b5bc81541e30e6a9bda98e15d5495ca77aff457	# onchaind/onchaind_wire.c duplicated in ONCHAIND_SRC
#	57002f3381a9aafbee4cce400cdb4b83430c0850	# pytest: fix flake in test_onchain_different_fees
#	9be6ed62360904e65e41c4a4fc6823f29ec59263	# pytest: fix flake in test_pay_disconnect
	45cdfd2ff75c8d0f73deb2a24c81575760619fce	# BOLT: update to fix gossip pruning quote.
	fe556d1ed9b11087ecfdfc86f00e9397c2db7973	# gossipd: don't try to upgrade ancient gossip_store.
	3817a690c9708b1873264582d66a39bdf358e0cc	# gossipd: actually validate gossip_store checksums at startup.
	6338758018ee5b199c56fbae8ffb09813d94dd6c	# gossmap: make API more robust against future changes.
	daa5269ea259a855dac282c17c83e0eff09821b5	# gossipd: bump gossip_store to indicate all channel_update have htlc_max.
	253b25522b4c0eb33064e0d35070d6148e053776	# BOLT: update to version which requires option_channel_htlc_max.
	bb49e1bea586991f6e4cedeb277c3aece2593b25	# common: assume htlc_maximum_msat, don't check bit any more.
	bfc21cbb55ac5b5a423ccf1e6144948594363ede	# gossipd: set no_forward bit on channel_update for private channels.
	0d94d2d269c760721a49d2e0c8951371e9a435c2	# gossipd: batch outpoints spent, add block height.
#	f0fa42bd7370c9ee9a7b6e1d34d6bc824cc65a2e	# lnprototest: update gossip test including 12 blocks delay
	a1f62ba0e70b28ea82862aebc8ff776850073df2:strip=tests/	# gossipd: don't close non-local channels immediately, add 12 block delay.
	f53155d93b5eef9f4353c68e623cd54134aa7e2b	# BOLT: update to clarify HTLC tx amount calculation.
#	3f5ff0c148b33433b8a7a8db56d3caee363d17dd	# doc/GOSSIP_STORE.md: document the gossip_store file format.
	8898511cf6b6612bb15127bc7c8e54aa551517ce	# cln-plugin: Defer binding the plugin state until after configuring
	064a5a69406d8d44e005c94e914126626d1bf460	# cln-plugin: Add log filtering support
	e1fc88ff700aeae3123e6bbc9d8152562788f86e	# cln-plugin: Prep the logging payload in a let
	b13ab8de3ae21fd22d09dcfb3ac6a2999764b2ba:resolve-conflicts	# msggen: Use owned versions to convert from cln-rpc to cln-grpc
#	437ae11610fda83f26d56a87669ea650ab185c99	# pytest: Configure the plugin logging to debug
	b698a5a5ef4acb8d90aec0f6dccc52fb6c37afb2	# channeld: send error, not warning, if peer has old commitment number.
	6e86fa92206eb6e935a8dcba37b9e7849d2cc816:strip=tests/	# lightningd: figure out optimal channel *before* forward_htlc hook.
#	a7ce03bae6cd763e7796f7b961d40a83a7e64a4a	# The project is called Core Lightning
#	87bab2b85138bf99a29bb9b881d110e90e3a4e88	# Add ConfigurationDirectory
	7046252f96c0436500a1b45c379a6aab56ee9612	# Impl `std::error::Error` for `RpcError` to make it anyhow compatible
	10917743fe3fedd9d00b69ef1fa42d47989955ae	# Implement a typed version of `call` to avoid useless matching
	e272c93a88c7302dad026dbe06627a569487a25c	# Use `bitcoin_hashes` for `Sha256`
	b4b0b479ac1c60111a4eadda6a3b68f158f5f11c	# Use `secp256k1` for public key type
	09dfe3931dd0d14707b52d2b2f0189da3b5c0270	# Make eligible types `Copy`
	6abcb181457d1b52da8374ca714ff8ff0ba354c7	# Add basic arithmetic to `Amount` type
#	657b315f1cb3c25c981d0cc9ca367a96ec547e09	# pyln: Bump versions to v0.12.1
#	9023bd9334c16cc66d3731aa31f57818971d3fdc	# pytest: add test for migrations upgrade which breaks 'fees_collected_msat'.
#	cafa1a8c65117833d70cf7a1f000b41605abe1f6	# db: correctly migrate forwards for closed incoming channels.
#	6eac8dfe3c70c3b7b94cce434807b8b7fed9a920	# delforward: tally up deleted forwards so that getinfo's `fees_collected_msat` doesn't change.
#	68f15f17bb35919ca6a32f3cc95041008135c8a9	# delforward: allow deletion of "unknown in_htlc_id" and fix autoclean to use it.
#	695f0011619d758dc53b2c6463ca08d246327edb	# pytest: fix flake in test_zeroconf_forward
#	d4ef20d54a7db05d96e4df8c0906dae475697218	# pytest: fix flake in test_gossip_persistence.
	836a2aa2616dff3bd78267d276c0902b26f7f33c:strip=contrib/pyln-testing/	# use msat_or_all for fundpsbt request amount
	1de4e4627623d488836cffc93537d124ec1487c0	# tests: add onion-test-vector from "BOLT 4: Remove legacy format, make var_onion_optin compulsory."
	c8ad9e18a9ff47dd047292ccc1b1a8a21e2a6712	# common/onion: remove all trace of legacy parsing.
	8771c863794d2774e93ea759f4eb23873a236112	# common/onion: expunge all trace of different onion styles.
	f00cc23f671643446577ee9c0da3e5b9a266fbc0	# sphinx: rename confusing functions, ensure valid payloads.
	6324980484cdfe68e5228a56b74ac60542dc46d7	# channeld: do not enforce max_accepted_htlcs on LOCAL in channel reinit
	51e243308761e056d0da23e596b7dfedbb909db1:strip=contrib/pyln-testing/	# Setchannel request is provided
	93b315756f80cbd9a112c0ca627243017c55213f	# schema: Add `enforcedelay` to `setchannel`
#	6adb1e0b4b419e723d53b1e54e16593f58656986	# pytest: Bypass schema verification for some RPC calls
	49fe1c8ed7aea1f109b4bcc4944ddcd0cc30117b	# lightningd: have `makesecret` take `hex` or `string` (just like `datastore`)
	342e330b565fd3326f8a046dfa2c0e63e8785c24:scrub-stamps	# doc: update references to old BOLTs repo.
	41ef85318d367c8e6f34df0749f2bc373c5451b8	# onionmessages: remove obsolete onion message parsing.
	2fbe0f59f1142f1c5ded0c5048c20b9398ddbb47	# plugins/fetchinvoice: remove obsolete string-based API.
	125b17b7fc570f57486a42e176cd48caa3492a94	# devtools: enhance bolt12-cli to convert to/from hex
	0195b41461dfedae09ca5cfdf8cd1abae8d4a174	# pytest: test that we don't change our payer_key calculation.
	c9d42d82795ef5b8846bfc37775d744bcf00f326	# bitcoin: add routine to check a Schnorr sig given a 33-byte pubkey.
	2749b1f61eaf9db789f63c91a2f0f65f7c80f79b	# common/onion: remove old blinded payment handling.
	22c8cfc3744b1cd868b24b4df2f1809f0c729be4	# channeld: remove onion objects.
	52be59587c5acc030dfa9a4079b217627e40d0cd:strip=contrib/pyln-testing/	# msggen: generate deprecated fields in rust.py
#	6aca9f665b580aa9ad2beed8ab10f511e56ac180	# devtools: Make fund_nodes compatible w/zsh
	335f52d1a8b002018270194654c9e53c5a65fa5d	# cln-rpc: implement from Secret to slice conversion
#	e7e7a7186f7b2ae145f756a757d576b7ac0c51e1	# tests/test_misc.py: Check if funds are getting recovered on reconnecting... Changelog-None: Increasing test scope
	e855ac2f9e6453913df64602b680b3644d847a6c	# keysend: just strip even unknown fields.
#	a99509db36188bac5b8008e6005404cc96dd29ab	# py: Update protobuf dependency to silence dependabot
#	2136d5912f08dd8dd5589844de45dbc919220089	# update package dependencies for Alpine Linux
#	74652f7cf45e93df57b24ba67a5516863f492199	# move alpine build dependencies to virtual package
#	f0d81f46f09a917af2d66981f8fb586ba239d4ce	# Clean up Dockerfile.alpine
#	1f5e579f1b3d03eee9f307f1880875cc0b6786c2	# docker: Clean up dependencies for alpine build
#	0acdc911a5c9b65f50aa10977ac1db5a0f6ee37e	# docker: Build the alpine docker image from a clone
#	6fb653ef9709e5e46042432f461b7efb8593be84	# docker: Separate builder from runner stage in alpine docker image
#	62bfed9a8df8731be44ba4e86afb08a5d28a4442	# docker: Add bitcoin-cli to the alpine dockerfile
	1c5edc14a5cb74420e711273b9cfbb4e60c763d5	# bitcoin: add test for to/from wiring a bitcoin tx w/ scriptsig data
	49ed0a4b9e9a11bade7d84fc7e9a4f8135ee5d67	# psbt: wipe global tx scriptSig/witness data after saved to PSBT
#	d2633d3e6d56bf4594910cffad5b05fe583f72e5	# pytest: fix flake in test_emergencyrecover
#	7c7c4c4cb3143011487430fe48781a00891a96b7	# zlib 1.2.12 yanked, update to 1.2.13 in Dockerfile
	250b190e5fefd7dfa65ffb0467c0df242be6fbd2	# chainparams/dual-open: set max_supply; use for max on wumbo channels
	8d864d22991668a90c573a4cf80c6436944e0982	# funder: we always pass in channel_max, no need to special case it
	fa987f23446740987bcf158f49c6732867a9ecaa	# df: put requested_lease onto state, so it persists
	00d3e3e492ed1be204fa4b14f79dda065bcd3c63	# df: for rbfs, since we know what they asked for, we can abort
	d3066ab7f9a16fcb39c12884b77f6415f91642a6	# openchannel2: may re-use rates
	85039d4f4efd2939b17036183b3bfecc199c7a12	# df: pass lease data back to funder for rbfs
#	dc9e79c4458a99798e3f8fd9115aba61cc49ccec	# funder: rm quote that makes nifty cringe every time she sees it
	a5e9035e2ef065bd483c1cb7e9dab9a0e07e18f6	# funder: save utxos of signed txs to datastore
	7733c2b0f490d53b24516dd88d2a23dba9024010	# funder: pull out previous input list from datastore on RBF
	45acc20a8de1d8833f28f102469ad1a9cd764c93	# funder: use previous outputs in count towards available funding
	38e2428f12af69bbd9af145d969eaca6c6ade99f	# funder: use utxopsbt to build psbt for RBFs
	efd096dc96f156b6b223be4f32c638bf3fc7ab64	# funder: filter prev-outs such that we only use still unspent ones
	e00857827fd5b45a3022753edf855df4765a4e93	# funder: cleanup datastore on state-change/channel failure
	fee9a7ce04bb20c8e77e3d01a190e636156007aa	# hsmd: introduce a simple API versioning scheme.
	987adb97180848908ec54ff43d3b564f1a40c45a	# Makefile: check that hsm_version.h changes if wire/hsmd_wire.csv contents does
	bed905a394dee7f7584628b6389b3f202fd0112b	# lightningd: use 33 byte pubkeys internally.
	4e39b3ff3dfa2e552b0c0bfabee2853e4a38248e	# hsmd: don't use point32 for bolt12, but use pubkeys (though still always 02)
	7745513c5106fa1cc5ea568527594b96e4ff3d52	# bolt12: change our payer_key calculation.
	82d98e4b9696093c19bf040b4b298f7a24dadaa1	# gossmap: move gossmap_guess_node_id to pay plugin.
	eac8401f8486b7d61252831bc0bccdfb41c43896	# Makefile: separate bolt12 wireobjects
	e30ea91908c58018f775a92179d150a0f2f6d71a:strip=tests/:scrub-stamps	# BOLTs: update to more recent bolt12 spec.
	1cdf21678e00897ea288907c051c124d11bf66ae:scrub-stamps	# offers: print out more details, fix up schema for decode of blinded paths.
	662c6931f3b44c5f21f8a05f8ef911cdf952fd92	# Remove point32.
	56939295de342d4b8a887e2eefcf46336c0a6107	# wire: add latest Route Blinding htlc fields from https://github.com/lightning/bolts/pull/765
	1d4f1a5199334ef81c26a04a980279c6083f662e	# common: remove old route-blinding-override test, update route-blinding test for new vectors.
	85baca56c6d0119b7c65ed92d5d30006d14ce99a	# channeld: don't calculate blinding shared secret, let lightningd do it.
	53e40c4380df362ac2fe6b7107d011898e26eca2	# common/blindedpath: generalize routines.
	c0ae2394d85da90e565450aa56dbe208e3dd02ae	# common/blindedpath: generalize construction routines.
	c94c742e581f767e16f5c7f41afe4c82873a2cb5	# common/features: understand the route_blinding feature (feature 24)
	077ec99788447c2c234bd60ac017376d5ea422fe	# common/onion: blinded payment support.
	21e7c3432e8d2c7f1efdf8ed6cde8722ea3d5852	# common/onion: enforce payment constraints.
	325fe2e04c7cac629b2cb566ab4466cef7da5bc6	# common/onion: cleanup by removing unnecessary local temporary.
	511e8e6477f8a81c31c0365ef01e6215ded6919d	# common/blindedpay: routines to construct a blinded payment.
	426886ff9b1bb13b6505c68b12b452745e421b36	# lightningd: return invalid_onon_blinding for any blinded payment error.
	8eee5dd7fd624c2c7b4c8b0416dc268e9b8a9de0	# channeld, lightningd: allow blinded payments with !EXPERIMENTAL_FEATURES.
	67b8fadf029c6df594776b8c2cdbf6c205df07a7	# common/test: check we meet bolt04/onion-route-blinding-test.json
	5cf86a1a2ed1c93bffdc182ca984c5b57c197304	# common: update to latest onion message spec.
	159fc7d1a22bd02eeca286ed8abccbd1db04cb09	# common/onion_message_parse: generic routine for parsing onion messages.
	422e68a4d6aa0e8a2095f1fb06eb254bb17c8fbf	# common/blindedpath: create onion mesage test vectors.
	f158b529d3e4c56b70c44aaebc821c1f15477fa2	# wire/Makefile: fix missing wire/bolt12_exp_wiregen.c in ALL_C_SOURCES.
	83beaa5396acd15874311bce4b01431e583a6113	# json: Add helper for quoted numbers
	8a4f44a58dd0f0514f9b05c8089cb5ac6f16f3a4	# keysend: Allow quoted numbers in `extratlvs`
	93c95056a31f8138cb036a35091dc9db04206c9b	# rs: Fix two small regressions
	1a1c0a38fc9d45b40d0a90afd2f41bdf766b575d:strip=contrib/pyln-testing/	# msggen: Map the `extratlvs` field of `keysend`
	87616b7ffc44d18d218edb32bc168f7e6ceae887	# mkfunding: add missing common_setup
	7bd0d7641cfd1aab738f6d9ed1aa202daf0c6dae	# mkfunding: no scriptPubKey on utxo causing crash, so we add one
#	8f549bfccae57a378cc726a073222882531293c1	# doc: add `make install` line for macOS instructions
#	62e44e6bc8114524cbad7d5f7812ec7c34debabf	# doc: Move M1 instructions install to its own section
#	76623b2ef2205cab63e5a84f0dbf12c4379e300e	# Collaborative transaction building
	f111d6772dfdf071af9f2cade05259e630dd3d90	# Plugin config options with no defaults
#	2605e117c9655a2d0241f6935ea35c8327d60703	# pytest: Add test for optional options in cln-plugin
	5bd6c715e5939314db6503724c03b209d03a2309	# gossipd: ensure old private channel updates are properly deleted
#	8f484069855a8975613e59730d49d84654d4a35e	# pytest: test for gossip store corruption by private channel updates
	0d756ff017afa0eee577990e07247772d7f29221	# gossipd: Cleanup channel update replacement logic
#	b1b280d10b6972ddb0a784da36deccabcccc15e9	# reckless: new tool to manage lightningd plugins
#	7e8a889d895ed4244304756b2e77dfaae0b699cb	# reckless: it turns out the warning is a bit much.
#	83dd431cdcb71955f85f761fcd27dcb39626b4fc	# reckless: use the lightning path when invoking lightning-cli
#	f18c5e320d3388c6a277bd88233edf875365be1a	# reckless: detect pip3 or pip
#	651c5b6de039e9cc92be48c7c4d277932d5ca665	# reckless: use config that was explicitly passed to lightningd
#	f3934cda5083f75ce56c06a40453074536f961f9	# reckless: use argparse subparsers
#	791e521179636fd2832ff0ef656bae267bf83eea	# reckless: update help alias
#	5d23c7ab0bbbbf72c021a1587fff2c9b7a8131b2	# reckless: raise exception or early termination instead of returning None
#	24422e9f7cb2f11c410f482eac34ef07784e3055	# reckless: add type hints
#	df98c8b92702758a0648e4876f20c25c20b671e2	# reckless: refactor argument list handling.
#	71351ceacf385a50f2ee26ca0a116df7983e698a	# reckless: replace os.path with pathlib operations
#	4a95a4c7da6c773a8b7cfd06c139179c02d86c32	# reckless: multiline string style cleanup
#	53ad1ee5761fb7f05958e68b0f5e035e47716563	# reckless: add function for lightning-cli calls
#	2f4e862863a760705ccdb56315a73898b978221f	# reckless: improve config file handling
#	e48fda1ba081399abba7b509061bba46f842bf47	# reckless: analyze repositories with urlparse
#	a728b042431c778fe38ad1127f43e8caa59cbf96	# Reckless: add man page
#	341d73fdc2585db65d6d86dd0bbf439afc143c1e	# reckless: fix git clone issue with removed dir
	75c382fe163df8f8b7feb7245922b1b83835cf30	# lightningd: --dev-onion-reply-length option.
#	fe1b285bba409ebf708572d97d186242364ba88b	# pytest: add test for generating non-standard length onion errors.
	a4c482dc072aa2905a6eca61679d613e3cb501e8:strip=tests/	# common/sphinx: don't use fixed lengths anywhere.
#	15112ae87bc74c1d3a1c95e9d0680acbadf26aae	# gci: Force MacOS CI Job to use python 3.10
	3c75770586ec9123889d126f6bc05d3563d55ee0	# common/json_filter: routines for json filtering.
	508a170598952701a88739c47bc6662d065697c8	# common/json_filter: routine to turn "filter" JSON into a filter.
#	22c42de6f134ca35682774f458a46db160f43234	# tests/fuzz: don't pull in JSON common at all.
	f0731d2ca11ee647566bd6fc11809c9519252cf8	# common/json_stream: support filtering don't print fields not allowed.
	3b4c1968a3d9b5333c31d253f3d1d951b25506e0	# common/test: add unit tests for JSON filtering.
	2a14afbf216f5964e01a1c347e798461bb3ffe2c	# lightningd: set filter when we see 'filter' object.
	1436ad334d59612bc3f1e323023724d793b24e59	# pytest: add filter tests.
	b6134303d467becc58136d30fc9ddf06f93fc50c	# pyln: add context manager to simpify filter use.
	cb1156cd328f31e068e09afe0667784ec21a1077	# libplugin: support filters.
	c31fb99d2d705dfa793c0aa45f860cf5af67b7cb	# doc: add lightingd-rpc documentation.
	ae3550cb00c3a8539a58d5d272d921c748da2ac5	# lightning-cli: support --filter parameter.
#	d60dbba43bf2dd69360aa9b98bddcee3952ab984	# tests: test for coinbase wallet spend.
#	26f5dcd2a5af21ca9a902084872014566497058b	#  wallet: mark coinbase outputs as 'immature' until spendable
#	adf14151fa868763d7b4ff05032cf45f3115312f	# wallet: Use boolean to determine whether an output is coinbase
#	eb122827f6c82ae2fa1852309b53a511b7397706	# wallet: Add utxo_is_immature helper
	2760490d5d4fcc20f6b404fc90807ed756d7114d	# common: catch up on latest routeblinding spec.
	987df688ed4aca0d806e2da179b4c69386b3ace2	# lightningd: don't return normal errors on blinded path entry, either.
	c5656ec90a788b87280b910ecc7aa664986f960d	# common/onion: handle payment by node_id.
	8720bbedae855e33aadd0d515ab84203f1e657ec	# common/onion: split into decode and encode routines.
	01a47720c3472237b3000110c209b88bf095827d	# plugins/libplugin-pay: hack in blinded path support.
	4cfd972407a6ff1c15e5c978ba72c43418795351	# common/blindedpath: expose API at a lower level.
	5becfa6ee18127030e86aa26ed1fca2de7a871ee	# onion_message: don't use general secret, use per-message secret.
	85cb302b657133c2ab20473460b2ebae7ea7f33f	# invoice: invert check to reduce indentation.
	a5471a405b44fc46365b9a3980049898436adad7	# lightningd: temporarily ignore missing payment_secret for bolt12.
	595fbd2a19abe2c98ba66a34fe65fd214122bc40	# createinvoice: make a minimal blinded "path" in bolt12 invoice if none presented.
	c6f50220e1640aa9358ebc73152e9cac5b8919ce	# common/onion_decode: put the path_id into onion_payload->payment_secret.
	4bc10579e6b816f0ce8599e26e5e7936c88f345d	# listincoming: add htlc_min_msat, public and peer_features fields.
	744605997ea63e64c657e93d3409a0ef55ed8b9a	# offers: monitor blockheight.
	c2c9f45dacc6b868f204361781af2cf89dd06aee	# offers: create a real blinded path, if necessary.
	aa73878831157bd7bd23620bb885c46338045d26	# common/bolt12: add code to generate offer_id, extract parts of streams.
	6e755d6fe860277233312f44577006be3e5b5142	# common/bolt12: code to initialize invreqs from offers, invs from invreqs.
	9a0d2040d34d20722accaa5daf20e5c907922eb9	# common/features: add explicit bolt12 feature sets.
	3afa5077fe705bd917de1c4b9c9f8bfa5f53b7b2:scrub-stamps	# offers: make them always unsigned.
	846a520bc238c9011a2e7acbe30561ffe4e10f29	# offers: remove 'send-invoice' offers support.
	1e3cb015469088880e7976647fd5625598434c5e:strip=tests/:scrub-stamps	# bolt12: import the latest spec, update to fit.
	505356145b90c2989ba79d9f020a878cab0ad743	# bolt12: update to modern signature scheme.
	fdb3d9186abfd843c531d2d36aabee71e98f23d9	# devtools/bolt12-cli: fix decode to understand modern fields.
	ef2f4a06485a5b06ad7a1521a95510aad8096c2d:strip='\(contrib/pyln-testing/\|tests/\)':scrub-stamps	# bolt12: use spec field names, update decode API.
	bc283cecf292606f491cb93cda94a34366fe7354:scrub-stamps	# decode: print unknown fields in bolt12 strings.
	1d1174c2861e044b993e9f33bc7e62b3b9b1b527	# offers: use existing copied fields.
	179f573e456a10312ea0319f565fa172e82e26fc	# lightningd/invoice.c, plugins/fetchinvoice.c: use tlv_make_fields() instead of towire/fromwire hack.
	891cef7b2b3981a1893866180ac5e13dcbd369f1	# bolt12: routines to hash the invreq parts.
#	02d74542260b18c1c2b2b5a142be50e4aceee947	# db: add invoicerequests table.
#	79067704897de01c750c1eee22ab9e6e0d7587cf	# lightningd: add "savetodb" argument to createinvoicerequest, add listinvoicerequests/disableinvoicerequest
#	37bc4603b8c088eecd67863071157e3729d90470	# lightningd: re-add 'offerout' functionality, as 'invoicerequest'.
#	8a217f13cf7555f610802d0d7432b7bf4081169a	# bolt12: update comments to match latest spec.
	2e4a58efac38ae2184abe263cd7a5cdcd32e6753	# check: fix warnings from shellcheck 0.8.0
#	36b4457c0410b5d9af007897dd35d76b1a813967	# reckless: Use urllib3 instead of requests
#	f1c2f811b7259feb74c5362551533196e7c32e70	# reckless: avoid changing directory during install
#	fd52e260f04bfacda3f1e7dd64234a0d6994fe2b	# reckless: neaten path conversions
#	77b7a74cd63213ffd2cf86a52e59c84da266cade	# reckless: Replace urllib3 with urllib
#	7b12d3eb6019da5f21ce3043e30d4f09f15698cc	# reckless: Replace custom logging with the logging crate
	5cbd5220d9bfa5d983210b587608eeecf2ddf926	# onchain: Document how the expected witness weight for the close tx
	832b2e5e2e045e2b749acd215125241563848edb	# onchaind: Adjust witness weight estimate to be more conservative
#	d45b13df56313df2bb59150c240ca3e6210e1a63	# lightningd.service: note that the hardening setting seems to break node.js plugins
#	5a08691ffceabdb2c69a5764d1b63458876af392	# meta: Add version v22.11rc1 changelog
#	d4ead536529cd297705e12a4178e4956f13b7637	# pyln: Bump versions
#	08cbdaf84f2f5862aa94c2e59d00f44490bf8877	# add some stuff to gitignores
	5e76c74622efe3dfdc6dc8fc416fb9ee31ad989a	# tools/generate_wire.py: don't declare unused for variable.
	d94b715bcfd02abbcceba8196dd2b89aa9ff7ff1	# wallet/wallet.c: don't declare unused variable.
#	9e41754e7d23f7e79e58ebdd7170889aaacd902d	# wallet: fix typo in debug message.
	f2291c44d65fde0dc6a370b5483d80ac81f016ec	# onchaind: cap RBF penalty fee for testnet/regtest
	c7ff3c4288d60a0b76a8747a197b33d04a827a6c	# ld: Do not blindly add rebroadcasts to outgoing_tx set
	351b8999c997c1add5aee81722501129cdd7e51a	# ld: Add an outgoing_txs_map htable to avoid costly lookups
	d27591ff543bc65b4abeee41965698354293f703	# ld: Replace list of outgoing_txs with a hash table
	6518f6f26ab61ec33a796e57125ca8bad4b6c632	# make: Make the Makefile make 4.4 compatible
#	00dc0f082e427871434fdd9196c948d9997a048a	# make: Fix external/lowdown clean targets
	4f5ab638df51d181e4e25747dd5ff00e6301ba59	# grpc: Add the experimental optional flag to protoc
	9481fb8815b60a021e0df2a144e0f415177bf1d6	# msggen: Be less magic in detecting the repo root
#	d2dae46de95a5e20848357127a878299690d9b59	# docker: Fix the dockerfile
	2e270ea7d33034857f5c989fb7b2e14d8bc42c8e	# rs: Bump cln crate versions to 0.1.1
#	94928de479237b83e90504a2807b7426faeaabfa	# meta: Update CHANGELOG for release candidate v22.11rc2
#	b1f50c825f9a81c15d26bf82fbfe2cc7d0f0999a	# doc: document how to construct JSON ids in modern plugins and utilities.
	24651f57adc773f3a3b1470181023c9187686a99	# plugins: set non_numeric_ids flag based on getmanifest `nonnumericids` field.
	d5ce5cbab302fcc3f88e78a4c3132705d3cc7867	# lightningd: only use non-numeric JSON ids if plugin says we can.
	ece77840f906bba94d77889d651dd39208c9127d	# pyln-client, libplugin, rust cln-plugin: explicitly flag that we allow non-numeric JSON ids.
#	02f9c2df249c342a282e47179e643471cdf9cd77	# autoclean: Fix a null-pointer derefence when checking HTLC age
#	64aa42e85b08ef097efac1b5ee1b5c2f9f30a63f	# doc: Add a readme to the `cln-grpc` proxy
#	47e9e3d399c89085a6c31542babd4fd52eeb3b79	# CHANGELOG.md: order into a more user-first ordering.
#	8ebde4574d66c9d94f82280209486ca5f1cd6a6d	# CHANGELOG.md: include the v0.12.1 CHANGELOG entries!
	db62d542e10baa2c20c1447cbf1fdd496a5b8e48	# cln-plugin: Make the configuration in `init` public
	3d311c96b1ffe5351dde9b9025853b3efaa4f982	# cln-plugin: Adjust visibility of some internals
	626998efce3b0c73c2aa4a0241b9c816bf4ba21b	# lightningd: don't timeout plugins if init is slow!
#	22798b80b3e8e35568c8ce890d1d29c4c8528def	# meta: Adjust changelog for v22.11rc3
#	dfb963e2494bb1003b268193ad79129112739f0d	# db: Backfill missing HTLC IDs in the forwards table
#	090facd79b857dd775af9e1c591cd7c2d5fcc215	# ci: Temporarily disable lnprototest tests
#	110ed3b1a935e845393ee6e632f91b44c785e505	# submod: Switch lnprototest to clone from github.com/rustyrussell/lnprototest
	19300de58fac880fb0ea3853eb63ea0668a21e3d	# lightningd: correctly exit when an important-plugin fails to start.
#	dbb38e2c7d142f7379922ea0db6177d42e9931c0	# docs: Add the `reckless` manpage to the readthedocs generation
	2064982006dfbe762e23d33c92e81d696d39a0a1	# lightningd: do not abort while parsing hsm pwd.
	15d0a8bec8336f07862a5be566bb5992f87094f9	# connectd: don't spam logs when we're under load.
#	b6555dccaf5671a8d24e75c5ee2f7e0ba11f08b1	# pytest: test for wumbo direct payments.
	3ca1c70c4439955d523467bac032622cce5105bd:strip=tests/	# lightningd: don't cap spendable_msat/receivable_msat for wumbo channels.
#	280b49a6771ed70ee421b2647c060409866086f4	# meta: Update changelog for v22.11 final
	d7cd3e1cb5614b3973e70884d463ed736fd4565b	# pyln: Fix an issue with the LightningConnection short-reading
	744d111ceaf3d32121b10370c7043dd0fa4bb6a1:resolve-conflicts	# doc: Create a blockreplace tool to update generated blocks in docs
	a31575ca0b5a6d53ac8c8ed949d3a8686e1f690c	# tools: Add multi-language support to blockreplace.py
#	4613b2981544addb2d5c3f1da409c4718b94bde1	# doc: document autoclean-once command.
#	24d7aad3d0ae16995056f489fbe675b7f01d75ff	# autoclean: fix uncleaned stats when we don't clean due to being too new.
	9751502ff5382dc0bc77d46fcff29a13419ef4fd	# jsonrpc: fix error when we abort batching due to timeout.
#	3f2e923e81eff637c7b8ce586d795740807412a4	# reckless: fix verbose option
#	8653d1200fd27f8bf0edf9c8cf70c5cd7139900d	# reckless: avoid redundant include statement in config
#	70fc702ee483cf3a22efaf1c029dfad882423001	# reckless: further verbosity/squelch of pip output
	1d4f7f023de838b33ffe41a0b7f8ac3ab72ae6d0	# Revert "lightningd: always require "jsonrpc": "2.0"  in request."
	37590eeeb2ffbe6981d64078601f3592cd5b3a36	# common: fix arm32 compile breakage.
#	e778ebb9af5a6157a4b605a77f87b2c48b9d03b0	# wallet: only log broken if we have duplicate scids in channels.
#	a96ff3b097f10d44d938c3e3c7863e387b8927c7	# Update the contrib arm32v7 and arm64v8 dockerfiles
	29f81baac994597174da0122f427ccb2e6fb9caa	# wireaddr: is_dnsaddr allow underscore in hostname
	fb9d6684adc2e49828ff61e490fba348e0edeb00	# wireaddr: adds test for punycode
#	6af78c35df6dfcce7f282159f7f7b69c9b6c489e	# misc: Update cdecker's gpg key
	f0dd701bc5901e252db335675faeab857d886c32	# doc: document the usage of DNS hostnames
	0ae6f4d6fb1b96ab3f0e31c5987eeb299ee175e1	# wireaddr: allow for UpperCase DNS names
	ec025344cc03140f18161cf3ce38e0c9e18c7695:scrub-stamps	# lightningd: don't announce names as DNS by default.
	2ed10196d092d7aba22a700b0f26d248d04c36f7	# build(deps): bump secp256k1 from 0.22.1 to 0.22.2
#	b3a1d01e51f913cff5fe68f4c79caa0bc9933f16	# meta: Add changelog for hotfix release v22.11.1
#	41987ed379093b4bd61db9907b130d2f0279252f	# doc: check-manpages: add check for unescaped underscores
	09d52b3cb4f5930036a5d4b6b32525fe6d4d917f:strip='.*\b\(delforward\|reckless\)':resolve-conflicts	# doc: escape more naughty underscores
	31732f7825ab59878cb4704bc2a7b5384cf9c2a0:strip='.*\b\(autoclean\|delforward\)':scrub-stamps:resolve-conflicts	# fromschema.py: escape underscores in descriptions
#	4d64374b857e97b4e1c3cc6ea068e5f3fca7e238	# doc: drive-by spelling corrections
#	48cfc437c052c030d9f00aba00109dc76fc422a6	# docs: remove the table inside the reoribuild docs
#	df2999045415c4786141bd3a6302bbcd586a8905	# docs: fix typo
	28b7c704dcf8ddc0c3545371acd5f2eee6eb3c9c	# add reserve to the fundchannel docs
#	80dacd183e6f8050595e661a33d5313118349501	# doc: replace deprecated parameter keyword "msatoshi" with "amount_msat"
#	2afe7a1856b04177898e2dea6b1050d4c8477d87	# pay: remove description_hash without description.
#	418bb3cb3bc3c9d5b33ed12296de1e2e8b0a8a45	# invoice: expiry must be in seconds.
#	ae48c7b78d8a87b1c031a121d456f7bb99fb92df	# wallet: fundpsbt, utxopsbt reserve cannot be bool.
#	66bde4bd9f96b41b02bbc36c02c19579f7d054c4	# lightningd: only allow closing to native segwit
#	62333425c2fd62756bdf8e305a112d37b0c0e517	# sendpay: remove style `legacy` setting.
#	5b3746172f06c235892e3b1c5fbef50b9a9d8c68	# lightningd: remove `setchannelfee`.
	c79c9c73fcbf19f90d93d8ce7471d9340f17df46	# Properly raise ValueError message in wait_for
	3c8ec25a6f5caa0827fe13cc56176b6b17f82a4f:scrub-stamps	# dox: fix "sphinx-build -b html" warning: reference target not found
	93c966c649edbf7157845f287e4e73ccfdda7f09:scrub-stamps	# doc: sphinx-build fix external links (urls), language warning and broken footnote
	6939671a1b14f30a3ff8742d6891d4df725b6bdc	# Adds helper functions to cast Value variants
	68f3e3fba9b457e2d25063fe3efdde5655cf337f	# pyln: add datastore routines.
	7b24ea60e3ffba21ce5aa5f7620febaa3bcfeff1	# libplugin: more datastore helpers.
#	d1b5943e906d5c2822f0ac13e08d8e91922a0352	# tests: make test_libplugin use the datastore.
#	3b56e90a13a695c2142387728bb661037e520183	# Turn on logging for key topics in bitcoind for black box tests
	8e75232205499e584d35e30901ca17f045b379bf	# rs: Update outdated dependencies
	c5608897ad0d4f68b26d9f3c5153a8219d2d99fe	# rs: Remove unused dependency from cln-plugin -> cln-rpc
#	465d9121bff0f50564b0b03fc9e1eedd43cf3937	# rs: Bump crate versions for publication
#	f63ec151162798b41b625455f72bdd79bf5adebc	# ci: Unconditionally install `protoc`
#	3ae58c44291148506128132b2a74b62f34dd9f60	# ci: Add `protoc` compiler to setup
#	141c836b3956a79c7e740b16b129b7fdad3d3374	# doc: note that grpc needs the protobuf-compiler
	6c1e589ee803ee3c37b8e1a2d81b2fde39007b45	# cln-plugin: make available the configuration in plugin
	77ad5525f5b2282466a6bd39328072cfe06a11f2	# cln-plugin: Re-export anyhow::anyhow macro
	b6d334de1da9f573c2938a4388e60dc3b2ab6b7a	# rs: Update cargo dependencies
#	09a96739b3c97ed1e9930c4a60254ceea6edccc3	# Fix link to github.com/lightningd/plugins not clickable in README
	6f4601041747e218629e56199dc26a8581b37397	# pyln-client: make Millisatoshi comparable to int
#	65170be5b4527dfaff2362de9690cc182e436ec2	# Update release tag
#	af502eb625b51a4b8ced54722fa66f79d29ab45d	# pytest: adds test for msat to int comparison
	845503f72ecd4ee72dd32a8350cea397c0b78fab	# db: Fix the ordering of `channel_htlcs` in postgres
#	89534f749a617a8434018a1bc469b4424cfad2b9	# rs: Add cln-rpc metadata
#	dd8fafd8345184961908c99e29fe936e678c3e29	# rs: Add cln-grpc metadata
#	5a4c8402a718b0fb207f06f4810091c394cf20f7	# rs: Add cln-plugin metadata
	22eac967502bc465cb63bfcf337e23e552ec0465	# connectd: don't ask DNS seeds for addresses on every reconnect.
	9d5eab1b69d3d6ae23bf5d1350af65400afb4fed	# topology: fix memleak in listchannels
	42e038b9ad876a945a6a4eb5584ef8bd1b0b7c27	# lightningd: Look for channels by alias when finding channels
	241cd8d0124960d015ea89425d3f5e01faa5318c:strip=contrib/pyln-testing/	# generate composite fields in grpc
#	f3f5d8db17c3ca20bd65a6bd7eb3637fbb7d7394	# git: Mark node_pb2.py as text so we can see changes
	50adcf10289c756c3b138c95853df7fa5730f4d4	# remove unnecessary CPU_TO_LE32
#	87a0cb16032e8cfeca249e5ff04439238ae5d943	# Replace head -n with sort -R for better random peer selection
	a6db22ece213038ff7d7bc5177ff773f458c8ec5	# cli: fix buffer overflow in (currently unused!) code for progress bars.
#	4b98df186d117d6c7a1e0096a35a9640887a110b	# common: update comments documenting the use of param()
#	90956fa947745259c50f48ac1fd8fa0e77d84686	# change zlib download path
#	f918a04738604c4e5842b9a95cbb092c1ad49c5a	# unify the zlib version
#	d49aea376c28a3139e7c690d14729c0263420ba2	# doc: "--enable-experimental-features" hard-codes experimental-offers + experimental-onion-messages
	efd7a5868bb7fec2166050afdef8151695576503	# common/test: fix typo in bolt12 test vector generation.
	81213cafd72324ae3e317d395d53502077e72d6f	# doc: fix accept-htlc-tlv-types description
	85ce78f7386dfc328df8645eb44bc87627adf64e	# build(deps): bump tokio from 1.23.0 to 1.23.1
	879db694e117150c9498ef062eab62ac3d10c163:strip=contrib/pyln-testing/:scrub-stamps	# Ping request types are changed from number to u16
#	ddfdab12311161a6beec57c135274aa81802c56f	# doc: channel_state_changed has a timestamp field
#	9ed138f5e578ba96256ff3d3d69f01c8c4bc0d05	# pytest: add tests for devtools/mkfunding
	2d8fff6b57b2e604e997df9151098cce4edb30f2	# libplugin: don't turn non-string JSON ids into strings.
	a1e894a4455fc59c1818016d396fe0739493a8ce	# lightningd: treat JSON ids as direct tokens.
	435f8d84dca79aa48d753773baf3324543b78abc	# lightning-cli: fix error code on invalid options, document them.
	19db6a25e40c70fe7a95547d124dae4a0cfa155a	# commando: require that we have an `id` field in JSON request.
	b3fa4b932e1abe6f9cd2ab4709ac80ad8075f670	# commando: send `id` inside JSON request.
	0201e6977f285bd15d51aab536287ed699ec8d46	# commando: build ID of command based on the id they give us.
	b75ada701759773ce68ff3bc60094e11cc66b300	# commando: track incoming and outgoing JSON IDs.  Get upset if they don't match!
	1250806060e1067987b175b350c8ccbd96924818	# commando: correctly replace the `id` field in responses.
	3f0c5b985beb9771ed3673c3a675c8685c6aa62d	# commando: add filtering support.
	404e961bad774e37d09fa2c4ff09f01dde074e6e	# cli: add -c/--commando support.
#	3f8199bbfdb0ac1872bff55c3767b712bf13fa30	# doc: document that we should annotate added and deprecated schemas.
	b2148d0eabdf8e2ca8a1c62f829ec826ff8a0930:strip='.*\b\(autoclean\|delforward\)':scrub-stamps	# docs: handle "added": "version" and "deprecated": "version" from schemas.
	717cb03f51f0920e67cb4adcc0ac546a2cc9c3ec:scrub-stamps	# doc: add recent additions, fix annotation on listpeers to actually deprecate.
#	3a39c635b663cf9eb696ef6105de7b42bc903757	# CI: rough check that schema changes seem to mention added, don't delete non-deprcated.
#	66a4d500988dc989040dff984872d372b479ef5d	# tests: mark test as dev (times out otherwise)
#	42c6d490825d5be51501650d3f0b9fbb063b82d9	# tests: add account_id's and match by acct id, not test ordering
	da5eb03baef2f3d10e76226f1f64acefe9da46c5	# lightningd/chaintopology: ensure htables are always tal objects.
	763d02e42495be28618f203a2d884286a5e40024	# lightningd: ensure htlc htables are always tal objects.
	4a570c9419a1e9c04b687f40ab1a755abd042e86	# gossmap: ensure htables are always tal objects.
	81e57dce52c22e7e9bb00962214e3f7963be4ba3	# connectd: ensure htables are always tal objects.
	851cbf6c83a1d2792dbadd62db746bf28471e21c	# memleak: prepare for htable to be a tal object.
	4200371020844c24e97a363323959e1cea4c8d91	# gossipd: ensure htables are always tal objects.
	94e8ce030a5ca8649304153bc99d191ebc3260c0	# gossipd: use pointer to hash table for channels in node.
	3c4ce9e448aed2bb10086ff2822fc58256e683ba:resolve-conflicts	# plugins/pay: ensure htables are always tal objects.
	0d93841cc7c79d3fc92163d327486498acd4dd25	# plugins/command: ensure htables are always tal objects.
	f07e37018d61052f11ad2bf679a576fe183ccf39	# setup: make all htables use tal.
	5dfcd1578215fa98b7a7937dc48088384c60bf1a	# all: no longer need to call htable_clear to free htable contents.
	60441843233f80d74ae2337f2942a944abd3fcc9	# lightningd: don't call memcpy with NULL.
	300f732bbe7fe04a2ad800785584b5e8cdf5de4d	# proposal_meets_depth tracked output always has a proposal
	1d8b8995514b95846d74173d9317d6301694b04c	# lightningd: prepare internal json routines for listpeerchannels.
	6fa904b4fb19941a98d99f526300085df478338c:scrub-stamps	# lightningd: add listpeerchannels command
	cb5ee7e49caae35a3b825c942803e82201952151	# plugins: make bookkeeper use the new listpeerchannels command.
	57dcf68c0b97f1d7d553f420451481147283461b	# plugins/libplugin: flatten return from json_to_listpeers_result.
	5d5b9c6812f86646929e5655b2b211637d88f9a9	# libplugin: don't return unopened channels from json_to_listpeers_channels().
	ff2d7e6833201e82748932f41af5580aa956e878	# pay: use json_to_listpeers_channels() for local_channel_hints.
	a56c890ae5a7fba5f024d6f9afabf1c565069037	# plugins: use listpeerchannels instead of listpeers.
	c48856128242ba6995fc1327fe1b0f288995a7b3:scrub-stamps	# plugins/topology: use listpeerchannels.
#	f08d3516f7d5ecfb027f2d12f296163e1d29754f	# contrib/pyln-testing: use listpeerchannels.
#	1fa32333b9cf1f1aec52b8e1327735da47a1064e	# tests/utils.py: use listpeerchannels.
#	a2347c74526608e190c88dd1192deabf52b77455	# tests: use listpeerchannels.
#	9ffaab7d2245661b7c5c01f562f6aad3ea9d1fcf	# pytest: fix race in test_bookkeeping_closing_subsat_htlcs
	6c0b9b0c789a5bc024d62ab200f9456525f5e523:scrub-stamps	# lightningd: deprecate listpeers.channels
	f1373fd98ca0f2907d2f25434da344efb58a8e08:scrub-stamps	# doc: remove manual field descriptions from listpeerchannels(7).
	6b977f0292fc2026ce79fc4f25bbd13d6db5f64f	# cln-grpc: update listpeers json fixing tests
#	2b5f4d14d112d7eb755615c6f561298fd6aa0cd3	# CI: fix schema diff check.
	e5d384a427011eb70d4968932c5964b1c37dc403	# gossip: Do not send warnings if we fail to parse a `channel_update`
#	85fc46f76cf2f9577d338885b14d838d19d4b330	# pyln-testing: don't default openchannel and fundwallet to p2sh-segwit, use bech32.
#	2f36c033075dad335fba44a52d0da36573da09bf	# pytest: use bech32 addresses everywhere.
#	932ca9e91fb0d8ddcf69d18db0799f4e4fae6f94	# lightningd: deprecate p2sh-segwit addresses for `newaddr` `addresstype`
#	9d5841a0e66ae19ff493b9c991e9b00023e15356	# pytest: fix flake in tests/test_closing.py::test_closing_specified_destination
#	1fbf774e043ff4c17111027994154d05ccfdc58f	# gci: Split out the lnprototest from the larger CI run
#	8c075c4cdaef60d794bf0274ec4993b1d472ab5e	# gci: Stop uploading unit test results
#	a00190dce5bb97284dd0f0a90803949e3324f64b	# gci: Update Github Actions steps to their latest versions
#	4d668e76a0e028d1032b3da1471d43adc00bf141	# gci: Split out the stages better
#	6d67eb934dff4caf7cf367fe86d62af0b84e70f4	# py: Ignore missing whitespace after keyword for now
#	10abb620a8379faaa405188819ebc43724fb394b	# gci: Clone BOLTs repository in pre-build checks
#	69e37a886508451ba0ba19d070a4ed2e3677d50c	# gci: Re-add tests of pre-compiled binaries
#	a20540eb15eceebbe51ef5426024c5174c9bfb55	# ci: Add a testpack.tar target to tranfer artifacts between CI jobs
#	a650dcb26d22777b777a1147d388ecf01c1cd70c	# ci: Split the pre-flight checks into separate steps
#	e7ee40e9516da34335a1671e9f68be523e24e90e	# ci: Split out the unit tests
#	34f095407447f5018a72e5b35a8837b7da5de4e4	# ci: Automatically cancel CI runs if we push a new version to the PR
#	6fe63956785adfe1f4ab6b6e9180d994c5657585	# ci: Add bitcoind to integration test job
	bcc75b6e98c139e578bfa3dd7e85dc170f577559	# tests: Fix a small memory leak in the onion test vector tester
#	ca3053707f425356a84dca281c9972dbcabb207f	# ci: Build and test in ubuntu:22.04 and install lowdown
#	b40fd3efbd5ee42980c3f9352c5916de974847e4	# ci: Add gather step
#	e76618e2a6697f5a37789e1692a61be4669c2608	# ci: Use bzip2 and release to reduce artifact size
#	71b581da4d7057281b95543dbb75d874dba0245e	# make: Clean up duplicate cargo examples build rules
#	e17611c570267430007b7866c59b9b4a78eb18a0	# gci: Split out installation of elements and bitcoin into a script
#	383fca7d0ec82957f01786345614177436a4b328	# gci: Add an explicit name to the matrix for display
#	b0e3d483e6549ec37866a163a0c8602a16206815	# gci: Add a test for the postgres backend
#	e3a9bda301c9c83201a425ba0f96e551b5798e8c	# ci: Downgrade the upload-artifact action to v2.2.4
#	1f2179645420eceb1e457ab8d7c1e92d37c12eec	# gha: Temporarily disable `test_notify`
	288f5df8d11f225f0e1996f9092e3d1b8848c84f	# ccan: update to fix recent gcc "comparison will always evaluate as 'false'" warning
	8d825ef0b7f858ee6f6c77a5bab92417660642c3	# lightningd: fix valgrind reported leak when we exit early.
#	8f94e8b94315d17d9316146b5b3c5ae64184432f	# comm: make sure that our version check is reliable
	82c94330a55d5925d802df86d43bf44e779d2738	# add PartialEq to ShortChannelId
	acfb63e4bf19751167fbc69448f236ae413e690f	# channeld: remove dead HTLCs from htable and free them (eventually)
#	0faa8397c3d3a725070740d2fba1364d16295ac0	# wallet: add dependency on lightningd/ headers.
	6a95d3a25e1830a121176af7d1e048671dbee63a	# common: expose node_id_hash functions.
#	17aa047b17a69e502df4d9f843d88769f5a56d2c	# pytest: fix output order assumption in test_setchannel_all
	cfa632b0e94587dc41e6b4be143e7a8abdc09c04:resolve-conflicts	# lightningd: use hash map for peers instead of linked list.
	0e25d563296dfde424bca2c1914917d935d7235d	# lightningd: use a hash table for peer->dbid.
#	e932f05bc8b497a6a321bf94528103486e40b4e4	# ci: adds git fetch before doing schema checks
	bd75f8ea6c6e764830fc9b7a2c6230a172bb133a	# opts: adds the autobool on/off/auto feature
	3babbc52013de2fbe4021b4c29ea207afad41121	# opts: announce-addr-discovered on/off/auto switch
	ee046662a72e22d54a4f7f0a1ea4d654cd65d6a2:scrub-stamps	# doc: announce-addr-discovered config switch
#	a2b94f16f8acdee8993d6e289b3588933dee3591	# pytest: fix and adapt test_remote_addr_disabled
	30dea0a4312fc8bbbc22923856e22e949190fc10:scrub-stamps	# opts: deprecate --disable-ip-discovery switch
	34cfc93939d56e4009f10adc357807924669c58a	# cli: getinfo output to regard --ip-discovery
	ca9e3e4cc1df92e1f55f9c5b614e5383c033ac94	# opts: adds --announce-addr-discovered-port config option
	a62c74be7b6fc2e909554db30fc22fd6dc01378b:scrub-stamps	# doc: usage of --announce-addr-discovered-port option
#	1fb1e0eec4616153c8f48063443d9d16a84281d4	# pytest: test ip discovery for custom port
	d9fed06b900368e59f4d1f432b87d40fd28ce8d3	# common/bolt11: const cleanup, fix parsing errors.
	cbd0ef4192f1140c25ad39a5bd81a8ebb6bc9ef5	# common/bolt11: add pull_all helper for common case of entire field.
	fa4b61d13d19daba938cecae4d1d37de5958b3b3	# common/bolt11: convert to table-driven.
	182a9cdcb61fa388dd58d468c8981a67e882b6e6:resolve-conflicts	# cln-rpc: use serde rename instead of alias
#	9482e0619c005bb183e4d120844b9ade545fdd0a	# docker: Install protobuf-compiler for builder
	f29343d740c087e2b7c477386025b82c22341d82:resolve-conflicts	# hsmd: add hsmd_preapprove_invoice and check_preapproveinvoice pay modifier
	a4dc714cdcf409afcee24c540730ae3bc8bcf82c	# hsmd: add hsmd_preapprove_keysend and check_preapprovekeysend pay modifier
	7b2c5617c16dab22f94a51955b5bdea38f284a12	# hsmd: increase HSM_MAX_VERSION to 3
	13fe27c65f7be09ab7d1a105fabbadc6488ec609	# gossipd: Do not send warning when node_announcement parsing fails
	5958c9c3d64a1f713e1cf8f4e4f0abe289c7072f	# common/test: remove unused padding in bolt04/blinded-onion-message-onion-test.json
	da3506e6a0e63990b492a703af326c670e7b50c6	# wire: use correct number of update_add_tlvs blinding field.
	885506765e27ce798768454c14f57aec014e933a	# tools/check-bolt.c: don't leak open directory.
	d5c19b23d8df7a1bda149905485d44f125fb2f50	# common/onion_decode: put final flag in onion_payload.
	e9eb5f493be93efbe539c0f69d2df3b399cf511f	# common: update to latest route-blinding spec.
	8e630e7c5341b4ce4ec0ea3f8e26940145aa441f	# common/test: fix up name of test file to match latest version.
	9aefe3d40a399e2c1201a76af403d83d69517baa	# common: update to latest onion-message spec.
#	6eb7a4cbf2caf60aac9cc2f7264fc8fa93a66ff2	# plugins: update to match latest offers text.
	2dec805465fb3c812be5f6e4bd3c280d34bf53bf:scrub-stamps	# decode: fix handling of blinded_payinfo.
	a3ca3fb047fd79088dbaef5765786f28bab9c875	# common/bolt11: fix 32-bit compilation.
#	f2f05117aa7ecfe2a255d06a2c543a9c89010f36	# pytest: gossipd: test resumption of pruned channels
	ed4815527aba7a3d11bd9f33b441372edd56310e	# gossipd: avoid gossipd crash due to double freeing timer
	6bff10cd40a886594f16f3fe906ccc6bef7f567f	# gossip_store: add a flag for zombie entries
	1bae8cd28a30ff7762789901ed3f0c245cd99892	# gossipd: zombify inactive channels instead of pruning
#	98bfd23fff7d2be8096413209c4ff84a4e5739f3	# pytest: test_channel_resurrection now succeeds
	4b9cb7eb760849e4166307c2658f28379f60edd0:scrub-stamps	# doc: remove unused offerout schema.
	578f07540744d924f9d8f4907a22c20638a82cd9	# wallet: remove unused TX_ANNOTATION type in transaction_annotations table.
	611795beee1bdecbde9e7b8c17db96d0934346be:strip='.*\bpreapprove':scrub-stamps:resolve-conflicts	# listtransactions: get rid of per-tx type annotations.
	9ab488fc41ea5f57efbd2eccfd58511755938549:scrub-stamps	# plugins/topology: add direction field to listchannels.
	d6f46e237398bdedb4dd8b8410ce00439b0f5a62:scrub-stamps	# lightningd: fix type of listhtlcs payment_hash.
	83c690fe5f7b9312a4c29b1c045ce1facafd3e0b:scrub-stamps	# doc: fix listsendpays man page.
	0274d88bad83049ba9a4a2355ed6d88bb0f2f109	# common/gossip_store: clean up header.
	7e8b93daa1b2765373124bc660d94e070cc99815	# common/gossip_store: expose routine to read one header.
	153b7bf192942086f565127565b31f40635993be	# common/gossip_store: move subdaemon-only routines to connectd.
	eb6b8551d41ffcec8c98c89d39b47bfc6db50076:strip='.*\b\(autoclean\|delforward\|preapprove\)':scrub-stamps	# tools/fromschema.py: don't try to handle more complex cases.
	9589ea02402875b2dc8d0391c29975bc911765b7	# common: add routine to get double from JSON.
	fa127a40715f3361f86ca522490be6fbbb2f437c:scrub-stamps	# doc/schemas: remove unnecessary length restrictions.
	2c41c5d52d4e92f77d059ff30f4be6180f5cd3b3:scrub-stamps	# doc: use specific types in schema rather than "hex".
	24d86a85c3af99ee7408c3cedfb1b346ffb49dbb	# plugins/sql: initial commit of new plugin.
	260643157d902cfd7690c6efffb4b6fe6a528c06	# plugins/sql: create `struct column` to encode column details.
	c230291141a2ba74532bac6e134c36139147a134	# plugins/sql: rework to parse schemas.
	51ae7118f11cfca0697d46afb28b4ea00e50c884	# plugins/sql: make tables for non-object arrays.
	8a0ee5f56ef917c0569615654952daa5f7773dc0	# plugins/sql: add listpeerchannels support.
#	68370a203eea01d3248efcefba896e510de1f5d2	# pytest: perform more thorough testing.
	aa3a1131aa3a9d2a549a15b62f36241e91bdc3c6:strip=tests/	# plugins/sql: include the obvious indexes.
	9b08c4f25a0c9c7a574e0ebd7378c57c98119f19:strip=tests/	# plugins/sql: refresh listnodes and listchannels by monitoring the gossip_store.
	40fe893172ba27610409151667b474bbca699af6:scrub-stamps	# doc/schemas: fix old deprecations.
	20654ebd49f5e98b15cd94a130cf1fda21ade2a2:strip=tests/	# plugins/sql: pay attention to `deprecated` in schema.
	adb8de3e071ea06aea01f438cd406be44802a675	# plugins/sql: print out part of man page referring to schemas.
	14aac0769cf1d6a4105ca502e2a117010a8d8386:scrub-stamps	# doc: document the sql command.
	9a591277f5a3e2452c2ec3e075da2e5b1dc3b139:strip=tests/	# plugins/sql: allow some simple functions.
	d8320f015fc6f6b474941816873d91bada62fba9:strip=tests/:scrub-stamps	# plugins/sql: add bkpr-listaccountevents and bkpr-listincome support.
	0240c2493622a9d757d47fb24fac9cc48126816a:strip=tests/	# plugins/sql: listsqlschemas command to retrieve schemas.
	259dd2a652f28da01d77529ea787705c5ad94dbc	# doc: add examples for sql plugin.
	fea73680d70a97422c434ce8d9f03445cc9fd60c	# typo fixes found by @niftynei
	959678244caa56b1935ca9fa616009c532d75024	# doc: remove sections on litestream, .dump and vacuum into
	80250f9b60c984d886fec8867255c7ac6d08a903	# datastore: Add check for empty key array
	a9eb17adf95c216976aa004a5431a3d1be1db222	# db: catch postgres error on uninitialized database
	dcb9b4b8d157b6b2a609f3d82fac683d6c7f56a8	# make: fix make doc error
	18397c0b878eca2d540971204058d6bb14e42a56:scrub-stamps	# doc-schema: make address field in getinfo response required
#	12761c38e31fe37eccbf253ef5b26898fbb01c08	# libwally: update to cln_0.8.5_patch
	6176912683ef10e86c3fc119f6641f3a9d0ef56d	# plugins/pay: fix htlc_budget calc when we get temporary_channel_failure
	4502340daca76093634720ea23252801bbe73afc	# lightningd: flag false-positive memleak in lightningd
#	3dde1ca39923169a7b5df2e053b493f32142db71	# pyln-testing: fix wait_for_htlcs helper
	f87c7ed43951dfc0b63981ef99a97cd76fec99fb:strip=tests/	# plugins/sql: fix foreign keys.
#	38510202c4a34febd70b35c0e52c8afe4d3599d4	# pytest: fix flake in test_closing_simple when we mine too fast.
#	7c7e32b32436f1d85b647d3527f846ed3499ed5d	# tests: add Carl Dong's example exhaustive zeroconf channel pay test.
#	0cbd9e02de9fe32d1904d4737b2f3ada2f508339	# pytest: limit test_cln_sendpay_weirdness to only failures.
	ec8aab7cb2b3172841126be521aa525ca47ab4bc	# libplugin-pay: fix (transitory) memleak which memleak detection complains about.
	9e9686df207b7ebe9793d72e68358c8c0956465e:strip=tests/	# pay: specify the channel to send the first hop.
#	ff1d537b87b4116c85507e25768face686f7c474	# pytest: neaten test_cln_sendpay_weirdness, rename.
	6347ee73087734068197ab17036ecf9902d133bc	# lightningd: don't run more than one reconnect timer at once.
	ff0a63a0d7149100bff9c00ba5cf120e8daead7a	# valgrind-fix: patch valgrind error on log statement in pay plugin
	3efbc12706326d1b83c072484589d1b96806f7ba	# pyln-client: adds utils cln_parse_rpcversion
#	e8f9366a29de3514524675b9752ce6c329ad8069	# pytest: add test for using offers with allow-deprecated-apis=True
	35acdc112f1325b236942fc0fb331aea0123039f:strip=tests/	# offers: fix pay where we are using deprecated apis.
	ad249607d69443856d54813b7735bc22c7a1853e	# dual-fund: update extracted CSVs to latest bolt draft
	4da0d6230e5c81ea3c7d450397a9c9f7b7a4fed7	# dual-fund: update to latest, add in updates to rbf amounts
	db448df277928ee550a1454167dc41599f6b6c97	# dual-fund: on re-init, re-populate opener_funding/accepter_funding
#	976f6ef51ad32dac45e9e9b730dd9b3e0d7d4ad3	# df tests: use the amount from the logs to check for!
	46dc37dff113795b3d34bb3d5866f28642860ce1:resolve-conflicts	# openingd: pull out validation for shutdown script
	ef3f05b52ae40f84d8e9f601b2660917e9d0bd0a	# dual-fund: validate upfront shutdown using taproot + anchors
	ad1893f83f644ba4ae68703dd744bfe838510832	# opening: helper for anchor flagged, use in dualopend also
	efe66f96897ef4424ef0ce5fbb2922e5cc0f7b17	# dual-fund: check features to print (anchors not assumed)
	c9c367d770ac16065ebe95cc350578000d92c88e:strip=tests/	# dual-fund: remove anchor assumption for all dual-funded channels
	89f382cf399e2dbe9a5457a9aff1207d59e159ac	# dual-fund: only allow for liquidity ads if both nodes support anchors
	0b8ea2299a8812fa79573db79b40536c6dd1c91d	# connectd: patch valgrind error w/ buffers for error msgs
#	cbe38dd3506e0e56f360a63d8980c447881ac488	# tests: anchors is only EXPERIMENTAL_FEATURES
#	4fe8e1eccf41923c3eeb07bd61a39250ed2c9951	# tests: check that non-anchor opens can't use liquidity ads
	df4bd6287a7c06c24a7663ee5dda7d7a37667cd8	# dual-fund: patch in channel_type logic
#	314c021e2c182a50a9fa8d0f4333c2e19ee217a6	# test: restart node during rbf
#	4c467500012599bd0f3a6b712f6d0e6bebf66ad1	# dual-open-rbf: remember the requested lease amount btw restarts
	679a473f9a6cf36d729c16184e0bb40b1fd1267b	# fundpsbt: add option to filter out wrapped p2sh inputs
	35f12b4ca10a4387f8ad02322ff616600faff298:strip=tests/	# upgradewallet: JSONRPC call to update p2sh outputs to a native segwit
	278fa7a0a473b681a231b836d1d826a529feaa8c	# v2 opens: don't use p2sh inputs for v2 opens
	554cbf08c39cdbc68a977868f1101341acbb7aa0	# build(deps): bump tokio from 1.23.1 to 1.24.2
#	296cf181afef3c924b8512704c2c6876e175d2de	# Update CI to Bitcoin Core 24.0.1
#	72b83efc4b22b07a6ecf2647ee9df51bbfdbbcf0	# Use Python 3.7.8 Instead of 3.7.4 for macOS Install
#	091e8cefd1d25d836557424a777c1f3205edddeb	# Must Specify pip3 on macOS
#	57874574ae365316ecc797cb07a541471486c9be	# Add protobuf as a Dependency
#	0d1ee8d7f59d4f167aa81e372a42e829b5ea7519	# Need `sudo` for `make install`
#	f2cd635175f0bff4654fc13ee606f55d0e36f83a	# gci: Re-Add `TEST_NETWORK=liquid-regtest` to CI run
#	eee7ad3e1c1309364cdcdc9982f1d6e1d53bbfe4	# relax log check for test_closing_higherfee
	8315c7c906a0d54f2157009665d0b091d746dcbe	# lightningd: don't send channeld message to onchaind.
#	b375a35fa0296e830e0cd26d13e61376565f1bf4	# v2 open tests: don't drop connection when an openchannel fails
	96b3b40765905a6d76c7915f5d13bc473ba5f6aa	# lightningd: remove duplicate routine `fail_transient_delayreconnect`
	195a2cf44b45d0d3db463be6482ba6a00b76a7c2:strip='\(lightningd/test/run-invoice\|tests/\)'	# dual-open: use tx-abort instead of warning/errors
	ef4802f74be9c04db929dd372800d14b6e19bcc1	# df: echo back "tx-abort" when we receive 'tx-abort'
#	43420433829fb3f4ea5bf6ac52c9960dc7ee259b	# tests: de-flake test that was failing on cltv expiry
#	28b31c19dd67ad9709c9eee649298dbe08f0a8dd	# pytest: fix flake in test_bolt11_null_after_pay
	05ac74fc4450b93481619a50c80704d8fa070619	# connectd: keep array of our listening sockets.
	2209d0149f03caaf402817a5fdcdb5297aeef134	# connectd: add new start_shutdown message.
	456078150a204a3217aa5466007bc19595add19b	# lightningd: tell connectd we're shutting down.
	bcab3f7e8399608e66b6c181d684bcdd03d66a15	# Makefile: don't try to build sql plugin if there's no sqlite3 support.
#	d06c1871a962f3d90776f6c8b928500c12200d65	# pytest: fix flake in test_closing_disconnected_notify
#	e29fd2a8e26d655a7fb0f8b1c18092c2cdd787da	# SECURITY.md: Tell them to spam me, and include our GPG fingerprints.
	7b9f1b72c6d7e8a56e262b562e2b85c004ed2b98	# lightningd: don't print zero blockheight while we're syncing.
#	59ed23e6cf8fefc9680a7d4809765e8868b0b6ac	# make: Add doc/index.rst to generated files
	8369ca71b109f56290e6a6eb2e0cbd0ad7621407	# cli: accepts long paths as options
	f0b8544eba19feb55cc95769028f84271c736581	# doc: Correct `createinvoice`'s `invstring` description
	1dbc29b8c08241797b35b921728760be605abdf9:resolve-conflicts	# lightningd: Add `signinvoice` to sign a BOLT11 invoice.
	11227d37ba02d4e7d9fc95d89088f1e33a438ec4	# msggen: Enable SignInvoice
	dc4ae9deb4dfb7231974ce216fb290fa8911ff94:strip=contrib/pyln-testing/	# msggen: Regenerate for addition of SignInvoice
	eef0c087fc86c08bac0bde5187f5a0fd4d587e20:strip=tests/	# More accurate elements commitment tx size estimation
	640edf3955e441eba711fb3dc0817a7e0b89ae7a	# grpc: Silence a warning about `nonnumericids` being unused
	e5d57379274f7b027e43de36fcd542d8d1e759e0:strip=contrib/pyln-testing/	# grpc: Allow conversion code to use deprecated fields
	a418615b7f36c7c1fa9dc67447996559ad9033ab	# rpc: adds num_channels to listpeers
	e736c4d5f403032e3a668391020af7db0cdfe0a1:scrub-stamps	# doc: listpeers new attribute num_channels
#	30454ddf199e52edb4c7029212b746b5b58d4f75	# pytest: listpeers new attribute num_channels
	1e951a9479e4b2eddb35064570b594ffd34c3dfd	# mssgen: adds num_channels
	b67fde8106bf0185768a4887295a6755e42e4b43	# Fix 'extreme cases' logging of many commit timer failures
#	813401b2a6b811a5dfce08ec5d66565fea1fb4d7	# Update Bitcoin Core to 24.0.1 in other git ci locations
	739d3c7b472ec9c0748c01f4c6fdfb88566607ca	# v2 open: if flagged, check that all our inputs are confirmed
	3eecbaee4da4c3a798b0700ab81d1435176205e4	# tx_roles: allow to be serialized btw processes
#	f05d4500982c142a47f8ab2dd4bca257d42862d3	# df: persist channel open preference to database
#	9f53e3c7f5d2dd1b3d3df4af7967ce40134413b9	# df: wire up peer's "require-confirmed-inputs"
#	cea7fe3f0594df59c2ad4ddb1195ec70360d74a6	# df: push back psbt to validate iff peer requests confirmed inputs
#	0da2729ce609dc05724519971fc70ef39367fcdc	# df: for dryruns, inform on requires-confirmation value
#	abb50c462708599133b6e7e2872e3f9e36c9eabd	# df: reuse psbt validation for the psbts incoming from dualopend
#	442b479d2cd0c91f6fdc6df4861ca4a69d289fab	# df: add new config option for v2 opens `--require_confirmed_inputs`
#	fa80f15f85c0cde42395e9b6ed5f117a280f05f4	# dualopend: if required, validate inputs rcvd from peer
#	beec51791060279d676f339e2e09b8d0a05a42a4	# df: persist our setting to disk, read back to dualopend at reinit
#	3586559facd533679400948b47b9a326e708169d	# test (df): check 'require-confirmed-inputs' for v2 opens
	f465032f6fe56aed84327788c8f74a74c5f1fbb8	# rfc-dual-fund: update to latest spec for dual-funding
	c0cc285a0f9f694913cfca63f06940ab217863c9	# df: fetch both the first+second commitment point
	911700ff948a82a83f66624a9e37745fa669ebeb	# df: remove minimum witness weight for input calculations
	35d02a784bcc6085d34d80ffed4e5874783dc944	# df: remove static remote key dependency
	d6b553cfa0cf825b179d55e26a4c27c3ecfd3ae6	# lightningd: fix leak report from peer_connected.
	c0b898e8605d03ea1999cc26cda0e03f327385e5	# lightningd: don't access peer after free if it disconnects during peer_connected hook.
	d7bcac2ae740c87e40d4daa2aba754ed7d853dd3	# lightningd: allow sendcustommsg even if plugins are still processing peer_connected.
	5f481aaf96b0a0a0dc2a006daecc1ab7fecfb891	# wire: Add patch file for peer storage bkp
	5ef49143e053223af6583d627bb80c524429f9cd	# feature(PEER_STORAGE and YOUR_PEER_STORAGE) added in feature.c and internal message.
	66d98c327fa0614fef53b91cd35433ba591f2476	# peer_wire_is_internal helper.
	709ff01fd2cc5b91512252b9537f057993c9ee18	# connectd: make exception for peer storage msgs.
	93d03bf9e8516a160d38e279a0e0b2f0b3db2c40	# plugins/chanbackup: PLUGIN_RESTARTABLE to PLUGIN_STATIC...
	2b1867aca38456b63284215474b0f05859bcc490	# Plugins/chanbackup: Add featurebit Peerstrg and YourPeerStrg.
	ff777e3238af672ded4bd79046912aa4e0381f3c	# plugins/chanbackup: Define FILENAME globally (Good Manners)
	33f0c4ec0bd2a382461d70b4f3e5c047c04bb9f5	# plugins/chanbackup: use grab_file.
	01cafe478befbf92eaed45a0401653848637a360	# Plugins/chanbackup: Add SCB on CHANNELD_AWAITING_LOCKING stage
	d205f489bd178482756836cac513f2d1823be3cf	# Plugins/chanbackup: Add hook for receiving custommsg
	7affaff728bc6795e0159d0f91917d715dd2086e	# Plugins/chanbackup: Add hook for exchanging msgs on connect with a peer
	e637e843e7e0ab5a60e87f04bbf78d1e64989342	# Plugins/chanbackup: Add RPC for recovering from the latestscb received from peers.
#	fc382dd87e860f5b0f6fcfd1e3cdaffcf9efb1f6	# tests/test_misc.py: Add test_restorefrompeer.
	68d9b21aecde0ea03a4a2e02bd1456493a93042e	# plugins/chanbackup: switch to normal indentation.
	f1fed40ac295c6027f506de1b58600c8e6e859bb	# features: make name of peer storage features match spec.
	17c35819d84a0c0984c048777298dcb3d6d93565	# plugins/chanbackup: neaten a little.
	c60ea5bcbb268f6cc89c90961a683c21edaf5df4	# plugins/chanbackup: make get_file_data take ctx.
	a71bd3ea37dbcb4edf905b7c3f739ba40939c92f:strip=tests/:scrub-stamps	# options: create enable/disable option for peer storage.
	9c35f9c13a04ef4d6e529411c091567ca890f596:resolve-conflicts	# Implement conversion JSON->GRPC also for requests type
	21a8342289a8a8836b7043b7ae565cb8f4eebc39:resolve-conflicts	# Implement GRPC -> JSON conversions also for response types
	913f9da5a88a3eb4ebbb303a1669176f521c70f4	# cln-rpc: explicitly enumerate ChannelState enum
	510abb934ca21436b08e7b6bb2ef58dd38f8a07a:strip=contrib/pyln-testing/	# cln-grpc: add roundtrip tests for test_getinfo and test_listppers
#	ca1fa844588ea2416d0dad85e8680cc87fd8ce7a	# ignore sql binary plugin
	473c631ceb3594cb328cdff09f6537372d906d9d	# fix(grpc): add the num_channels field inside the tests
#	b7ab80963d9109f35acc1a440d08d5c6a53f024a	# ci: include rust tests inside the pre build checks
	49b3459be50f1d23b91260e8eec2be509f6a7dba:scrub-stamps	# lightningd: don't put old deprecated `local_msat` and `remote_msat` in listpeerchannels.
	ef51ae3c6dbd9c880d82ae11c94f405de2898e8c	# msggen: Enable SendCustomMsg
	b83a19164cbd8fd87c0b754b5acb55b44a6cbc75:strip=contrib/pyln-testing/	# msggen: Regenerate for addition of SendCustomMsg
#	b6a7532625b061a291cf87d0f317294a1d981aaf	# meta: Add changelog for 23.02rc1
	a610f28ad46beb7daccaa274c7ee0c0147616373	# add a log message when it is not possible upgrade the db
	822db6acc26f1a55a0a97bc485ec38ae40a49f40	# gossipd: don't resurrect deleted half_chans
	dd9400df992c4c08219b809b7e9cbdbd32bc9303:resolve-conflicts	# fix: compilation error on armv7l 32 bit
	70aee529037e074c4cd2f034b97536ec04103b3b:strip='\(tests/\|.*\bautoclean\)'	# libplugin: don't spew datastore errors to LOG_DEBUG.
	15a744be8c1b1314822dc95529dfae827f3ff28e	# commando: don't try putting an integer as the 'string' parameter to "datastore".
	9a77a995a89cacbfa68e79941307a51f48ca2ec6	# lightningd: unescape JSON strings for db.
#	698eb0408f3550e6360dabf9a4fcbf3c54b83f2d	# pytest: adds xfail test that shows datastore issues
#	1800139dbeace9d7de62b56aefd6075f224d2040	# meta: Add changelog for 23.02rc2
	2c7ceb8a21517a9374b8b14b361092ca0cae6e48	# peer storage: advertise features as optional
#	eea4781606cfe7387bb9a594a9586b4911fecb03	# pytest: allow ipv6 in test_announce_dns_suppressed
	a104380e49676e5b517f5c8ec72d414ceaef327f	# fix: fixes `FATAL SIGNAL 11` on gossmap node
#	0110026190ae014b73d7714f0e8646435bda5694	# Change year to 2023 in LICENSE
	73e50b26f9e8cc20d7cb1d5022c30bae3b13c36e	# devtools: fix ZOMBIE detection in devtools/dump-gossipstore.
	9e93826eeaab1e9c1362362ae4c541f3765e462f	# gossipd: neaten node_has_broadcastable_channels logic.
	167209d595d53c6e112a3b0e4cd097cdf8ab8092	# gossipd: don't broadcast node_announcement if we have no public channels.
	4fc3c26671332b0f007f6c978bac75b63388cd53	# gossipd: don't complain about unknown node_announcements if it's a zombie.
	2e7c08824a2bbeb4b8ef5529d3582712c21170a7	# gossipd: don't zombify node_announcements, just forget them.
	baeebf2863e592c80621265b1ded97aef1c80629	# gossipd: remove any zombified node_announcements on load.
	69cd04318906cb683d7aebfe98f11ded8bc3d7cf	# gossipd: remove redundant is_node_zombie() in routing_add_node_announcement.
	463355de59b2df9b5df1088a24d44fdb010ca5b5	# gossipd: remember to squelch node announcements when shuffling
#	7079fb506f4bb7b68b3e9c2d66280aa7ef557012	# meta: Update changelog for 23.02rc3
#	e315f30728cbb1c259b27a943080f7c110366179	# db-fix: update NULL lease_satoshi fields to zero
#	38d90b250596d38a777ab064c3788a730f14d753	# autoclean: fix timer crash when we're cleaning two things at once.
	355a7ae8272edae02c7ee0fe3b6ee64aab861a1c:strip=tests/	# pay: fix delpay to actually delete.
	bcc94b2d43b1765ffc40a9b7ff1ed6865a283cac	# fix: do not send send peerstorage msg when disabled
#	855980641c50d977702978e5d669b95997537f43	# sql: fix schema tests since num_channels added to listpeers.
	f3baa3e510b6e1e27e34e835df4df16d9b62ca98:strip=tests/	# sql: fix crash on fresh node_announcment.
#	1426ac881b74542d3a07ad84730a9c3518cb1cc4	# pytest: remove openchannel('v2') marker from test_sql
	4a38e37b590732322f5bd9a4f6261e43b8a89bd6	# json: Add method to parse a u64 array
	29031c02cac4173e5aaf30f5926a1722de5b55a7	# libplugin: Expose the `jsonrpc_request_sync` method
	5dc85d185a27469d7078caf9c76c9e8d308a0f95	# keysend: Extract `accept-extra-tlv-types` from `listconfigs`
	f1c29aa3bde65da04d821b95ae0e14f4c2f7c06e	# keysend: Do not strip even TLV types that were allowlisted
	07c04d247eb2bb1da318aa7486119abbb8c1c1f6	# gossipd: correct node_announcement order when zombifying channels
	d5246e43bbe4b1059ad9b618837bb32bf9ba3f63	# gossipd: flag zombie channels when loading from gossip_store
	d1402e06f9a8c18244d854ccc159326f0bab749a	# gossipd: load and store node_announcements correctly
#	c7fd13a4602d30e5a1392f223b69fdfc59874440	# repro: Add `protoc` dependency to repro-build
#	0707ffcab41c4974cf80338db5f1baf8ab34a473	# reprobuild: use pyenv for python installation
#	538a8d5c570ccd2a853ac5f1dace145c99b10ea7	# meta: update changelog and pyln version for 23.02 release
	8c3baa98cf53b8c9aeccb044aca8d9fb6c1f9009	# gossipd: remove zombie spam cupdate when resurrecting
	df0661ce22b51f2417e583f3070d6b797565d8c0	# sql: fix bug where nodes table would get duplicate entries.
	1e2bc665ae43fb423b1373806118004accebd66b	# sql: fix nodes table update.
#	4bc5d6a0c542b12fd8fe69b44182b9d6519571a2	# pytest: remove zombie test.
	aaa14846c6a9987b4a0eb0e7b29093b177992cb0	# gossipd: ignore zombie flag when loading gossip_store.
	194d37b70fd201ec361ffd88f22ade73a00d801e	# gossipd: don't make new zombies, just prune channels as we did before.
	b5c614069bec50ae0e084ad8ac24c17a8729b619	# connectd: fix crash on freed context for new connections.
#	6c4a438afdf86cebd26f8aa18f868564c8f64189	# wallet: really allow broken migrations.
	df10c62508aecb7aaee0fdc4166face87663f8b9	# chanbackup: even if they enable experimental-peer-storage, check peers
#	5e394ef53f3e6463e4e6e624cc33ecd87d3b7e08	# doc: add documentation for invoicerequest commands.
#	aea8184e582bf7d75e07749f12f0cef10672d30c	# doc: fix modern usage of sendinvoice (changed in v22.11)
#	cfbfe5d7eea53278fcbb601376e65b41ef0dce40	# doc: update documentation for fetchinvoice(7) and offer(7).
#	9e2287415f58b807202ad0b55f82ce7063774a1d	# offers: enable label for invoicerequest
#	be8ed8c7f00e9747cf199b85a3a5a38b0bb0fa48	# meta: update changelog for v23.02.1
#	cdf803cd6f84b0ec32afcce0e95ecf74017d97aa	# plugins/pay: revert removal of paying invoice without description.
#	bfc6fedfbfc7f8006fc6d3c40d558f7d6abfa2bd	# CHANGELOG.md: v23.03.2

#	dcc66d58abb186572d1edd9826c11b0bd30d9672	# doc: update release procedure
#	4f3f3deab621a0890d61455be7ed66500e977b71	# fix: partial fix lnprototest runner
	fd04f46a921504ac8455e1244cbf5b2505b08897	# common/hsm_version: list sha256 for every known version.
	1c4f6ab2c579e8decd3308f6c15febda33707b4d	# hsmd: deprecate reply_v1.
	06b9009dd8d2de7deaed8adee345517f8f393297	# lightningd: remove deprecated behavior where checkmessage would fail quietly.
#	67f23c19f763c2820714409a67b17eb8d6c6336b	# lightningd: remove deprecated local_msat, remote_msat from listpeers.
#	780f32dfc683ccf0eb18110223679ddd2989c3c5	# global: remove deprecated non-msat-named msat fields.
#	983542f2a760798788213098b927b6fa1e476eea	# global: remove deprecated "msat" suffix on msat fields.
#	9366e6b39f41ebb956ad992102b7d0179d1f6765	# cleanup: rename json_add_amount_msat_only to json_add_amount_msat
#	658bae30d5f159a4f5da82aff67f7af95dc5cfb9	# lightningd: require "jsonrpc": "2.0" as per JSONRPC spec.
#	acf01f4c09796fa0fa24509eabe4a145fa2a6569	# pytest: don't run test_backfill_scriptpubkeys under valgrind in CI.
	57d21206dbeb05f085e288b9324c7bb8d76b7180	# cln_plugin: add `shutdown()` method to `Plugin`
#	ba4f0c8dab8f36c964ac547e6c2d00d347a3236a	# ci: add timeout field to 2h for each task
#	6c641bdbbb1454e1176f78e942b3f4b7265083fe	# test_backfill_scriptpubkeys: stop first cln node before second sub-test
	fca62113f5f166a1877907f870620c5df6680e5d:strip=tests/	# plugin: fetchinvoice: set the quantity in invreq
	906279a46e6b795f61056abb8a5e19d83cd3774b:scrub-stamps	# Output channel_id in listfunds
	9a3f69aecfbe2c9c4734ac051073949ebc619a33	# connectd: log status_failed on TOR problems
#	2f188622b7545b99178060451beb31cdf7b2e525	# pytest: add timeout to test_feerate_stress.
	03c153ac0bc4847b8bc523170d8c8e75a5e9185a	# channeld: don't spin trying to send commitment while waiting.
#	48c334dc81085f2518186328c81248812b9092b5	# build(deps): bump werkzeug from 2.2.2 to 2.2.3
	21a1b4e6aabc26d5210d09699dc921e8c6f108ea	# common: update HSM_MIN_VERSION to reflect reality.
	e02f5f5bb8ec2e101e5284c2a0a37fbb8e56fd22	# hsmd: new version, which tells us the HSM version, and capabilities.
	91a9cf351290ecccd4a75925c59e22e334798bc6	# hsmd: capability addition: ability to check pubkeys.
	3f02797e88c4d4f955f3ae7ad007ff275f89fcda:strip=common/test/	# lightningd: move bip32_base pointer into struct lightningd.
	3db3dc946f1ee6249394186216a89041ab979617:resolve-conflicts	# lightningd: move bip32_pubkey here from common/, add hsm check.
	df085a8a875e1a02f93bd823ef2cb915563f21dd:resolve-conflicts	# wallet/db: don't use migration_context.
#	07527d9fbbecdc5bce1f3501cdd8037fa9246e0a	# fuzz: avoid buffer overflow in bech32 target
#	3192be5c2355e12db5215ac6d882d1507e9caf33	# fuzz: fix UBSan nullability error
#	5eddf3cd737be583bd36fd54aca04d62e1d8cc11	# test: add PSBT field that doesn't collide with PSBTv2 fields
#	908f834d66218b52132c22af78a7ff87ad7ddec1	# Update libwally to 0.8.8, support PSBTv2
#	cb7caa31396e998443000cfc4d86250a08587021	# Re-enable PSBT tests for Liquid except test_sign_and_send_psbt
#	887c6f71cf90e6bcc63b15bd7d82ab3dc9e7431b	# Add PSBT version setting RPC to aid with debugging and compatibility
#	cf662e55a7dc1ae26f2cfba835ec8d118c8661e9	# Make startup_regtest.sh more robust to bitcoind wallet state
#	e7bf52980b4e22480c3236d27b078dcdb15fc153	# test_closing_different_fees: b vs balance in loop
	c85bce94bec34f7f5ae5f42b127829e419d119b8	# Report failure to sign psbt inputs by hsmd
#	aa1a0e31fd902b6b04fc713ce8faa5a1beceee31	# Docker: run directory for post-start if present.
#	3424f70585e61103eaaae3bf5f443c57407abf97	# plugin: autoclean: cleanup the forwards with localfailed
	97de4f8e0f34665ba6c531cf5ad78f1026856b46	# grpc: make the mTLS private keys user-readable only
	7d7b2abd0203b3b3616866294c267acb55c94114:resolve-conflicts	# msggen: Allow using deprecated fields in the rpc -> grpc conversion
#	98d425f1f40d90078f9efb7a613207f7875293e0	# wallet: add comment on db noting that `ON DELETE CASCADE` is never used.
	09011177a88ded25eacf63dc5c26eb73416b7a25	# wallet: only delete peer from db if it's unused.
	ae861d17931179c319665a40496ffdd00e63d788	# wallet: don't clear reference from channel to peers table when we close channel.
	d9e274cee2610f8c8881ec70ab5e3b944e1ea988:strip='wallet/db\.c':resolve-conflicts	# db_bind_scid: rename to db_bind_short_channel_id
	aae77802efa5a821dfcb76bdac59c2528f124276	# db_col_optional: wrapper for case where a field is allowed to be NULL.
	f720e0ff0be1b2c8eb73ddb4153972086189eb54:resolve-conflicts	# wallet: use db_col_optional.
	6e1eafbb0bb1baf5d57308dcc505c250a20a969d	# wallet: make it clear that `enum state_change` is in db.
	4b6e9649ebfa680138086f7a7373607e8e4aa462	# wallet: add accessor for closed channels.
	454900210593384bcca35338b5819ad493d969c0	# common: expose routine to map channel_type to feature names.
	c9ddf9d1c3bbc5910b691e7aef1cfdd4391820e9	# plugins/sql: handle case of subobject with sub-arrays.
	d818614aa9e67419c03760fa9f05245da255b281	# plugins/sql: recurse correctly into complex objects during processing.
	e75cf2e7fbc143a927f404f70a4c254bd5a4129e:strip=tests/:scrub-stamps	# listpeerchannels: add channel_type, both in hex and as array of names.
	89f91b9bb4174b258db237b3dfd78bf3cd3791c0:strip=tests/:resolve-conflicts	# lightningd: add listclosedchannels command.
	b8519a6a1a4cf90e2c9b6d93499e112a1a7041e5:strip=tests/:scrub-stamps	# plugins/sql: add listclosedchannels
	a80c1ae40cc87b3e6f3b7f04478a990c17e7e3c7	# docs: Switch to mkdocs for documentation
	178e0b64636f18fc939f65aa3f28df62368ab69f	# docs: Structure the files in mkdocs
	458195c29faa0330b603fd3a0cd9cbf273902108	# docs: Fix a number of broken links in the generated docs
	f1293ed0e679bfcc185e512d337f889caa4ad47b	# docs: Add LICENSE to the About section
	67a39b59e7eb00fc4b047fd79844d48ac2cb4629	# tools: Add yml mode to `blockreplace.py`
	f19792c241ff9e56507a02e09756acd19fbba4b7	# docs: Remove redundant ToC in FAQs
	826c7465683964cc0488d332534b046ae12e6b89	# docs: Use blockreplace.py to include all manpages
	7153beff28106c3e2849301ec5d7c89c5feb693c	# docs: Use admonition markup for warnings and notes
#	f4efe6c899803caf1f0bcf1a24ad01b59bbe13c9	# docs: Add docs on code generation
	4c6966d16aab96a9d86a2a03a4a98c6b1dba2c20:scrub-stamps	# docs: update autogenerate file
#	7174d06a707b442cb6c508f4664fcb577e9b640c	# wallet/psbt_fixup: routine to fix invalid PBSTs which modern libwally won't load.
#	f1fa75fa0660d35ee8b7bf4e8025be19807da6ed	# wallet/test/run-psbt_fixup.c: test for psbt fixups.
#	5bb0270492f99567fa0fdd774afb3f333170552d	# wallet: fix up PSBTs as a migration.
	2cb96a8d775a31a41d32aef64a84203d41f980b7	# wallet: don't silently load invalid last_tx psbts.
#	415b7d5d7d75ccb78e34e18b1cb25b8662f0cbdb	# gitignore: Somebody uses vscode: make their life easier!
	080a4dd86c1d38f008f6d5144d5c46c1322f09a0	# commando: save runes as we generate them
	183fbb4c14e91754994b2d0f7e882e1db6dac78e	# commando: listrunes command
	fb865291b6f5be4f433dd74cad2d7b5886988cf9	# commando: blacklist support
	a4ed3ae72e45f9cf45997e94ccc1b2469c8e559c	# commando: make blacklist effective.
	7ad04a994922923007333e6561d2d48486fc2db9	# commando: Save blacklist runes to datastore
	ecb173738acbf5b22de264b44bfd6f8143d01327	# commando: add restrictions information in listrune command
	af2c1f1881a88c9679ff13df2c840973d64dead2	# doc: schemas for commando-listrunes & commando-blacklist
	3e310a3d3e39809dcecdd91e9c7b3eabb07446a6	# doc: commando-listrunes & commando-blacklist
#	9d7afba35724f5bf12e364758229f686ba3e9b1d	# tests: commando-listrunes
#	61b063440c498ac462ad3aa722323f892b898e8c	# tests: commando-blacklist
#	5ea1fade603a574dbd5f6077d4f56db01bcbeef2	# fuzz: fix invalid pubkey error
	801c678cb924b31a386765cc010ddf493963ae3c	# ccan: update to include versions which pass -fsanitize=address and -fsanitize=undefined
#	3be36a66e32c1a660fa2067a0ac05992a4dfc466	# configure: support sanitizers properly.
	2005ca436ea3089a48a4f1d9182ea09ccd556726	# common/gossmap: don't memcpy NULL, 0, and don't add 0 to NULL pointer.
	1f8a4bed3960d864b1ccd5197f113f6606c05ef3	# bitcoin/script: don't memcmp NULL.
	37971fb61fa6906ea19e4c5ebad989adb6a863cf	# plugins/pay: fix capacity bias.
	b6a3f93b755c5719f22b0a8a96ba0dcb09114a4d	# channeld: don't asort(NULL).
#	5787e18e698bce6d23aa81a8e8a3f8393ac7a50a	# fuzz: fix check-src/includes when fuzzing enabled.
	f4b8a401cd64dc099209c2753f32bfaa9e6a331f	# pyln-proto: shorten ShortChannelId.from_str()
#	407d4d2922a775c85c1855a6560e42184f9e7c88	# pyln-testing: remove deprecated fund_channel
#	fb0027e314535cffe8fc2de8d464267f03aa41ec	# pyln-testing: fundbalancedchannel default total_capacity to FUNDAMOUNT
#	882cafd3c779f37fad41a5c2a3e84afb03d66594	# pytest: adds skipped test_create_gossip_mesh
	3f651b08d58fcc34cf4bdf3771e3953f59bb131d	# pygossmap: cleanups and optimizations
	be60f2ac332f33d2c72c4f94dd95d0f9589fb85f	# pygossmap: adds GossmapHalfchannel to module exports
	eb9cb5ef313a8ef75ea9435df50042656a49e3a1	# pygossmap: adds missing __str__, __eq__ and __hash__
#	d50722d26beaae803967c3690e454ff94093cf61	# pygossmap: adds a more complete mesh testcase
	5a9a3d83c973be74ae29c0cf124b30e0db3d002f	# pygossmap: adds get_halfchannel
	9409f2f1ea1d438b24259f82f82adb5ec20bc93b:strip=contrib/pyln-client/tests/	# pygossmap: adds get_neighbors and get_neighbors_hc flodding method
	6a16a31a9897bee9508ea60243e2bdec92742cd6	# pygossmap: parse node addresses and other data
	3130f4ec27232312ca6ea72e2f63d5f1226488fb	# pygossmap: read .disabled from channel_flags
	f1b6047d69a96010d4487d624f4a3380133e9cd8	# pygossmap: store features for nodes and channels
	6e46a63c5738798eb303698d34833cbbe7038196	# pygossmap: adds statistic and filter module
	04ea37d88f0f97dc3aae2109330a0c37eb5fd950	# pygossmap: rename GossipStoreHeader to GossipStoreMsgHeader
	b92b9f074dc2fa26df3bde4a8f9f5896dd6f059a	# delpay: delete the payment by status from the db
#	1507e87197ad5232851864146bdf25e2be092ad0	# fix helloworld.py example in README for pyln-client
#	3c83aed9d1dcb0bffa13426f6203d974d9f4fa1b	# doc: fix commando-listrunes SHA256SUM line.
#	00431779a6baad19d36b9027db8d36a5aeb293a2	# pytest: add connection test for gratuitous transient failure message.
	64d3f3be26d9dc8a9f9220ae1ff074f18efdbdad:strip=tests/	# channel: don't log scary disconnect message on unowned channels.
	aef5b1b844362ce2a245dffe8bab06e79825e852	# chaintopology: rename broadcast_tx callback name.
	528f44c2d32bedd1c1e3170da0b4877e3fded479	# bitcoin: helpers to clone a bitcoin_tx, and format one.
	0b7c2bf5193f9be9d9b038d6e05cda2e75bd8fde	# lightningd: rebroadcast code save actual tx, not just hex encoding.
	fc54c197166f1eb404b61cf43683905f603491ec	# lightningd: provide callback in broadcast_tx() for refreshing tx.
	4757c965e0a4d49d0ebd32456c11a7dbb8ba01ba	# lightningd: don't use notleak in chaintopology.c
	f2f02f9de6184010af30c16268ad18ebd53df15b	# chaintopology: allow minblock for broadcast_tx.
	538854fdce689b2648b278d718695997a75e1242	# bitcoin: add tx_feerate() to reverse-calculate feerate a tx paid.
	eff513aa44467c93f60e79be56630643bf12c24e	# lightningd: use tx_feerate() for calculating fallback feerate for onchaind.
	7e592f27d48656d6d03a67e2f4b401f2069bb0a0	# onchaind: simplify lightningd message handling into a switch statement.
	e51f629e349d69dfe0a1f913c4c1f526dcd86d40	# bitcoind: fix clone_bitcoin_tx() when tx is take().
	3a61f3a3504cd25f4587f9012f07e5309752f70d	# onchaind: helper to read and queue unwanted messages.
	38bc04907ba1257eb1a92cab8f71c439ae4308f8	# onchaind: two minor tidyups.
	e6db0eafc2843b79a1d535fb388e7e30821701de	# plugins/bcli: use getmempoolinfo to determine minimum possible fee.
#	1e24d4a0a0b42e082ec4003545e8d5f81a4b636d	# Makefile: fix check-gen-update to diff *all* files.
#	13ae1a51688e1a04bf056dd1b1bfe89080865e0d	# pyln.testing: remove Throttler.
	d2176e3385297c0b4d2df2176c5bd5446ef73707	# postgres: add missing 'update_count' to stmt
	9bcf28afb369e05bb0f339c0ce84c27cc3149f52	# db: catch SQL errors unless we're expecting them.
	df9552bcc1779b0327d7832e485d24010c2548eb	# db: make db_exec_prepared_v2 return void.
	eee3965d02a1a69a77dc90ef3a8bc19a39cdada6	# db: db_set_intvar/db_get_var should take a const char *.
	5df469cfca74a2b32cb4d9bdd41cba170f2e33e3:strip=contrib/pyln-testing/:resolve-conflicts	# msggen: Add patching system, add `added` and `deprecated` to Field
	392cacac8170f71f8e1bcffa8673b91964a53bd2	# msggen: Add an optional patch
	60b12ec096dae01aabde25a8ba835a2933f8d70c:strip=contrib/pyln-testing/	# msggen: Use the inferred optional field
	168bc547001f4abc7a6f2cc96fa9517e53b2669f	# msggen: Add VersioningCheck
	efeb030eefdc4d0724ccf0ea725333d02db0c143	# common: fix build of run-channel_type.c
#	30335e1dc3938d4c0e2d75fd20be2dd9b9d6c005	# tests: test for stopping node while it's starting.
	45193db7ea2195095bd8512aa21628a576219297:strip=tests/	# lightningd: add initializing state.
	87264540c3843c3138b3ee3d1125be0f3644f4c6	# hsmd: add support for lightningd signing onchain txs.
	956e6c4055e90f3452ef8e9f50918475a3895a95	# lightningd: handle first case of onchaind handing a tx to us to create.
	86e044a9a8b0bc96ed803258f1525bc21f83364e	# onchaind: infrastructure to offload tx creation to lightningd.
#	3e83bed46097f8c7b9a7d453db653c715c3e0855	# pyln-testing: adapt wait_for_onchaind_broadcast function for when onchaind uses lightningd for broadcast.
	07413c20b9f19362f437fc22fcda655777426c09	# onchaind: use lightningd to send "delayed_output_to_us" from HTLC txs.
	9d5dfa7bddb0fda9335c1b1d3de05c0b0ae42f04	# onchaind: use lightningd for spending our unilateral "to us" output.
	80cd6f0afe75968e4dab7b3a0e720fca04f1e3c4	# lightningd: remember depth of closing transaction.
	36dd70e67760c97cfcd44c7a740fe07806e05feb	# onchaind, pytest: disable RBF logic.
	3e53c6e359223384ae56319c19cc48c914e375d6:strip=tests/	# onchaind: have lightningd create our penalty txs.
	2f6be4e6bb8e3c3e9587e2d9846d918cbd66c0f3	# common: expose low-level htlc_tx function.
	a9dfec0e713053eb3b35bc82f3df1d08170bb969	# onchaind: use lightningd to sign and broadcast htlc_success transactions.
	868fa8ae814b990b664b1e1b89811b04e12c88d8	# onchaind: use lightningd to sign and broadcast htlc spending txs.
	5bdd532e708265afb92866176d1e9714bcfc28c1	# onchaind: use lightningd to sign and broadcast htlc_timeout transactions.
	0c27acc705e4c1348eab74e686a92b1f2f387121	# onchaind: use lightningd to sign and broadcast htlc expired txs.
#	c5b7dbcd98d49efa82e8c111a00611cb8f78b67b	# pytest: clean up wait_for_onchaind_tx interface, remove wait_for_onchaind_broadcast
	9496e9fbef86d48dc313c7facdb4f38a4d0c0d7d:strip=tests/	# onchaind: propose_ignore specifically to ignore if output reaches depth.
	c1bc4d0ead93ec1b0401edb3024488245a00e025	# onchaind: remove now-unused direct tx creation.
	a3b81ba17fdd85b5debc82b74dffc48e3148cd66	# onchaind: no longer need information about current feerates.
#	dae92c5830456c8e0582cf1d97933432eb45d885	# Update INSTALL.md
#	bf9c4df0de7f369d442ad93033a75bac42deb98c	# test: add the timeout to the waitpay command
#	a3ebc1bac49cc8cf022525bbad5ff75d1638c673	# lightningd: update comments now channel-type is merged.
	06d42694d5ed0c168a5df29648f17919a51ee62b	# wire: fix extracted patch.
	15f8e1e63c6a7dbfcf638ae8c967d6774e10dee0	# Makefile: update bolts to 60cfb5972ad4bec4c49ee0f9e729fb3352fcdc6a.
	fdf9b13bdbd8dc112798bc75c282d54cb8bfe9e2	# Makefile: update bolts fc40879995ebc61cc50dfd729512f17afb15b355.
	dfa6c0ca5226a33c6045b1fd25e69dc05c7276d5	# Makefile: bolt version b38156b9510c0562cf50f8758a64602cc0315c19
	f26b1166b7ca8d72d03c8e4d88de1301897bcfcc	# Makefile: update bolts a0bbe47b0278b4f152dbaa4f5fab2562413a217c
	458a85042b88ddddf96a7aed0ebf1b4add0e09c9	# Makefile: update to BOLT 20066dc2aba906f37f3be5a810ae67040f265377
	d4ffc756916b16d19cca6522b6f8ec422f32f24b	# Makefile: update to latest BOLT text.
#	88905e83729cf8bd2a247b0cc4526833ca6245d6	# tests: split fetchinvoice recurrence tests into separate test.
#	e61401aab9962e3e0d5ac96955fa7d1173db4a0c	# reckless: don't crash on subprocess calls
#	55cddcd3506acf674dc9515525f500e3227e4f41	# reckless: add support for additional networks
#	cf203369bc4aee3fc21b328d39e01a2d41ffcfe5	# reckless: use environment variable redirects
#	2f050621b01f7435aac509d76a5fc530bb0bf8b2	# pytest: add blackbox tests for reckless
#	9384692e2a154f66e9d26fbd0e4b34d8c291310a	# fuzz: add initial seed corpora
#	a1a1373090064d6f38b02981ad6309f2d0e04dd3	# fuzz: improve corpus merging
#	fa988d29420ace0ab7940167ed5cc3c78b87beec	# fuzz: add check-fuzz.sh
#	14afa6efe7e66fcc30218ac5b01badc1f6f8bf41	# make: add check-fuzz target
#	6e11a2e4160eba493e7cac1d7643202a934e9e98	# doc: document "make check-fuzz"
#	ca80dee5145ff9240aa6b4e342e14332bec9973b	# doc: add section about improving fuzzing corpora
	b53cc69cfd4c2cdc6be5e62fc8e706e1b8c43054	# msggen: fix incorrect assertion.
	6799cd5d0b2bc270183660c8944d56daa8661626:scrub-stamps:resolve-conflicts	# plugins/bcli: move commit-fee (dev-max-fee-multiplier) and into core.
	a2ca34ccf5da599d36d3c62f290e1d1021e32e15	# common: add tal_arr_insert helper to utils.h
	7aa8c7600272b9833aae2e6e55e4df69f0f8e3e5:strip=tests/:scrub-stamps	# pytest: test parsefeerate explicitly.
	faae44713bd724f6e254b67ebf5a9e05773f5efb	# lightningd: clarify uses of dynamic (mempool) feerate floor, and static.
	cdb85d561898c424105930ff08a695d0982ea033	# lightningd: handle fees as blockcount + range.
	64b1ddd761de30152154714433974b72bfb7f278:strip=tests/:scrub-stamps	# lightningd: clean up feerate handling, deprecate old terms.
	c46473e61549e6d927914c8496dfdabea073badf:strip=tests/	# lightningd: allow "NNblocks" and "minimum" as feerates.
	9e2d4240b1635770ff25cbf21c7fb2a30bbdd1aa	# lightningd: handle bcli plugins returning fee_floor and feerates parameters.
	812a5a14c0c733404c46778887dde2861015df93	# plugins/bcli: use the new feerate levels, and the floor.
	3a3370f4c12ecf41c0d6e6be782d30745a758e05:strip=tests/:scrub-stamps	# feerates: add `floor` field for the current minimum feerate bitcoind will accept
	819d9882aaaf8c1eea354f14c6df907e2a8d0e14	# lightningd: base feerate for onchain txs on deadlines, not fixed fees.
	5582970715038f8e417d473fb8e1ec773f990d53	# lightningd: split the simple onchain tx signing code.
	3754e283f868385a5803b76c5355a7def5cc7676	# lightningd: remember if they set "allowhighfees" when we rebroadcast.
	62fa91e23b0ae253136aad5ba12d24aaa108d47c	# lightningd: rebroadcast all pending txs each 30-60 seconds.
	a000ee015af7235e0a4ebc14c88ce3cb0f663ce1:strip=tests/	# lightningd: do RBF again for all the txs.
	295557ac50240b179224211b72c651daa8a77db7	# connectd: don't try to set TCP_CORK on websocket pipe.
	ed58c24bc77e7776fb7d0dcc1d9ae1022a274a78	# connectd: log broken if TCP_CORK fails.
	3e49cb01bd25759e94076296eeb0a6179d27942b	# connectd: don't leak fds if we have both IPv4 and IPv6.
	e514a5d43c2c3477941e2548d8a01be0e1294b0e	# common: lookup function for symnames.
	cf80f0520adacf1cf108b8e077ec7bb435478577	# connectd: dev-report-fds to do file descriptor audit.
	c45eb62b57851395b4c2c444b1bf7d869de3fa6d	# lightningd: create small hsm_sync_req() helper for hsm queries.
	8493ee5e1a40f1ef65ced91be50c9f4976af8c69	# db: print nice message and not just backtrace on bad column name.
	57b2cbcb320e6ab427988aefb5f72241ede946f7	# lightningd: expose default_locktime for wider usage.
	2fb942d21cf86b20395518c2eebda3bcdf9f6e14:resolve-conflicts	# bitcoin: rename confusing functions.
#	89b96e8ac0c384e222de7517b819b5f022782e4d	# pyln-testing: add support to tell bitcoind not to include txs if fee is too low.
	34f25db435e8b1a6fd369883e3fa1f81919b8fe9	# lightningd: fix parent reporting for memleaks.
	d502a7ecbb8778e7549721b8118e02c4114a8b90	# bitcoin: bitcoin_tx_remove_output()
	f1deeda1231c66f8b64ba7e85715353a3307c5d5:resolve-conflicts	# wallet: allow psbt_using_utxos to take a starter psbt.
	7e5146ab0cd05428688632fcb602a4edc59d3020:scrub-stamps	# common/channel_type: routines to set known variants, set scid_alias.
	355aa8f497a207475dc0fd60af4f203111225b3e	# zeroconf: don't accept channel_type with option_zeroconf unless we're really zeroconf.
#	7acaccfb36963efe133f1fe06742020f60c68458	# wallet: add channel_type field to db.
	75ec1bebee28d79ca242fe30dbba55964fef4437	# lightningd: use channel_type as we're supposed to for forward descisions.
#	b42984afe15fb9ab936e1dc5f2b0290c4152865d	# pytest: Reproduce #6143
	6d76642f7e65e9fb4af0c8bd1225e1d1fd09e4e0:strip=tests/	# cln: Fix routehints conversion from cln-rpc and cln-grpc
	650443e4d50eb55f1fc1fd96b388d78e8dd80c64	# ld: Add a couple of logging statements when forwarding
#	e30f2cb4a463ff2770548716381d9b297b04a86d	# have towire_wally_psbt and fromwire_wally_psbt set safe psbt version
#	c0d3eeb7894a30d6c9050d7dbbe773f3895b50c2	# Fix Typo in startup_regtest.sh
	e5c76f829e7a47091aeab310894aa6e07739b83c	# hsmtool: rework common hsm_secret fetch/decode.
	441b38c9eae2be8eacc8da383e47bf0f70fe8aa3	# hsmtool: move sodium_init() to top level.
	62d9ecb6d30fcba766a23aabb445d6607d559a91:strip=tests/	# hsmtool: makerune command.
	49b7afe58fd0709f24f9203ecde901f435c1abb5	# doc: give helpful examples for feerate values.
	3f95b559a3180a18c3e77e3027362473e9e22c09	# doc: document that urgent doesn't use the 2-block estimate, but the 6-block.
#	3c4b20e3a395f1b1cebd99987267cf118cc821b1	# ci: run fuzz regression tests
	2de5b84370115a481f887445c56c2aedbe190391	# plugins/Makefile: don't use echo -n.
#	2c9b043be97ee4aeca1334d29c2f0ad99da69d34	# Makefile: remove plugins/sql-schema_gen.h and plugins on `make clean`
	6f17d8bf0c68f13da5f572f176eb354fed4092ef	# lightningd: fix 100% CPU hang on shutdown.
#	2e7ecb98f4a488692993f89c135991e6097aa00e	# pytest: make sure we wait for all feerates to be gathered.
#	58c624d067419989b30e532d24362fd2faa16780	# pytest: fix test_penalty_htlc_tx_timeout accounting flake.
#	ba7901bebd3b61d063db6ef34cf76d169534adbf	# pytest: fix up test_gossip_ratelimit.
	8ef4b36a1fdbf55dea764c8914d3ecf0aa731018	# gossipd: send our own gossip aggressively when a new peer connects.
	46bb6beee7b531eef3bac0be225bf7565c60a95f	# gossipd: make sure we also spam private channels with the peer involved.
	00f75d6ee11290fa1c6431b69ce4fc6f1680a232	# connectd: no longer stream our own generated gossip, let gossipd do it.
	6a446a94c6fef61423e5daf2ae9872b2b3143fb4	# connectd: implement timestamp-as-trinary.
	bec8586dceee1c13329387954da453daebf5a291	# connectd: remove handling of push only gossip
	54bd0249108dcddebfbb630862d8170e33038b11	# gossip_store: remove now-redundant push bit
#	db3707f957199d27fd69d65394efe944ed981379	# pytest: Highlight the re-entrancy issue for cln-plugin events
	f69da84256f4820704cefc1d02cfcd561e67e088:strip=tests/	# rs: Run hooks, methods and notification handlers in tokio tasks
#	0687fecf0d0153065fa8923a7a5b60784c271f65	# make: Use the CLN_PLUGIN_EXAMPLES variable for testbin
#	2e5ad0f417f6aa7ad248d826cb26c271553c2dce	# pyln: Exclude all `cln-` plugins from valgrind
#	cc7d9f39bef21c506df635b08f063aab5e9fcb8b	# Update libwally to 0.8.9
#	b59b6b9cec0402d497a523f35e07c0171fdca0dd	# reckless: fix CLI redirect, minor cleanup
#	61631384203fda2a3ef04407d88b53c1af589dde	# reckless: avoid superfluous config rewrites
#	f5a132314a96d29d2cc9fc4d31621e2220d1b273	# reckless: remove extraneous web request
#	6ac0842aa1709bd75d777cc7e5d074c35b804a33	# reckless: fix crash on non-verbose output
#	d5df26f61312d176c93f51410a5004137c8ec77e	# reckless: add Installer class to support additional languages
#	32dd8258d4788b8152d9c28a62f627b1eaba6587	# reckless: add installer methods
#	2577096e71e05aa5d7f47f35717d7b99b693e859	# reckless: install command now uses `Installer` class methods
#	347e7237f89e23ff163844297bc3fe3092f09558	# reckless: match name using installer entry formats
#	d279da551b90d48139244487515709f3625c96ef	# reckless: add missing type hints
#	233f05e0e221d9a762b5fe2884e7f8b524cf1b24	# reckless: enable case-insensitive searching
#	f7316954308ae1169b3a51813f775314afb6da77	# reckless: provide response when failing to add source
#	15795c969a7f33d25b9b605b64098f40e9d32bf9	# meta: Add changelog for 23.05rc1
#	8163bfc7bd767e3e997fe5c12cd271f418ce29bd	# reckless: simplify installer registration
#	782c17996e31b5b32695f7db6a887a108a9a6076	# pytest: ignore pip warning
	f382ec0452065391269d1d76cc78ecf51c6334e2	# connectd: pass correct buflen to memmem
	ca2a162d70d0907966896634ea5b8df1aa673775	# fix: build with gcc 13 with enum and int mismatch
#	21cc16fb5bfe116bd0430a19c1301ef606c424b9	# meta: Add changelog for 23.05rc2
	2a52e52015f2386ead5999464edd457736906659:strip=contrib/pyln-testing/:scrub-stamps	# jsonrpc: Add versioning annotation to listpeerchannels
	65f513464341e3ed5a4bd223053a162504d1a10d:strip=contrib/pyln-testing/	# msggen: Add ListPeerChannels to generated interfaces
	e7a96cac110812752b275528be222a88b7e91f3c	# msggen: Normalize enum and field names if they contain a '/'
	d28815f7b8bcbfcd5f440e1b1f18d418db101f7c:resolve-conflicts	# msggen: Disable grpc response -> json response temporarily
#	318f35b24372f8c6dd382b668ec4e53d08c2b93a	# pytest: Add a test for the grpc conversion of listpeerchannels
	bff3b1ca8ce89f912bcf956976ce111523cac82d:strip=contrib/pyln-testing/:resolve-conflicts	# msggen: Add ListClosedChannels and overrides
	b41cb2f0050cb94ed671f605e8e7c33eaf10e814:strip=contrib/pyln-testing/	# cln-grpc: Rename the ChannelSide variants
#	90ede052ad3b6f5f10c6aed551a220fc33194cc7	# pytest: Extend ListPeerChannels test to include ListClosedChannels
	1e614dfb8a9d700d6bca812cf8d207bb02f6ca4a	# jsonrpc: Add request schemas for decode and decodepay
	db843159eadf5f638b92d609dbc687046875328c	# msggen: Move overrides into the model itself
	0031f1160bf479906195ceca3628b0c6c090380b	# msggen: Map arrays of hashes and add HtlcState enum
	fc26675336eeee5ed22590f60087af8cfc0ccc63:strip=contrib/pyln-testing/:resolve-conflicts	# msggen: Add DecodePay to the mappings
#	ef9e0fcf6079f096461cf8d561f4f18f5fbf88d0	# pyln: Set the correct envvar for logging for rust plugins
	acc3bb2276ae0b3a7e6f9788519a40cd67ed6765:strip=contrib/pyln-testing/	# msggen: Switch signatures to string instead of bytes
#	708fb17fa2817440fa37764c881ea32d3ecb17c0	# pytest: Add helper to get a grpc stub and test decode
#	ea23122880ba125a7f14049cd274c5ef2069140a	# meta: Add changelog for 23.05rc3
#	fe5f3cef510fc8d793ba7db8714f73e03e3c0007	# pyln: remove unused variable
#	3a2b703ff8f0696b2358ba67b884ff9931932c2a	# jsonrpc: Remove the old "_msat" prefix in the listpeerchannels command
#	4f258a935499d040f8096ccbbdf752e6a7b5e97a	# meta: Add changelog for 23.05rc4
#	d1cf88c62e8ff10485f3b40cddb93fc0063ba92a	# meta: update changelog and pyln version for 23.05 release
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
BACKPORTS_BASE_URI="${HOMEPAGE}/commit/"
SRC_URI="${HOMEPAGE}/archive/v${MyPV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	https://github.com/valyala/gheap/archive/67fc83bc953324f4759e52951921d730d7e65099.tar.gz -> gheap-67fc83b.tar.gz
	rust? ( $(cargo_crate_uris) )
	$(backports_patch_uris)"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
IUSE="developer doc experimental +man postgres python rust sqlite test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
	>=dev-libs/gmp-6.1.2:=
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-0.8.5_p20230128:0/0.8.2[elements]
	|| ( >=sys-libs/libbacktrace-1.0_p20220218:= =sys-libs/libbacktrace-0.0.0_pre20220218:= )
	>=sys-libs/zlib-1.2.12:=
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
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
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

backports_mod_scrub-log() {
	sed -e '0,/^---$/d' -i "${1}" || die
}

backports_mod_scrub-stamps() {
	sed -e 's/\(SHA256STAMP:\)[[:xdigit:]]\{64\}/\1/' -i "${1}" || die
}

src_prepare() {
	# hack to suppress tools/refresh-submodules.sh
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' -i external/Makefile || die

	if ! use sqlite ; then
		sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die
	fi

	# blank out all embedded SHA256STAMPs to make cherry-picking easier
	sed -e 's/\(SHA256STAMP:\)[[:xdigit:]]\{64\}/\1/' -i doc/*.md || die

	# delete all pre-generated manpages; they're often stale anyway
	rm -f doc/*.[0-9] || die

	backports_apply_patches

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

	use python && distutils-r1_src_prepare
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