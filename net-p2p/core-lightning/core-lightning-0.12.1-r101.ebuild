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
#	e0259b246e6f372cf585446ce239b3a7bdc6d4b1	# test: fix tlvs test in funding_locked tlv.
#	a56b17c759c53e7705fd6f002d53e809c03e4c26	# wire/test: neaten and complete tlv checks.
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
#	1b30ea4b82b1fe5adbdedfc31322bcf3e0c8ac08	# doc: update BOLTs to bc86304b4b0af5fd5ce9d24f74e2ebbceb7e2730
#	5b7f14a7cb2cf4fd097a9169a115efb6575dd48e	# channeld/dualopend/lightningd: use channel_ready everywhere.
#	b208c0d8dd4bc6d7b0291183c3e36cd87dac0de8	# doc: upgrade to BOLTs 2ecc091f3484f7a3450e7f5543ae851edd1e0761
#	3cc6d0ec2c9cdcce975309382cf5c115c4a9c113	# doc: upgrade to BOLTs 341ec844f13c0c0abc4fe849059fbb98173f9766
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
#	e286c38c6ff66680638384e0c22210ccd86fb49d	# wallet: use db_col_scid / db_bind_scid where possible.
#	2752e04f8f24f68c7e55244fe39d6fc27677222f	# db: add `scid` field to channels table.
#	d7c1325e38dfa15ccb2021430d118ee6a14dd1ee	# wallet: use scid not string for failchannel (now failscid) in payments table.
	311807ff1f4f3574413b2ef86f63bf28e5363ee2:strip=contrib/pyln-testing/:scrub-stamps:resolve-conflicts	# lightningd: add in_htlc_id / out_htlc_id to listforwards.
	7420a7021f4805d8b8058e86eec791f4ce3e27fa	# lightningd: add `listhtlcs` to list all the HTLCs we know about.
#	3079afb024e9307a696046d0e936ff240a5f4c86	# lightningd: add `delforward` command.
#	a15f1be5f88bdae5a6e816026e35a035791875e8	# autoclean: clean up listforwards as well.
#	399288db3f2a90e52fcea587424c1287705c69d1	# autoclean: use config variables, not commands.
#	612f3de0d4a07851c8f25ed8e2c359ecea7e3e2f	# doc: manpages and schemas for autoclean-status.
#	13e10877de9dde1b5aa784894a15a4611b62a46a	# autoclean: add autoclean-once command.
#	540a6e4b99c5c0b5b49dbd6b1c604f599eb45718	# autoclean: remove per-delete debugging messages.
	4d8c3215174e1436dccb66d60fa69536f3b4d31a	# libplugin: optimize parsing lightningd rpc responses.
	8b7a8265e7ad80bb0e1882ad5dffada14f7425df	# libplugin: avoid memmove if we have many outputs to lightningd.
	555b8a2f7a2bd728efa15dda8302084e477aa8c9	# lightningd: don't always wrap each command in a db transaction.
	fa7d732ba6f6cbba035f8162df3ad32ec8cabbd9:resolve-conflicts	# lightningd: allow a connection to specify db batching.
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
#	45cdfd2ff75c8d0f73deb2a24c81575760619fce	# BOLT: update to fix gossip pruning quote.
	fe556d1ed9b11087ecfdfc86f00e9397c2db7973	# gossipd: don't try to upgrade ancient gossip_store.
	3817a690c9708b1873264582d66a39bdf358e0cc	# gossipd: actually validate gossip_store checksums at startup.
	6338758018ee5b199c56fbae8ffb09813d94dd6c	# gossmap: make API more robust against future changes.
	daa5269ea259a855dac282c17c83e0eff09821b5	# gossipd: bump gossip_store to indicate all channel_update have htlc_max.
	253b25522b4c0eb33064e0d35070d6148e053776:strip=Makefile	# BOLT: update to version which requires option_channel_htlc_max.
	bb49e1bea586991f6e4cedeb277c3aece2593b25	# common: assume htlc_maximum_msat, don't check bit any more.
	bfc21cbb55ac5b5a423ccf1e6144948594363ede	# gossipd: set no_forward bit on channel_update for private channels.
	0d94d2d269c760721a49d2e0c8951371e9a435c2	# gossipd: batch outpoints spent, add block height.
#	f0fa42bd7370c9ee9a7b6e1d34d6bc824cc65a2e	# lnprototest: update gossip test including 12 blocks delay
	a1f62ba0e70b28ea82862aebc8ff776850073df2:strip='\(Makefile\|tests/\)'	# gossipd: don't close non-local channels immediately, add 12 block delay.
#	f53155d93b5eef9f4353c68e623cd54134aa7e2b	# BOLT: update to clarify HTLC tx amount calculation.
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
#	e855ac2f9e6453913df64602b680b3644d847a6c	# keysend: just strip even unknown fields.
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
#	744d111ceaf3d32121b10370c7043dd0fa4bb6a1	# doc: Create a blockreplace tool to update generated blocks in docs
#	a31575ca0b5a6d53ac8c8ed949d3a8686e1f690c	# tools: Add multi-language support to blockreplace.py
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
IUSE="developer doc experimental +man postgres python +recent-libsecp256k1 rust sqlite test"
RESTRICT="mirror !test? ( test )"

CDEPEND="
	>=dev-libs/gmp-6.1.2:=
	>=dev-libs/libsecp256k1-zkp-0.1.0_pre20220318:=[ecdh,extrakeys(-),recovery,schnorrsig(-)]
	>=dev-libs/libsodium-1.0.16:=
	>=net-libs/libwally-core-0.8.5:0/0.8.2[elements]
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
