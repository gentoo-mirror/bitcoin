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
#	182c900ceaec6d6544b1e4970b3f03e348a9778e	# repro: Add reprobuild support for ubuntu:22.04
#	f40b6da457794fc60854172065fdcb5b3b218780	# repro: Update repro dockerfiles and instructions
#	6ced5558fb7c817375112072d8f670b878356ddd	# Makefile: stumble along if git does not work.
#	cc9bdb82986198a5280d5df7f8246309c3ce7dc2	# pyln: Update the makefile to use poetry for publishing
#	55b5653726a5a195a83a89c2aef5fbc577c2f4bd	# Slight problem with `./configure help`
#	43ace0368598fe905ceb05e7e1fc07ec4057d265	# "removed asterisks, in case that's what made build fail"
#	e516a5dffe902093af7c3c16c8ad6f950d4cd247	# external/Makefile: fix `submodcheck` for sudo make install and modern git.
#	80db867a30adce2dc7973d1f1533f5ce9fc795ad	# pytest: websocket test can tolerate ipv6 address
	4e902fbd883e710d1324c8c0870b5d15c0d1db0f	# msggen: introduce chain of responsibility pattern to make msggen extensible
	2ab2061cc90d146072ad1dfe5083ac03f7cb3799	# msggen: adding example and fixes typo
#	e7a3471af6357293a9f31614bb13d8b26cbffdb6	# gh: Remove @wythe from the codeowners
#	2cf92acaa8fde4eead7684de7a7cbda0412016e3	# gh: Add @cdecker as codeowner for the Rust artifacts
#	f90ee0ecfd5c029955b0eac6378e52d3b8a77a88	# ignore generic binary
#	ae522229f0f42047ba290e6c8d9ec67c322a1174	# doc: Update lightning.readthedocs.org project name after rebrand
	e972e37e8c3b07853f5d3f49b5d4f925289112e4	# docs: Update references from c-lightning to Core-Lightning
#	9039c9c46e44d57fd120b449f8904b2a479bc4c0	# docker: Update name from c-lightning to Core-Lightning
	c78b349f44b08771050756b783b55b9ff8014945	# README: add links to discord + telegram so people can easily find us!
	8dd51d127fff01b9302009906dcbdc83ea3b6548:scrub-stamps	# Restore description of "reserved" field for listfunds
	8b62e2584fc840bd3c84aa6e85a9b10bfe2d5c1e:strip='doc/.*\.[0-9]$'	# connectd: remove enable-autotor-v2-mode option
	f078e54e9887c9b747b948bce54d7f9988d1a5cb:scrub-stamps	# lightningd: remove various deprecated JSON fields.
	c77eda6d64b6092cc1fd26ae93798acc40d6414e	# pyln-spec: upgrade to the last bolt version
	535fdc06909c7a8828fb04047a187e71b0b5a15c	# More explanation of bolt csv regeneration
	b15cf312e8aa14d1f4d0b46fb02e571e18cc0770	# Change lightning-rfc to bolts post repo move
#	4cd6210c19485a646c65a719da9f2e64a5f58708	# docker: Add rust build support to Dockerfile
	5735f71e3c1a5c23624c73c9afb4bea26eaf44e2	# gossipd: don't ever use zlib compression on gossip.
	a4c365f8d07872c8b8461d0b48c8c04dae0a63e5	# gossipd: neaten code now we don't have to prepend prefix after.
	bf040c398b1dc6c42c9b3df3ac74bb786db56a99	# Makefile: update to BOLTs without zlib.
	685fa25756bf42a611dbeb8af6eb49159b09c3e3	# Makefile: update bolts to include remote_pubkey change.
	abd01a1701a1e38e511299ef44af8b9503e709bb	# Makefile: update to include fix for remote_addr generation.
	c7d359baf455e5260dc5d126b05211279e186ef8	# cln-grpc: API updates after 8dd51d127fff01b9302009906dcbdc83ea3b6548
#	0153621b32056f0451d8ed4e48893c97c9df2844	# Fixes #5276 by using as docker base image  debian bullseye instead of buster
	572942c783a58e518f0a1b449412a82717594636	# psbt: use DER encoded + sighash byte for PSBT_IN_PARTIAL_SIG items
	7c8dc620359f6d3e614551e9491c70e9d07e2d31	# channeld: take over gossip_rcvd_filter.c and is_msg_gossip_broadcast.
	87a471af982ddce932e9facbc86f75a17bdcb0fc	# connectd: use is_msg_gossip_broadcast into gossip_rcvd_filter.c
	d922abeaba9e8700c6449efe836300a86d5614f7	# connectd: optimize gossip_rcvd_filter.
	0c9017fb762981dd30f6130f7821bc022c3e2936	# connectd: shrink max filter size.
	24b02c33cc2ef3ff2841430e0cef4fc786b91881	# lightning-cli plugin start - Assume default relative path
#	aac22f3cb1ee2656318b11e980337acdc156f4b7	# devtools: Add fund_ln command to startup_regtest.sh
	033ac323d165147a445cb80aeab8d0b0786957df	# connectd: prefer IPv6 when available
	de9bc172de9f23bc8ca57f156809c1e55a450800	# connect: adds nodeid to remote_addr log message
	55cf413fc3df2548c5a1841955186ecf30e71cb1	# wireaddr: moves wireaddr_arr_contains to wireaddr.h
	32c4540fc03f7feebc39af60c26dc48801879446	# jsonrpc: adds dynamicaly detected IP addresses to `getinfo`
	a2b75b66ba9b8fb078782d28cd5024004edf656d	# connectd: use dev_allow_localhost for remote_addr testing
	475e4c9bd97124b058b0a271fbfa9fac4249264c:scrub-stamps	# jsonrpc: adds optional `remote_addr` to listpeers
	1e9ecc55e7a37c5f15edc5a7a37d885d9bc48005	# Mistaken default directory in plugin docs
#	d946de68144fca831c42759b7d468335d8dcf20a	# bitcoin: fix header order for make check-source.
#	b17db120b14689a72b45bf896a9c7b48d8b0168a	# bitcoin: add to check-source-bolt, and (minor) quotes fixup.
	e7393121b16bbb06fd6cf813a91ea2684ca1c90c	# Fix typo and convert paragraph to a list
	928a81f24a7b13a12ab2ed12de322e78c9942860	# docs: Fix  manpage title
	1eaec223b743fd17728ed96c90755717af5073c6	# expose short_channel_id and htlc id to htlc_accepted.
	ed7624e4f92e80e0dd76c1378a98e6ebd387db44	# Warning added to PLUGIN documentation re: `stdin`
	47a7b4a55b347bc55eeabd14995573d0e00510cb	# log: Add termination to prefix log
	83c31f548f0011a1503a086489c73f8b22703b05	# log: Add termination to log level
#	cff859331d80a6331878529490c96a9287e63d52	# tests: Update expected log prefix length to match truncated log
	4daa1b37ec2b036dbce8efc01c92a940a8d8a6df	# contrib/pylightning: remove lightning-pay helper.
	c5b032598ec5d2c45563fe86e829c4cd27e2818e	# lightningd: fix outgoing IO logging for JSONRPC.
	6e2a775ef27158274af5097030ee093c9ff5021e	# common/param: support renaming options using "|<deprecatedname>".
	36a2491a8953075de9b50c489f698b38e55809cf:scrub-stamps	# json: fix up msat amounts in non-_msat fields.
	a52bdeee015bd7236d03a1763764a8db4acc6c08	# common: add msat to sat convert helper.
	e2f0ca9cbea82e1fdbab04518de0028d11222bdf	# lightningd: don't add null for unset plugin options.
	ca69e293d1ea1ac60305481c36d57855fa61f91c	# coinmvt: don't use msats in fields not called "_msat".
	cd7e784d6f503553548654ca056c8faaa091348d	# lightningd: change `msatoshi` args to `amount_msat`.
	f6b4dbc65afaad14e6346ca2754622715ca431fe	# lightningd: use amount_msat not amount in htlc_accepted_hook.
	f1172254360214e3e04eaf9a701aaef4b535304c	# pay: use amount_msat for amount report inside attempts.
	fccb11a6413eb4c2a0f3b097b23d22636cb9bc97:scrub-stamps	# fetchinvoice: amount_msat not msat.
	01411d70be0ffc9645caf85ba01aef51315ff8fa	# common: enforce that msat fields are called "xxx_msat".
	5c208c1b06e4ae2f20f306186ab9b1f8cd1fa456:scrub-stamps	# pyln-client: convert every _msat field to Millisatoshi
#	6afc0affef2e78b8ebf2ea5057e49dcf15d8ef92	# pytest: don't use deprecated amount fields
	c3efba16ff2cb440bd53bb84693fd282bf2decf5:scrub-stamps	# JSON: don't print deprecated amount fields any more
	08d5776ebc3646ba924466be95416076a7852300:strip=tests/	# lightningd: deprecate `msatoshi` in `sendpay` `route`.
	98c264de66150336c14a610102470f751ec43b67	# fundchannel, txprepare, multiwithdraw: don't assume "excess_msat" will have "msat" appended.
	993f44f289d5ceca98dd34bcf57be19cba2e5c3e	# libplugin: don't be so strict on msat fields.
	6139319b60b93f86f6962f06fa85313b468efb6a	# funder: prepare for msats fields as raw numbers.
	6461815dd929cacacaaee1baa74bd9866478cdf7	# plugins/funder: fix parameter parsing.
	5531de99dec608d9b06d3d10075c58e04b79876c	# lease_rates: prepare for msats fields as raw numbers.
	60bd70be852911ecf174c3dfeb88ab11ae3bf8d4	# JSON: deprecate printing msat fields as strings.
	55f94322e540a89014909954bc9b01c4ca8425dc	# doc/PLUGINS: update to remove deprecated fields, formats.
	9a880a0932e7d8575620a1f7b48038c52b4b126f	# clnrs: Implement backwards compatible mode for Amount as bare u64
	14483901cd689ef5f241d4399c403ed31dbbe66c	# cln-plugin: Save "configuration" from "init" method
	318b6e803e820875237da6500f70eb7e9022d61b	# cln-plugin: Add unittest for parsing "init" message
	5ec424bc862952e448f4cee00029a2a282b73ba5	# cln-plugin: Configuration struct
	e6442d798ef24e1f868ca6003cad6e20a4d8dd5e	# cln-plugin: Make the proxy-related configuration Option<>
	bb53a178559207ba221dc5b091bc0918ca733b91	# doc: Tor needs CookieAuthFile set
	acc78397eb811e7751e6b583adf675a664383809	# Remove native-tls dependency from cln-rpc
	49c6459148502df5be6f62574bd0ca52524c9259	# Update hsm error formatting.
	d4bc4f646035a9efa566109da561b00698abd8c9	# signmessage: improve the UX of the rpc command when zbase is not a valid one
	5444a843b60e0b1d1f6742fa9e912fcdfe5736f8	# git: Ignore some more generated files and the cln-grpc plugin
#	92f10f2c340f3a009a64f054c58e1c85c9b6d819	# pyln: Fix relative path dependencies when publishing to PyPI
	56dde2cb7718377dc4b0487301cdf5eadc2d7e5f	# lightningd: multiple log-file options allow more than one log output.
#	575b94c1efbb595d305eda5a9d5181e87ff6e886	# pytest: Remove all trace of python's "flaky" module.
#	aefcea44a32bd416aefa3c0762bd3b2ea9f01028	# pytest: fix flake in test_gossip_timestamp_filter
#	930860c7816a7bee8da29342a7b0afcfc0bce433	# pytest: fix flakes in test_gossip_query_channel_range
#	d274de2bf48c6d8ed71db9bb9ff9aaa67dd48f3f	# pytest: fix flake in test_htlc_too_dusty_outgoing
#	71b1eaf2fe7d741fe8a8c68f08e7c3b675369bad	# pyln-testing: try harder if cleaning directory fails.
	a1b8b40d135c64e580d6767288a1ca5d6188e54a	# connectd: fix debug message on bind fail.
#	eb25e080397d6e89ea6993069e3924043fde3d70	# pytest: fix port allocation race when nodes restart.
#	6247bee11eb8c2a85e31af629e39e2018f114272	# pytest: try to fix bitcoind socket timeout in test_channel_lease_unilat_closes
#	b1f393f355ed3a3ad11dd46b18c5b782db7497b2	# pytest: fix race in test_multichan
#	2f27aad8d01e9dd02873d1d4163e09e72794a45e	# pytest: fix flake in test_wallet.py::test_hsm_secret_encryption
#	c1a111b68cd0bbb9f44476cb107bc18ecfb34378	# pytest: wait for stderr, rather than asserting.
	2b7915359cfecaa8a4926e36088c321e3896e7e1	# gossmap: handle case where private channel turns into public.
	11de721ba96a3d8c35e1949b486bdf1c5377dc0d	# gossipd: fix gossmap race.
#	353361a05c0db0b7ecb4a8c1e21ab3172d7011c8	# pytest: test to demonstrate BROKEN message on onchaind htlc close.
	517828adb26fc1a42af0ee5d3b19e84857d27d8e:strip=tests/	# lightningd: don't print nasty message when onchaind fails partially-failed HTLC
#	bcd050a6109f1c402e6c87704f31293e072fbd1d	# pytest: fix test_ping_timeout flake.
#	a0e0dbf229e9b828e0b76d0f12ab62f9df2b4b36	# pyln-testing: use files for stdout and stderr, not threads.
#	d2952576cd3ed95c3b2157ece0ae597add200fbb	# pyln-testing: restore proper streaming behaviour for lightningd.
#	61d8eb5fa82f450274319367d10ec35f5c14666d	# pyln-testing: increase default daemon.wait() timeout.
#	6221ac621d505afa817112dac2e095b16566925c	# pytest: fix timeout in test_option_types
	b4820d670678f9bc48d93ea43793122368fb1a95	# lightningd: don't run off end of buffer if db_hook returns nonsense.
#	fcff21fae56c68119a27bce41c159b32bf7b8c86	# pytest: allow more time for test_waitblockheight !DEVELOPER.
	70b091d9f67d68e1cdccd53eed041fba16bb2d68	# lightningd: fix transient leak report when openingd shutting down.
#	3958d59e3995c46c8ce4cc66d97c066aaf9d134e	# pytest: fix test_channel_lease_post_expiry flake.
#	9137ea262beddfa193393f6cfcc82ff1b401f401	# pytest: don't assume that join_nodes needs only check ends.
	3f98cf3fceab2fa85ec90180fe13ce1568e0bde9	# lightningd: track weird CI crash in test_important_plugin
	e120b4afd6dd7d763f7dd0bf671ab3f0efa821bc	# lightningd: add more information should subd send wrong message.
#	4970704d2400c82ebcd7a9a57a00c95316584395	# pytest: fix gossipwith flake harder.
#	a677ea404bbf4e2491df6c33f58e8b4201c1be79	# pytest: fix flake in test_query_short_channel_id
#	25699994e5941fb165cf379ff3a688981bcdaddb	# pytest: fix flake in test_node_reannounce
#	9152b8c4240957f185ea026c135eccf335b62069	# pytest: fix test_multifunding_feerates
	cc7a405ca4acb8e96cc7890439663e5474236767	# lightningd: use the standard port derivation in connect command
	4b11f968ad15c28b526e02a4068b6243220efa6a	# lightningd: change the regtest default port according with the tests
	c07d44b4d4acddecf232d859b7b424c086d06706	# docs: update the docs in according with the new code
	7ff62b4a00c71987841db6cc1f63f8533f522b08	# lightnind: remove`DEFAULT_PORT` global definition
#	2c9d7484a2b81995d8c452a32d5b21c769a8f3a7	# test: introduce the default port function and remove hard coded port
	2754e30269e918525e49cf871006c9a5d569fdf5:strip=tests/	# devtools: revert changes and make sure chainparams always set.
	8e2dcc11673a4c6d39350a0b439350e2312d482c	# doc: document the [] IPv6 address hack.
#	9ab7c8aed395652a2e99b4972f2fc4acf34d8317	# connected/test: fix memleak in test.
#	2fe17a58376a0740c7f1a3d0c6f84e2ddc07544d	# CI: make sure *someone* runs check-units under valgrind!
#	9f953b5efb5c36b5f7aa339d3f1e05691a447301	# No funding_wscript arg in initial_commit_tx
#	50107754a77bac7480ade936453a90b016c27e50	# Add README.md
#	ee3f059e800b7ffcd7f0ffc6e5037899132b05cd	# Update README.md
#	1771b8ec2267e1bb5f6d8cf3c07ada085350f6ee	# CI: re-enable checks, by changing errant tab back to spaces.
#	bad943da55b367158f5e080baea90754aa50c9a7	# valgrind: ingore plugin build with rust
	6d07f4ed85be91d5af0bfffa75895d4b33fd4cc2	# json: Add parser for u32 params
	185cd81be408320b8e078060dc2d5cff43149f0b:scrub-stamps	# jsonrpc: Add `mindepth` argument to fundchannel and multifundchannel
#	e4511452aca7f2dd8135a8e3d7dc84dfb17596a1	# bolt: Reflect the zeroconf featurebits in code
#	adbb9770534e60efc1e4a0b31f1dbc570259f8fd	# openingd: If we have negotiated zeroconf we use our mindepth
	147787319084382e4a7141163d52aa632bc99faa	# plugin: Allow plugins to customize the mindepth in accept_channel
#	8609f9e00d2dfe0c36697550c76a606f381afd10	# pytest: Test the `mindepth` customizations of `fundchannel` and hook
#	3fbaac3fdbadbae51d3342a7d5d6a282fc9f54ad	# jsonrpc: Add option_zeroconf handling to `listpeers`
	9d3cb95489a2d74f7fc624b9a1d8ad074e9fd66a	# wire: Add funding_locked tlv patch from PR lightning/bolts#910
#	de1c0b51f024daf79b4414d9a70865e63e474db2	# zeroconf: Add alias_remote and alias_local to channel and DB
#	b9817d395fad5ed6c32ff573a5b5a069d9f336fb	# zeroconf: Wire the aliases through `channeld`
#	c98f011479ff54ed136059875c58467b1d38cd1a	# channeld: Send a depth=0 notification when channeld starts up
#	cf51edd95b0750905876f78801f2ac0bd25c0a4c	# channeld: Remember remote alias for channel announcements and update
#	3e57d6f9d0f58841e5a61f9d89cb855fb5913bd4	# channeld: On funding_locked, remember either alias or real scid
#	bf4417804753174f2b80de5158e09ae2828c0e6b	# gossipd: Use the remote alias if no real scid is known
#	5e7404850848c2035550f051c3efb3551ecc7b8d	# gossip: Add both channel directions with their respective alias
#	cdedd433a483d335969655eb7bca5e9a87cde055	# jsonrpc: Add aliases to `listpeers` result
#	78c9c6a9e0b0975eae1afc9f7d19a9373e1c743b	# ld: Allow lockin despite not having a scid yet
#	1ae3dba5296a3b487da556d0097466b88fea3d39	# invoice: Consider aliases too when selecting routehints
#	a4e6b58fa40b58cf6b0365d2ba964027eb0949e5	# ld: Consider local aliases when forwarding
#	2dc86bf29b3b8c3134aad3915a74849041f30bab	# db: Store the alias if that's all we got in a forward
#	22b6e330303dcbc5397a3604b59908d7e48c0dff	# zeroconf: Trigger coin_movement on first real confirmation
#	0ce68b26c63b0e15fcbfcc22724ca43e46e8c046	# jsonrpc: Include the direction also if we have an alias
#	7930e34da32036fc7e372e61f6c6b861b3392905	# pay: Populate the channel hints with either the scid or the alias
#	92b891bee3759c206e27057d3558ebb08062c852	# ld: Add function to retrieve either the scid or the local alias
#	252ccfa7ab3ebb6934b90f80f2271537d4b7e82a	# db: Store the local alias for forwarded incoming payments
#	df739956ab82470628febdd9440b31c826eb969b	# pytest: Add a test for direct payment over zeroconf channels
#	306d26357e62e9755f7c92dbec4f812dddb57600	# pytest: Add test for forwarding over zeroconf channels
#	b195e6d9d4f21b626a3e022b03bae94a5e286423	# pytest: Add test for zeroconf channels transitioning to be public
#	19f8ed3fe1ee5a65975a8b052a3f679772e41586	# channeld: Explicitly use the first commitment point on reconnect
#	692a001198df36274559f8c3cf310cddff0912ed	# ld: Use the local alias when reporting failures with zeroconf
#	29157735fb60004d721e84f8d411824f73417d64	# channeld: Track the funding depth while awaiting lockin
#	db61b048a9dee84c3fe0a002af17899cd0879bf3	# zeroconf: Announce the channel with the real scid as well as aliases
#	695a98e5d8c01fc51c0d5fac6859c7d778886fb9	# pyln-testing: Add `gossip_store` parser to testing framework
#	a07797c166c3008d7520a046982dbf2fbd4fcec5	# features: Add function to unset a featurebit
#	d115d0110588ddf40b4782588d7fbcb02c2b5427	# zeroconf: Add channel_type variant support
#	669bca4a02b724f9326c1afaf00732c205501979	# ld: Use the local alias in the `htlc_accepted` hook
	cbafc0fa33419551a159c6b9be92cabc983ce01f:strip='.*\.xz\b'	# gossip_store: add flag for spam gossip, update to v10
	9dc794dba8299b076d519f449c4fcbfbe2a8e583	# gossipd: make use of new ratelimit bit in gossip_store length mask
#	08a2b3b86cf8b609aaeb8b44b29e92faa66204c1	# pytest: test_gossip_ratelimit checks routing graph and squelch
	87a66c180250e3c7ba99ac0461f7d16d5b411dbe:strip=tests/	# gossipd: store and index most recent and last non-rate-limited gossip
#	2927c8cfdbcc8c9f232a2abc2fe28f3da4121d45	# doc: Fix generated `listfonfigs` man-page
	c0253ebc6894c8afaf6d1c3c8ea94baa15b70542:scrub-stamps	# Fix broken link
	0a4cd9102852a3eb5f105f7787e5b8168fb56335:scrub-stamps	# Inline URL
	9296537edb98649031f947b03ba7104ff180da22	# peer_control: Fix check_funding_details assert
	d0937a2e97e4f412cbd67c149485665f3624d4df	# df: check mempool/block for funding output on broadcast fail
#	225ff870dfe39f2eb829568f995a0a0cad333441	# lnprototest: updating and patch lnprototest
#	0374fc16acfe9efe1f60f3f078df2a6b40c48cf2	# df tests: node still correctly picks up new tx if broadcast fails
#	32af92145b2070e47d3acfa31312542f0381c184	# update-mocks: handle missing deprecated_apis.
	f6f1844e15c6573eec6757b83a9ba3a0a41d0f22	# options: let log-level subsystem filter also cover nodeid.
#	ae49545875d2d53c00a2999a888fccef749a0b30	# pytest: fix flake in test_option_upfront_shutdown_script
#	68b45c2ae0b132805a85ad4df7ad1451903d7eb5	# pytest: restore prefix to logging.
	ba4e9b64b57fa09ccf9adbac7bb9533aed17a607	# options: print empty options properly.
	6aec37467471bd8512e42a665233763b5d97d588	# lightningd: make log-prefix actually prepend all log messages as expected.
	4633085ffd179bd430ffde7e92f056dc42fb81f2	# lightningd: mark subd->conn notleak() properly in transition.
#	6cc4858847189616774057b40671b01e1cf390ec	# pytest: fix test_gossip_no_backtalk flake.
#	7a7e43c07802c303c334b4748f20f75bcdf78687	# channeld: fix uninitializes scid alias for dual-funding.
	7dd8e27862f832f71d0bd11cf428d9b1198e5cdf:strip=tests/	# connectd: don't insist on ping replies when other traffic is flowing.
#	9d1b5a654e99febff568797ca93d4c8e7ac17ee1	# pytest: fix flake in test_node_reannounce
	3a61e0e18182b3e5ba704f4386ecceb333eb9df6	# invoice: turn assert failure into more informative log_broken message.
	36e51568322f6bd3b2bf6fbcc48695cbe081caa9	# lightningd: fix close of ancient all-dust channel.
	6753675c310e2f13f7c9f5434dd90b119ede3607	# lightningd: fire watches on blocks before telling lightningd.
	d50c62cf4100a670993abed55d63d7aa7f017ecd	# Update lightning-newaddr.7.md
#	c589543f1cda72ba2c6b45f7613549b1150e7bd7	# add generated man page
	ae71a87c404475bbbe351a39265e726a8f4ef7eb	# ccan: update to latest htable fixes, and update gossmap to meet new assertions.
	981fd2326a64945e7096c46fce8a2732f3894bc6:strip=tests/	# lightningd: convert plugin->cmd to absolute path, fail plugin early when non-existent
	2fddfe3ffc256a9d0f7e9851f2e3227b3936f34c	# lightningd: don't increment plugin state to NEEDS_INIT when error in getmanifest
#	7115611249e636d9de081da55446d162538571e4	# pytest: test plugin does not register same option "name"
	cdf12d06bab6053c4e31d155a777fe2a2d90407d	# lightningd: Make sure plugins don't register the same option "name"
	82a18813b3c510e95730ce7a5d0a150ac53ac2df:strip='doc/.*\.[0-9]$':scrub-stamps	# doc: improve/update lightning-plugin, PLUGINS.md and lightning-listconfigs
	71cd07ea616192a580941cf4615b9aea58769e89:scrub-stamps	# json: add "dynamic" field to plugin list
	42783aaa928da79e1295dcdc53123a66cb2433cc	# cln_plugin: Configure "dynamic" field in "getmanifest" message
#	e3f53e072f1626d54792b539eea9023a8502ce5b	# make: Add macos M1 support
#	74c3325208fbe24200a499c786c44345c4e7b5d1	# mac: Ensure that we compile the configurator with the M1 libs
#	36ab0e567666568b5c2938e5d61306c434d483de	# git: Ignore arm64-darwin external build directory
	9ff9d3d4e33c690d8c600bc740c76dd2554dd6b6	# tests: Fix the canned gossmap
	b8edd3478cc1c9870d1c7ae1453f67d84a11d082	# doc: Add two entries to the FaQ about channel management
	4ae7b993de606e3978b9734072ab199d06616b42	# docs: Add reference to issue 5366 for stuck channel in awaiting
#	980f3bda1fe4e464c471a8eb57c062ec93b34021	# pytest: test that listforwards gives as much outgoing information as possible.
	d6afb0cd8d40fe3836dbc27375caee37bc95fb96	# lightningd: allow outgoing_scid without outgoing amount.
#	3a1a7eb93f3daef5b90cb3ccc9ac48a85b4a0fa3	# wallet: allow saving forwarding scid even if we don't have amount.
	312751075c0ef069e771698852d650dab3d09dda:pick=doc/:scrub-stamps	# lightningd: save outgoing information for more forwards.
	ddf8fbdb5d224909cfade68178cc41efb0b9d61f	# gossipd: fix crash from gossip_store v10 changes
#	06e1e119aa0633a9257dbfefe65a04082df488c0	# pytest: fix test_gossip_no_empty_announcements flake.
#	f98df63b75e972bbfbea56023f9937745a00e613	# Revert "pytest: fix test_gossip_no_backtalk flake."
#	1d78911b29cddfcad7a887b2e178e67c6faf17e9	# pytest: test that we allow both msatoshi and amount_msat is route for sendpay.
	1217f479dfcd149e3d0dbc9c0de25096c6d7fef4:strip=tests/	# sendpay: allow route to contain both amount_msat and (deprecated) msatoshi.
	da85014fdf33e7a7561df4fba04f83cbe493ac0f	# gossipd: nit: update a misleading comment
	301acc9556fcfe6bbeb2fd378731f7c6a18438bf	# gossipd: only use IP discovery if no addresses are announced
	b3177e945fe535367683b2114c7d44b59069a05c	# doc: mention ip discovery only active when no addresses are announced
#	f67ab2a86e5d4543570925d9efafcb2b56a6c8d3	# test: run-gossmap update test store instructions
	95ec897ac0709be12935ac522ff0ff414c8daf54:strip=tests/	# dual-fund: Fail if you try to buy a liquidity ad w/o dualfunding on
	27e5ddc7b766cc8dad607d01c9c1de1fb22ebf45	# gossipd: fix of gossip v10 channel removal handling
	ba7d4a8f6bab5a3d5e5832d1f9e36749e695320a:strip='doc/.*\.[0-9]$':scrub-stamps	# make-schema: don't include tools/fromschema.py in SHASUMS
	64c03f8990707247996846899c56448481d99fe9	# hsmd: Create derive_secret and makesecret RPC for deriving pseudorandom keys from HSM
	e42ba8366be9f27c4faa4f15fdbacc2bd5891844	# common: Add scb_wire for serializing the static_chan_backup
	eca844eb36eebc264f0240eb0340508c95b185ad	# channel: Add struct scb_chan in channel and making last tx optional.
	1a1be6abd602f6e071abd80473600b0a67992cce	# lightningd/peer_control: Add RPC for fetching scb for all the in-memory channels.
	286d6c31654be0e34117bd981da2e93a27c32241	# tools/gen: Always return bool!
	6ba8abb0de13ed0d7bcdfc9d7dd8f4347d4fe26d:resolve-conflicts	# lightningd: Add RPC for populating DB with stub channels and set an error on reconnecting
	1450f1758c90cba9dcd4894f745d1db52e6e66b4	# Plugin: Add new plugin for SCB, Updated makefile and gitignore as well
	829fe09c134847d5b12889a22360da2c77d2c9df:scrub-stamps	# doc: Add documentation for new RPCs and a FIXME: in fromschema.py
#	7b160b203a2e6ce656b2cf8d9797e01c306acab6	# tests: Add tests for the RPCs Changelog-Added: Static channel backup, to enable smooth fund recovery in case of complete data loss
#	d544ae075b1b79dcd7826c8c45340f3dc4999e86	# pytest: test (failing) that we rexmit closing transactions on startup.
	bdefbabbeff96ca22e8281cd964de22cf8894d3a:strip=tests/	# lightningd: re-transmit all closing transactions on startup.
	d284b98911f45639d5e60aab58b50cb5c9f536d1:resolve-conflicts	# notify: `channel_state_changed` now receives notice when channel opens
	b624c530515b3966ae08b740eac35bbec19da5de	# plugin: add check on the type json object during the IO message handling
#	5ef6729224fba4937132e3cf33ac34d522cf2a6c	# Use correct naming
	99367dbb3229adda2f114cf6b8caf6ebd4965aeb	# make: Add msggen generated files to check-gen-updated target
#	1a9979784f62c35490486f74e2e1ba27352c36c4	# contrib: Remove obsolete libhsmd_python class
	50180e040c66da6207b6128bca7f282c280a2521	# msggen: Update generated files to add Listpeers.peers[].remote_addr
	92fe871467e32a6631b473398341a9dc16edd7b2	# connectd: optimize case where peer doesn't want gossip.
	dcf2916dcb27f919435553fe5b675ff75f035d8b	# devtools: add --print-timestamps to dump-gossipstore.
	62a5183fb5de6ab1af682280f8473238cf9064fb	# common: add ability for gossip_store to track by timestamp.
	6fd8fa4d959705d6835deacdcf470bf0ed367923	# connectd: optimize requests for "recent" gossip.
	f2e7e9d919c1670b6bdfd3e672d476988951d43b	# coin-moves: only log htlc_timeout pair for penalty txs
#	769efe8d5456a27707c086956d3bd19ab6417439	# tests: massively speed up our wait for enormous feerates
	c34a0a22ada3dbd28319a7174a1d94b5242c4950	# makesecret: change info_hex arg to simply "hex" to match datastore command.
#	9685c1adafd0e3feaf8813a68acff77176738da2	# lightningd: remove getsharedsecret.
	0236d4e4dafe4f1e78f3af5b14f9276fb8a723db	# common/json_stream: remove useless attempt at oom handling.
	814cde56235951c5f700c45829506f5bda373820	# lightningd/closing_control: remove param_tok().
	ec76ba3895f63adb9c4159575530b9feda1a697d	# lightningd/connect_control: remove param_tok from connect.
	e621b8b24efbbc750ae132f6406f893e4681c057	# lightningd: remove gratuitous param_tok from help and config.
	a9b992ff4a1aeee4f7f1b0684b80c79eb0bf7456	# plugins/spender/multifundchannel: remove json_tok.
	f12f0d6929b358ba9c1cd0c551484aa7e52ff680	# common: remove json_tok.
	401f1debc5a5b71fa73fe90c3a37f50bc6baa7c9:resolve-conflicts	# common: clean up json routine locations.
	36a29fbfbc3d3e05ff534499d7b082d1fa3caf48	# lightningd/json.h: remove.
	dbae5ae569c5ee4cc261304842f2453b4429771e	# common/json_stream.c: provide explicit json_add_primitive_fmt and json_add_str_fmt routines.
#	94f16f14b7b47e83e13fc76b9048edad7b284a76	# test: test_invoices add a stress test
#	cc4024339980902d023d9604162393b8d82c055d	# pyln-testing: print content of errlog file when _some_ node failed unexpected
	ad3cbed7c28b2d4e9327885f6c3763f8f4acef41:strip=tests/	# plugin: autoclean fix double free when re-enable, remove xfail mark from test_
	3e672b784d77062adaabaec8a6f7ba18c2655175	# Makefile: use a library archive for CCAN
#	f65d3bb1fc0cfb693e2b73683e8f0cf835f5331c	# ccan: upgrade to get ccan/runes.
	d0a55a62b36fc6f318ee6d4f5274747d7ecc091d	# common/json_stream: make json_add_jsonstr take a length.
	d3e64c39700a351843fa1c0f1b2bb8469ee38c66	# libplugin: jsonrpc_request_whole_object_start() for more custom request handling.
	3eccf16f982b9ce8612913e2259a043ca98a3845	# libplugin: datastore helpers.
#	3fe246c2e70fbec84f851880c5423447cb6f398f	# plugins/commando: basic commando plugin (no runes yet).
#	49df89556bb3ad5f2f5d26ade31fc3724578785c	# commando: support commands larger than 64k.
#	b49703e279cd087bea508bbcc545f11e1ebc45c2	# commando: correctly reflect error data field.
#	0d94530f13564febce5db42f167894bb2a1fad9e	# commando: runes infrastructure.
#	cf4374c4ed58d4b4ace64d95bd24cfb11601b68a	# devtools/rune: simple decode tool.
#	419cb60b1be16c87906fd8ea1235851f9aaf7027	# commando: add commando-rune command.
#	ae4856df70b6ecc4c4696c0d16b18cf51604527d	# commando: don't look at messages *at all* unless they've created a rune.
#	8688daf937675a9aeaca48d2cda14c542f45f4a1	# commando: require runes for operation.
#	cf28cff3987bc2519de255f2611afc1ef6952ff7	# doc: document commando and commando-rune.
#	4ab09f7cfb1556ce0a59980702f0761b9d4ac7ec	# commando: add support for parameters by array, parameter count.
#	468dff172340317a11ac4110d931084e13f7ce2c	# commando: add rate for maximum successful rune use per minute.
#	8c48eda8c7b8fe3f087aa277959411244016f245	# decode: support decoding runes.
#	58ae885f48f5a85613b2a82a6db59fc37f2847e7	# fix typo in commando documentation
#	af2b863b4a3a5e56c10ba20a1af5ff969379543c	# Add instructions for checking out a release tag
#	6204d70a3729570f019ef7269fca79211c1e6350	# docs: fix contrib/ docs
#	6d4285d7c47bbe5eb17dd02ff795514b6f746c7b	# pytest: add xfail test to show DNS w/o port issue
	65433de05f48bb1bfa1e1ab0363eb28cb7fc4fc5:strip=tests/	# options: set DNS port to network default if not specified
	73762de18c5032984e507f2430e0d3a9744af878	# lightningd: reduce log level for remote address reporting.
#	a3f5d31b09c91019be0fd257a65677bf22c10342	# startup_regtest: add experimental-offers
#	98185dfc2b6a9d264b111249fe890123b65ff492	# startup_regtest: add connect helper
	08e3e979c8c5f6926f2b97255981159547f7216c	# lightningd: set cid correctly in peer->uncommitted_channel.
	b8ed1077437707b5fc1dec53437ccef4b958c42e	# lightningd: fix dev-memleak crash on unown unconfirmed channels.
	912ac25270582637b799392c8de5fbb50147350c:resolve-conflicts	# lightningd: remove 'connected' flag from channel structure.
	37ff013c2c5eac7d13a774f1ea655e8fdfca4841	# connectd: fix subd tal parents.
	9dc388036028c32eab79785b1a8591e0ea5c38e4	# connectd: put peer into "draining" mode when we want to close it.
	c64ce4bbf31752120c9c7013e5d53d10c6d3758d	# lightningd: clean up channels when connectd says peer is gone.
	d58e6fa20b2a9ecc7beeea6a441e3281086de367	# lightningd: don't tell connectd to disconnect peer if it told us.
	e856accb7d919a89054a43b662b8198ea4cb33e1	# connectd: send cleanup messages however peer is freed.
	8678c5efb337ef98008a8523999a60c7762e8a4a	# connectd: release peer soon as lightingd tells us.
	7b0c11efb40eef5b172b30e61e512cef4f7d1e8b	# connectd: don't let peer close take forever.
	9b6c97437e6426eada7be51b189c35035ac2557c	# connectd: remove reconnection logic.
	40145e619ba8b6afb168d16af54eadc2ebd8c4e6	# connectd: remove the redundant "already connected" logic.
#	8e1d5c19d681a6de4ba94a4da61585a0096aa94d	# pytest: test to reproduce "channeld: sent ERROR bad reestablish revocation_number: 0 vs 3"
#	6a9a0912348fe073d0c66855637ab92d80187f85	# pytest: add another connection stress test, using multiple channels (bug #5254)
	ab0e5d30ee73e389f12fcdcdcb003bfe18fda07a	# connectd: don't io_halfclose()
	a12e2209ff382286adf17fa59cb9f8a87b784b2f	# dualopend: fix memleak report.
	571f0fad1b5f4fd18385db2b2d3c0319764e9d14	# lightningd: remove delay on succeeding connect.
	eff53495dbfeeed35ed496e9043af78090a3c14c	# lightningd: make "is peer connected" a tristate.
	430d6521a0a95b0cb084a43a614b01d721f95902	# common/daemon_conn: add function to read an fd.
	41b379ed897ad24bf2d68ce022eb15339e430761:resolve-conflicts	# lightningd: hand fds to connectd, not receive them from connectd.
	d31420211ad6e3d665cd75ae2ee9e870161feb22	# connectd: add counters to each peer connection.
#	2daf4617628ec0ac288dac3509795d9e5e0b46ed	# pytest: enable race test.
	6a2817101d07fdc497cc57fb22592a45cea056e5	# connectd: don't move parent while we're being freed.
	671e66490e8633c49221f37e008ed73b0f18ae0c	# lightningd: don't kill subds immediately on disconnect.
	9cff125590a30328660db9abacb6de1c524ca8c3	# common/gossip_store: fix leak on partial read.
	719d1384d15b3bb782a7f09c14aec6d68edb7ed9	# connectd: give connections a chance to drain when lightningd says to disconnect, or peer disconnects.
#	c415c80d487ead3ce4338a818f0070be504f001a	# connectd: spelling and typo fixes.
	c57a5a0a06c9fd5e8b4b8674f6bebaeddb6eea98	# gossipd: downgrade broken message that can actually happen.
	e15e55190b8ce35440f626e8648fa3844203bdb5	# lightningd: provide peer address for reconnect if connect fails.
	e59e12dcb64c92667619e9bed8b414741f726d0a	# lightningd: don't forget peer if it's still connected.
	aec307f7ba760efcf1eea3d2ce87a9012188625a	# multifundchannel: fix race where we restart fundchannel.
#	2962b931990f3ad2db28ca44737e52872e1a586e	# pytest: don't assume disconnect finished atomically, and suppress interfering redirects.
	a3c4908f4a33aae31c433106e1069bc761a7202f:strip='tests/\|.*test/run-'	# lightningd: don't explicitly tell connectd to disconnect, have it do it on sending error/warning.
	02e169fd2727a75a1a27a14b7d924287c91eb626:strip=tests/	# lightningd: drive all reconnections out of disconnections.
	a08728497bdd6c7fa882360356cd0700b6061545	# lightningd: reintroduce "slow connect" logic.
#	099d1491044d24d59e856e0904e17a3ac349e942	# pytest: work around dualopend issue.
#	acc9dc4852f7775705db33388890c3d9eadef6a4	# pytest: fix flake in test_channel_lease_post_expiry
	0363c628abdadba8031853213909c526916fdc7e	# channeld: exit after we send an error at lightningd's request.
#	5abed486d0f691e20e057701d3ffa67fccd7555a	# Add rune and commando to gitignore. Changelog-None: Small fix
	1d671a23804ffb4934dd7080a75adbbe28b1d81c:strip=tests/	# rpc: checkmessage return an error if pubkey is not found
	7ae616ef60413428f40a5f77bffdf9576d49dc30:strip=tests/:scrub-stamps	# rpc: improve error format
#	ba4e870a1c332cfeab04c1433cedb5d671d593d9	# test: disable schema check of `checkmessage` with deprecated API
	e70729b04befe44d603370b96fbb10dc00bd342d	# rust: upgrade model with new checkmessage requirements
	e96eb07ef417a260bc8edd2a7202d83dbad61b9d	# lightningd: test that hsm_secret is as expected, at startup.
	5979a7778fc3cebe65e26cff5b6a33ec13ba59a1	# lightningd: expand exit codes for various failures.
	2d35c9a9298513da88be6fd357774a178b485a85	# msggen: Do not override method names when loading Schema
#	bac322ccdbedb93df649a9dd245c20d18e324116	# pytest: Move generated grpc bindings to pyln-testing
	5307586d4d7a064b0fa6a45dc6f91752da348c44	# msggen: Add a new generator for grpc -> python converter
#	b8bcc7d13f50779fd54490681bf57317ffe431ee	# pytest: Add a new RPC interface to talk to grpc
	77f5eb556bab084b2a184c09dfaf46654cae7724:strip=contrib/pyln-testing/	# msggen: Add fundchannel request
	12275d0bfe0e0745aa5c3d9507f534cb0e2e39a2	# cln-grpc: Skip serializing fields when Option<Vec<T>> is empty too
	1efa5c37be5e7bfc806eaf48e49ba0056eaa2e62	# cln-plugin: Notify waiting tasks if the lightningd connection closes
	18a9eb2feb79502b93cfa9d219e5a8c552506ebe:strip=contrib/pyln-testing/	# msggen: Add `stop` method to generators
	ca8c46c286b03d17849051d06ed2f5bc7a5bbfad	# schema: `minconf` should be an integer (u32) not a float (number)
#	6df0a9281f7386e4e25167221f72a6c15237e64c	# pyln-testing: Add a couple of methods used in tests
	b6a4cbbf98728b6cd0508c11d91e9535c6d0423c:strip=contrib/pyln-testing/	# cln-rpc: Add mindepth after rebase on `master`
	3f795364376e2eb3d43dd8a19019e0de8b6948ce	# msggen: Ignore `state_changes` in grpc2py
#	ed51c164c01823d31619781e43d062c483c587db	# pyln-testing: Add `invoice` RPC method
	e586a612282cb851d89dbd7c26792d843c650072	# cln-plugin: Add metadata required by crates.io
	aa82a96034def8bab3bb0e6faed273d5d9d78a15	# cln-plugin: Fix plugin dependencies
#	20b2f0af855e78175e46e4661e0fc72fc5e2cd8c	# pyln: Ignore generated files when linting
	217ce4c03cc741cb83cfedbad9f4293c279d9e46:strip=contrib/pyln-testing/	# schema: Add missing `mindepth` argument to `fundchannel`
#	76d05483fa2544f3ec463bb15c9e5ee8b9a58d4e	# pyln-testing: Add listinvoices to grpc shim
#	08bef48d5c37867f14f68cbdfd1d21972033c8f6	# pytest: disable autoreconnect in test_rbf_reconnect_tx_construct
	8d9c181e3b9e91d68b1d6eb3ced2030c07137d82	# dualopend: plug memleak.
#	9c945dbc68fa268f7995005dc747e23bfd94bdbc	# reprobuild: Add Rust compiler to repro build docker images
#	b48ae58b56d73d86fb747af3a38a853923354bc6	# repro: Update ubuntu jammy reprobuild
#	0fac9d3082bb753cbadd936814e4cbe7fa4dba58	# py: Update poetry.lock using poetry update
#	9c3f4ffd44569b08ab6f377768ccc55cab8949d4	# rs: Strip binaries when compiling them for release
	84675218222f0f9164227c3580a1b0b940a11117	# rs: Add Cargo.lock for reproducible builds
#	b3fde870639494cd97d33b09c0a5d56ace4031b5	# doc: Spell out the reprobuild instructions for each distro
	43e5ef3cc462732529dba76645a198be1700a879	# libplugin: don't call callbacks if cmd completed before response.
#	aaf743e43849b7697ba4e2a8261d261963aa0605	# commando: fix crash when rune is completely bogus.
#	4cada557ba8dfeb4ba7f0220d68e91ec2bb5c8b1	# pytest: don't redirect stderr by default.
#	05a666e424bb9afc9bb0a128e512b82485d49627	# commando: limit to 16 partially-received incoming commands at a time.
#	c10e385612654246fea16cb32b9826af35bd8eb7	# commando: add stress test, fix memleak report.
	8c38302ab812e83236bad93302e9d2b7ba984824	# hsmtool: implement checkhsm.
#	53c333a01bbc00132090b7f57bc76c07063f03f7	# pytest: fix flake in test_zeroconf_forward
#	b6bf352503d3aa4e301a7d189103fdc65ce56a32	# contrib startup-regtest: turn off deprecated apis, update deprecated
	bb4da47131c9c578fdea52640653b2d8bce62256	# msat: cleanup msat outputs for apis
#	bed00754adc5f410232ac0537c32029e4f3f0ea7	# test-flake: dont let `l1` send their unilateral tx
#	9adf5f17de900a88f93b055a5ef14f01db11c02e	# tests:redirect output, so test log passes
#	4cc0da743286351063d566c11a0d44790912f720	# nit: speedup retry timeout test
	7bbfef5054ec222d6675b52fa6953e06aba6fef0:strip=tests/	# tests: flake fix; l1 was waiting too long to reconnect
#	8f6afedafe1af00eb91ab42ad5c09b3cfccbe0b4	# fuzz: fix fuzzing compilation.
#	d0c321b43a26596ff2a47f4d8ca808816f5a3b7e	# CI: fix CI scripts to fail if a command fails.
	0fd8a6492e1e233aa03dc5246b044a58a01cb309	# lightningd: fix fatal() log message in log.
#	da4e33cd0d17b84779aa2257e1df30f4fade6bde	# decode: fix crash when decoding invalid rune.
	9498e14530fea53167b4fa2488446643b60e7595	# connectd: two logging cleanups.
#	1480257644dfd8cda2405678b9b7be8c6629254c	# pytest: set dblog-file when adding the dblog plugin (TEST_CHECK_DBSTMTS=1)
	008a59b004486053c07bc269a928da00e807bc74	# lightningd: ignore default if it's a literal 'null' JSON token.
#	8da361b49b4a989d3a9ed16bb1151e7c9effe4a4	# pytest: fix flake in test_channel_persistence w/ TEST_CHECK_DBSTMTS
#	9aa9a8236f47f5721014546d051d1fc28c9758df	# commando: free incmd as soon as we use it.
#	0a9a87ec10a6f88e03d6117d4ea57c9d2c27fc62	# pytest: fix test_commando_stress
#	85180dbfeeee2ce3f159551b340e481339fd0944	# pytest: fix flake in test_feerates
#	17b9bd5ca366dbf9bbb1e10f083945f98fcae8f1	# pytest: fix test_commando_rune flake.
	b55df5c62648ceaae5bd8558c7a3ebaecfe5f3a2	# msggen: Use tempfile + rename to make changes to .msggen.json atomic
#	f4abc3a661fbc30bfd40debf7d4fd379d7627b3e	# tests: local flake fix; l1 was waiting too long to reconnect
	282ab72e2da5462cc431ed86f78b3c235aef91b1	# tests: valgrind barfing on uninitialized value
	d3ba01767279405e4202088d300ce05b0f0dc0b6	# valgrind: rm ref to cmd when cmd is free'd
#	2c2bcc8eb42ab798074a328696f9aa507ea665ed	# flake: permit test_v2_open_sigs_restart_while_dead to succeed/fail
	79a76a96f7a60616464937acf7e18b75b51e1061	# v2open: dont rely on ordering of interprocess messages
#	1c26ebdb31c32cb4b853067bb262b3dca4cb150d	# pytest: fix flake in test_wumbo_channels
	75c89f0b8e39a45cd1d2fdaa1b718e1f6ed0c3de	# doc: fix bolt 12 link (it's not in master), update bolt 11 to new "bolts" repo.
	967c56859f6cb15f13d077f7238458e1914e0c99	# sql: use last " as " to find name token for column
#	1a3bfc479fb44dbd9f512790ef72c18544355d51	# bookkeep: first commit, stub of new plugin
#	fb951dbbd6809656716b6768d11c8da73e12f74b	# bkpr: first attempt at database code for accounting
#	cd95d91ed593b9b0a2fbe78d4c4a10d1f64a8df9	# bkpr-tests: first test of plugin bkpr database
#	b08ccfec1e2c05c7c1b305b36bd0be795556178f	# bookkeeper: initial crud (no tests)
#	c12cd99039174336f3c3f2da7d9e0bad45ef8f1c	# bkpr: tests for db crud
#	dc113d0a3fd8bfe13616367f529c4bd1525e680c	# bkpr: create onchain fee records for events
#	351dc17e4602d20cd1a75323a14fa49cb87b38bb	# bkpr: add bookkeeper to PLUGINS list
	721ceb7519ab4e26efe51524b62f68bd110c2e1c:strip=plugins/bkpr/	# patch db-fatal-plugin_err.patch
#	b7d85f1d0b6412b8894b3c365c9b0ffa8b375ca0	# bkpr: wire up our chain fee accting to chain event reception
#	29c6884468face50146b6f9a6c215d52c729f25d	# bkpr: add journal entry for offset account balances; report listbalances
#	899d54edd0c77fc539578b7dbfe7d403d58a7680	# bkpr: have onchain_fee records be write-only, don't update in place
#	8ec35b7eb1d6023442da506ec369d8c9e00c8b21	# bkpr: turns out these fields are optional
#	d943e5e85cabae7f2611bd754f91fb0855cf78c3	# bkpr: use pointer for payment_id for channel events
#	ccffac8208fb3f83e241981ec0cb1672aa4d94b9	# bkpr: put the account name on the event
#	8039fde5ab308d2335f77d949413f9b9968fad26	# bkpr: if we're missing info about an account, add in journal entry
#	a1d72cef06f6809e7ec4cf5ea867d66dc8f00074	# bkpr: add a new command `listaccountevents`
#	8089f246c19b6ad2b93126d932ae6fcbc0dc7695	# bkpr: use tags not str for tag originations
#	307ea9359201f7c3f160eff4a1a6b93bd92f44c4	# bkpr: invert channel + chain event printouts
#	2a3875204a562ebed60af4270f77368d9599d757	# bkpr: parse the 'originating_account' field, save to event
#	ee8c04a63a30a5581bee4743cc67fe1d578844d2	# bkpr: update tests for wallet/external onchain fees
#	8c3347d1295b8508be9209a053b717128cb5e6a5	# bkpr: dont count fees for channel closes if we're not the opener
#	08d8de8e45f300670df11c811927bbf074a6698e	# bkpr: don't try to add fees if this tx didn't touch any accts
#	791c1a7526cf8ad961e2b6b93022f7f9d57dd325	# bkpr: cleanup wallet fee entries if decide they belong to a channel
#	f767e417552de228f24260752419b154fad99c16	# bkpr: listbalances, skip the external account
#	2385d8d6138598302d7e8471522972f2fd1d43e1	# bkpr: listbalances, rename 'account_id' => 'account'
#	8827423556efae882f95224ada5d67f23ff014d1	# bkpr: account for pushed amounts and record the output_value
#	fea33221d4f3d6cd0fd7f6e9b077150194280e68	# bkpr: once we get channel_opens, we might need to update the fee records
#	b33bd0552422c1676773c5e058ef78fcdb5f5484	# bkpr: add an 'inspect' command to the bookkeeper
#	7b6956e4f9af5e4281dd988458ccb6662107263a	# bkpr: annotate an account with the block at which it's been resolved
#	7d5a0988db4cc0196ad6b6bab3eb69a9c2dfab21	# bkpr: save closed_count for account, when known
#	8f869ade3cc4cbbbcb1132601d24f4e1e4306cba	# bkpr: use chain_closed count to do mark account closed
#	5f41d9247ef14d188ff04c8865dae5148a3574ec	# bkpr: properly account for onchain fees for channel closes
#	462fa20c17dbf6e2b4db2a0f911ad061bd16eb10	# bkpr: move json_to functions to respective type files
#	595c52f611aff9131c97cf4f088b76608cecb683	# bkpr: add timestamp filters to event lists
#	593f1e73651fccc574859934d32acaa6c63f47fc	# bkpr: add a 'listincome' event
#	25f0c76c9a30b209b4d7113c82ce88d6b7daf259	# tests: move 'bookkeeper' centric tests to their own file
#	1dd52ba0034c9ed86e8fb90ef6fc08ad58bf257f	# bkpr: mark external deposits (withdraws) via blockheight when confirmed
#	83c6cf25d2f773eef8db1fa830a53beaaebcab9e	# bkpr: 'to_miner' spends are considered terminal
#	a7b7ea5d493fef2a6f62d498fd9293cd985c46a9	# bkpr: add a 'consolidate-fees' flag to the income stmt
#	a0b34066e0b41d47e6a893ce998a697ce546491d	# bkpr: add `dumpincomecsv` command
#	12b5c06219cd09801349a90787b6fe6b747b4d4f	# bkpr: add 'start_time' and 'end_time' to `listincome`
#	c05900c6767c476fe40a1aac318277a9358132b3	# bkpr: add option --bookkeeper-dir
#	ee47715a1b0981c6103b398cd16dfc046a69e404	# bkpr: command to calculate some APYs/stats on channel routing fees
#	91ebddeb781aef221922dd42ad4a4a97df5473c4	# bkpr: actually fill in the current blockheight for `channelsapy`
#	d87bdeeacea73e7708f0fde24748c450df99da8b	# coin_mvt: log channel_open for channels that close before they're locked
#	4326c089279511f818caffc656104fec5171708a	# test nit: wait_for_mempool cleanup
	aa7ffb78bd8d3dcd9f3d04f69a81b8b3403e76b5	# wallet: resolve crash when blockheight is null
#	e7ed196f8737dc13479dec99bb676e8fe7c651b7	# bkpr: separate the invoice_fees from the invoice paid
#	eae1236db7deec275424957a554a33e07f196fd2	# tests,bkpr: liquid fails all these for different reasons
#	10e58a3788ad5a55031007c3ad5423dc68f3cf4d	# nit,bkpr: add a note about what the tag was to this printout
#	fec818641393eca0ec49f0cc104638d9340bbf6f	# bkpr: get rid of crash in `listincome`
	a3d82d5a0161fa7f2e0960a8817423cea9ee75b9:strip=plugins/bkpr/	# bkpr: exclude non-wallet events in the balance snapshot
	a45da6328010c3bdc441e51f8f9fbbe035ce6266:strip=plugins/bkpr/	# bkpr: pass the node_id over for channel_opens, add to account
#	2b3ef37590c40cf3704d0c92961ff8d2eceaae0c	# bkpr: don't use a minus in a sql stmt
	d885407e3e91fb64b5402aab46299dfc322726a6	# bkpr, elements: elements tx have one extra output for fees
#	e2ef44c043fff54eccc8a70b80a479c6c7b7292f	# bkpr: add 'msat' suffix to all msat denominated fields
	6dfba2468ab60e78c717e4a8b5079286aead9222	# json-schema: allow 'required' to not be present in if switches
#	563910e66798c18bab6a97be59660fc6ab601bab	# bkpr: add docs, change names to 'bkpr-*'
#	3dcfd2d0e48c0a8704518aebf3f119337f6b1888	# bkpr: account name is required for bkpr-inspect
#	cf8b30d2e8116c9697a17f1a5b63d6d04c85f8ec	# bkpr: print more info in bkpr-listbalances
#	d72033882f3237e7e3704128e05dc0080253aaa0	# bkpr: check for channel resolution for any "originated" event
#	0c2b43b6b2a5a27785108bf7519de53b6306261e	# bkpr: add more data to listaccountevents printout
#	c1cef773ca500484c0242ee317e1d81c6c3a4e74	# bkpr: make sure there's always at least on difference in blockheights
	0617690981e3ff8c49ddaff9c6a581bbe90fcff5:strip=plugins/bkpr/	# coin_mvt/bkpr: add "stealable" tag to stealable outputs
#	97204d6e0ad91b33506df2cd352678756b282961	# bkpr: duplicate the name, dont steal it
#	9346158290d715d3471b510bc1c99b325b0d4ecc	# bkpr: new method, "is_external_account"
#	38eb95ffee50fc1596e263e1ed08b7c1a3204203	# bkpr: more logging
#	67ce0ee3b2950445f85f6f19fcf95bfd6c8fa766	# bkpr: prevent crash when updating same account all at once
#	55e15c5f10ceef410e247450c29c3ae7c6230874	# bkpr: correctly pass in command for `jsonrpc_request_start`
#	2d22bab87922cce431e1c0e7fb4e81fc8b913b18	# bkpr: fetch originating account, if exists, and make sure is populated
#	ab94c557c7967f9843b74e2c2e35233c58acdf49	# bkpr: add test for bookkeeper being added after channel has closed
#	5c45939acf6ec48864dd13352b6ae3a450edc3f4	# test-utils: add the bolt11 invoice
#	352b419755b82c48b7596e3f22ee88dd5c98074e	# bkpr: save invoice description data to the database and display it
#	5146baa00bed5823617c3663a7d7f9acff177106	# bkpr csvs: koinly + cointracker only accept fees on the same line
#	e5d3ce3b1f1373f6b4e136f5272739a38b92c56d	# bkpr incomestmt: properly escape things for the CSVs
#	3c79a456c0c15abe8c980153d4fe8d6c8fccd6fe	# test-db-provider: if postgres in tests, startup a bookkeeper db
#	71c03bc082d82c96ea81071ed741222756b5fdba	# bkpr: Add an option to set the database to something else (postgres)
	305a2388108e638a7c24c097be4a5814d081dc52:strip=plugins/bkpr/:resolve-conflicts	# plugins/Makefile: put bitcoin/chainparams.o in PLUGIN_COMMON_OBJS since everyone needs it.
#	6a22411f7e3daa8287c5ec88eeb498d3a09c5a63	# doc: note that bookkeeper-dir and bookkeeper-db are in bookkeeper plugin.
#	1b5dc4409ae7d47b6e7d51d6224b24db58768af4	# doc: remove two more generated manpages.
#	30aa1d79fb48a2f28c04e6af191e31b6fd686165	# bkpr: for zerconfs, we still wanna know you're opening a channel
#	e048292fdf0a50854da40079af8f01f1a89e8537	# bkpr-zeroconf: Zeroconfs will emit 'channel_proposed' event
#	2f72bbbbc512a1b88e8eef1948dfb3b8004a0338	# nit: send_outreq returns &pending, no need to call sep command
#	c83c1521ced54a5a7c72ab0033576c45fc234d18	# memleak: throw away things when we're done with them
#	6e9af1ef3ec51f93417e375b2f52144f3c5e78cb	# bkpr: cleanup csv_safe_str
#	a2596989062b32dbc1cfbeeb05db20a2c2a612f9	# pytest: test that we don't try to reconnect in AWAITING_UNILATERAL.
	9cad7d6a6a71f13cc7665c295da3c57747ae51c9:strip=tests/	# lightningd: don't consider AWAITING_UNILATERAL to be "active".
	22ff007d642d6b716fbbe6c2b210878775a9d760	# connectd: control connect backoff from lightningd.
#	8c9fa457babd8ac09009fb93fe7a1a6409aba911	# pytest: fix flake in test_gossip_timestamp_filter
	78804d9ea82b66dfd5095e745c3ca08d1a5c6d30	# fix doc: deschashonly
#	10d66c25c406b713c36aa9e10001ebb25bc69f2f	# commando-rune: show warning when creating runes with no restrictions
	a675f4c24e55fe40f558be40e286bb6615c2f5e7	# balance_snapshot: emit balances for channels that are awaiting_lockin
	4e503f7d0a27655edbc0db5af7ca4fb87da1d2d9:strip='\(contrib/pyln-testing/\|plugins/bkpr/\|tests/\)':scrub-stamps	# bkpr/listpeeers: add lease_fees back to funds; separate out in listpeers
#	3445882ee450eb4cc26f895f5222c4714112cf2a	# bkpr: use long-uint not size_t for time_t
	2971b2af79d7ab5a3e67cfe27ac735cf7e9612ae:strip=plugins/bkpr/	# bkpr: insert obscure 60s pop references.
#	dfa325dc4dc711479cbc7f9402e96e46b26950d8	# bkpr: make unit tests not fail if !HAVE_SQLITE3
#	75ccce7808aa4acacbc9357bc3cb331190688e73	# devtools: if there's a message in the API call, print and exit
#	31ba3007bdeecebecaa356948ca5d1249a672f95	# changelog: v0.12.0rc1 release notes
#	071b1bc4f1ee90480ba29ada771cbf9ae6007eb2	# pyln: update versions to v0.12.0
#	cb496acb491496d0de5058ae3fa137f92df7b603	# CHANGELOG.md: neaten entries.
#	4ffae2a8c69bb6739707fb8539ee2a6f4eea6c16	# CHANGELOG.md: note the Great Msat Migration!
	498f9b75f25a0778a6f3025565adeb8092a117c4	# Correct basics of backup plugin usage
	645b1b505b6d0a93da45007c6825abe032f84ac6	# lightningd: fix funding_locked in channel_opened notification.
	2632cddfe46bc35f76796ff1c1154b82a6870cef	# pay: Fix a memory leak when retrying getroute
#	66d8ce7c8c183ed1b84052ca3531616e56f9b87b	# pytest: clarify test_onchain_multihtlc_our_unilateral / test_onchain_multihtlc_their_unilateral
#	b5ee5e7fb1f30fa2e366903fb5bbbab2e7ef5909	# pytest: simplify test_onchain_multihtlc_our_unilateral/their_unilateral
#	93303ffdad050ad76398380130918f10a1b0c873	# pytest: change multihtlc topology for simpler testing.
#	5260ea29114f9bf0c4bc99295231447218a4f896	# pytest: make sure we never break channels in multhtlc test.
#	ffb3217ea8c2f533345708e097432fc654d05058	# docs: clarify the different way to build cln
	e0a48c2aa7b50391c200b414fbb4cdb1b08188b6	# am_opener unused
	d5d4e7b0195b8a6ad2e1065f605b2c2990fc0c0d:resolve-conflicts	# common/features: add channel_type definition, neaten header.
	80a6d9b58e3f3dd9e5fbb2087c83cb717e1e5469:strip=tests/:resolve-conflicts	# lightningd: set the channel_type feature.
	aca9c7d49ca787ad478dbbe19846b7206fa73a6d	# pay: Annotate suspended payments with the groupid they mirror
	093933b14d4d199267eb414072721704fc78428d	# pay: Do not replay results against payments that were not suspended
	65a449e2c384ec1b86a7b437d6df82054b4c75a0	# pay: Remove use-after-free bug
	da0b651803f47b3e45eb5be55d728d5e6398e298	# pay: Use safe list traversal when completing suspended payments
#	3fcf60ab7c2450c46551c1f00b52d2b17d9f7018	# bkpr: track channel rebalances, display in listincome
#	016ce2b925c9d864017ffb6e65e37957b56128fd	# build: ignore docker/image build directories
	25b4249f540cc85b8b6c44ca17637548997f27b7:scrub-stamps	# doc: fix decode schema for bolt11 routehints.
#	b479e9a9faf02ce2ea5c8ae22474d9f641b1d0a2	# pytest: test that we implement option_scid_alias privacy.
#	cfe6b06fb567236c7c7041ff66598053c8effe84	# lightnind: use aliases in routehints for private channels.
#	8a9ce55345b2a0e73758dcaac574d3f9dc2acafa	# lightningd: don't route private channels via real scid.
#	9543204b7922d813418d52756d25c912e671e08d	# pytest: don't use bogus scids for first hop of route.
	054339e0cb66d0fa89ee205ab869e4f91c780d32	# lightningd: obey first hop channel id.
	fcba09dc335a20d313d7e24c5e81f07e9745dda8	# doc: document that sendonion doesn't have to specify (but can!) the first_hop channel.
	1ff8e1bacb1e90f14ed72e3d52919f8185458324	# doc: note that setchannel maxhtlc/minhtlc only apply to *forwards*.
#	23cd58402a9185fc7d4e03e9e973e816187109c6	# bkpr: create accounts for zero sat channels
#	256044081f92916c098978ccbb63fb4211fcf520	# bkpr: remove duplicate log stmt
#	72a30fc7505e7fd927b19cea0fbfcbf5550ac07c	# bkpr: dont flake, wait til pay done before mining blocks
#	9d3bf4a1b5565441730804850a899b6a3ea4cfdf	# bkpr: let channel reconnect, flake?
#	b173b2934687d076b37c888924501e3d86382bd5	# pytest: test loading lease_chan_max_msat from channel_funding_inflights
	eb006dcaddd2539cfa5413798131833df1072ae8	# wallet: fix incorrect column-width access.
	0878002fe6669f3ebf23e907c6cdd402f2c96e44:strip=tests/	# Fix derived_secret, use correct size of secretstuff.derived secret
#	04cb6316d5dfa57af63f23a3126cc1717928108d	# CHANGELOG: v0.12.0rc2
	63f8c74da90430066999481322a78ec46a3106a8	# psbt: dont crash when printing psbt to log
	498401457843aceeea7b952209bafba1a66d8337	# signpsbt: add utxo info to inputs
	4e7f89f211523e2fac8ce0435137b17a255133c0	# signpsbt: don't crash if HSM doesn't like your psbt, just return err
	fdfca9e7212eb7a4521ab4517a85964c9c65be29	# sqlite3: no NULLS FIRST
#	1a2565118240c25389645ef8b0108869241bcfb5	# bkpr-recorder: fatal if there's an error with a database statement
#	ab1ca7f1591fa842aab7544f3bf9027b6bcf7332	# pytest: Reproduce a crash when we have multiple channels and 0conf
#	65549a293197894c641831c3c5b051a9f3724e8e	# ld: Fix a log message assuming that the `channel->scid` was set
	82f703552455549f7470e6c9fab136c5a95b2225	# Renumber hsmd_derive_secret for consistency with other hsmd messages
	9219e778a1e76335942173597f59e80974389780	# doc: update usage of lightning-invoice.
	23b675922ff6d3c8b346a3c145d48e64750fb101	# lightningd/opening_control.c: Skip over channels which are already stored, and don't create new peer if it already exits. Changelog-None
	0b737fd7e57749d7ae8864ba1d8ac6e3f93ab4db	# doc: Typo
#	8f78a76d1a4aaf82b112804946fcf6bd21bea28f	# tests/test_misc.py: check logs for already existing channel.
#	aabf38a11dccfed11ae54a150fcde3b8000e4b5b	# ci: Fix the Mac OS build test
	7c9985fd9c0c532581a46a75a1fe43ecb9013850	# channeld: correct reversed shutdown message in billboard.
#	8cdbe97d9174737117d5ef7481d4e88539496425	# v0.12.0rc3 - Release Candidate numero tres
	c13dffe980938228dda15b7c3ce3288cf6caef55	# fix MD link where text and url are swapped
#	ce9232af37a75d773cce9518236398c00888466d	# Changelog-None
	fd8b667e6a087edebe8907d249180c4e26c58337	# use 'postgres' driver (not postgresql). Include plain url to guide, as link is broken on RTD.
#	3ce26735e5143fa9532247156f8e97291cb2a225	# v0.12.0 release changelog
#	0abe2e3af1ccd9941992266b65f85aa32d3ccb23	# pytest: Add debugging to test_gossip_store_compact_on_load
#	397c8804261690e1e8864c533b263d273fbb6f4b	# Add Arch Linux build instructions
#	ba76854e2964365cdb534fd55e7f60f647761ce9	# Add Arch Linux build instructions
#	299a99ed6745bf618d9897700fd45f21ba1539c0	# Use unordered list
#	d4a04ba8b316e7653c909eb0af0490d41f966bc8	# Simplify poetry interactions
#	6a7d40f51a9ba74f1bbb1621cc5a7b1d06580cca	# ccan: update to get -Wshadow=local clean build.
	6fe570820e66491778b9e60d2b2942bbffbee813	# Remove general shadowed variables.
	44d9e8d9c5e738f99eba29d194e8972799c57e7e	# Remove names of parameters of callbacks which confuse gcc.
#	2c722291069dd5cf5a65288ed3131f96daed5b05	# configure: add -Wshadow=local flag.
#	0d5808b6f6ed23e724e8b1c283c557d69a4adaa6	# pytest: fix test_channel_state_change_history
#	ea414320a3db540889eb9ec0854638a685850ad2	# build, shadows: fix broken build (no shadows)
	c4203e7de6f35ed1cd1658d7c898b8b6bfaac2df:strip=tests/	# pyln-client: allow 'msat' fields to be 'null'
	dc56b2a9ac05ccf810ec27b31ba4f87bd0ee32cb	# connectd: better diagnostics on invalid gossip_store entries.
	8e57bf379661648bdcaf3d42b17986393734e14e	# tools: add md2man.sh tool, using lowdown.
	2e48722f378657332691e33fc3fe868ad19dc57c:scrub-log	# Makefile: replace mrkd with lowdown(1).
	50056ce9182d4c8865395e5a50e294c59124be6b	# doc: remove mrkd requirement, add lowdown requirement.
	3c3f4731bd31624250464a5ce0819a53cb3c9495:scrub-log:resolve-conflicts	# doc: format markdown correctly.
	8f1164365e7688ac923ddde6ea5b4a7cdf2ced3e:scrub-log:strip=doc/lightning-commando:resolve-conflicts	# doc: generate correct markdown from schemas.
	bcabb3825fd9daa351f1d56db23eb7dde8c9ab21:strip='.*\(bkpr\|commando\)':scrub-stamps:resolve-conflicts	# Makefile: Revert ba7d4a8f6bab5a3d5e5832d1f9e36749e695320a (make-schema: don't include tools/fromschema.py in SHASUMS)
	04b59d991ab2e643e9b1eab204a96ec820e3f906:strip='.*\(bkpr\|commando\)':scrub-stamps:resolve-conflicts	# doc: always escape underscores in property names
#	5112329a6b4692974770aaed0e098444f348e599	# external/lowdown: local import of lowdown source.
#	50d1043a91db4343eb3a445e6f0611afc19c4032	# external: build lowdown if not already found.
#	cde93ab703b43189fe2559f3867bd524c9ae8c28	# doc: document that we can build lowdown, remove from Alpine.
#	9de458b23b5b761cb98307f62c5fa8fceea1e55c	# docs: Clear up Ubutu documentation
#	34a0d7083acf66ca69ff3e9e66e73ff86b4de22c	# build: use ubuntu 22.04 LTS
#	7df530d18463d3937cc5b188d2158b56dcf6cb2d	# builds: cleanup duplicate and unused code, fix spelling
	ec95c7c18c9200145545de0b491db3cc2f51bb28	# peer_control: fix getinfo showing unannounced addr
	c6858748bb7d9446d45275ab3f86f7cc8cabb28b	# cleanup: fix mixed indentation of json_getinfo
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
	1b30ea4b82b1fe5adbdedfc31322bcf3e0c8ac08:strip='lightningd/onchain_control\.c\|tests/':resolve-conflicts	# doc: update BOLTs to bc86304b4b0af5fd5ce9d24f74e2ebbceb7e2730
#	5b7f14a7cb2cf4fd097a9169a115efb6575dd48e	# channeld/dualopend/lightningd: use channel_ready everywhere.
#	b208c0d8dd4bc6d7b0291183c3e36cd87dac0de8	# doc: upgrade to BOLTs 2ecc091f3484f7a3450e7f5543ae851edd1e0761
#	3cc6d0ec2c9cdcce975309382cf5c115c4a9c113	# doc: upgrade to BOLTs 341ec844f13c0c0abc4fe849059fbb98173f9766
#	4ca1203eb8c5d5d447b1972722c98980e9b9111a	# doc: include recent BOLT recommendation on grace period.
	2ac775f9f4343338a0782a07d446920582f576b8	# lightningd: fix crash with -O3 -flto.
	2c3d4e46fcb16e89c48df7ecc54056bc5cdde317	# tools/test: fix very confused code.
	bef2a47ab7a1acb01582d33db406cf0b6e06b8ac	# db: fix renaming/deleting cols of DBs when there are UNIQUE(x, b, c) constraints.
	fb433a70f8b0de0e771de1f3378ee8f3e3bbef58:strip='.*\(bkpr\|commando\)':scrub-stamps:resolve-conflicts	# doc: escape output types (esp `short_channel_id`).
	b3b5b740694f28c6daf4846d26ee9e1967ba3596	# libplugin: allow NULL calllbacks for jsonrpc_set_datastore.
#	6438ee41267bfb7f7adb1f9fd938ee744dfb3840	# doc: disallow additional properties in sendcustommsg.
	d7aa2749c3f2d596a33f8e86de8d276410b4aa9b	# db: fix migrations which write to db.
	e853cdc3ff3732629c912eb5b4ab880944d3ccff	# db: fix sqlite3 code which manipulates columns.
	375215a141f60ed2d458cd8606933098de397152	# lightningd: more graceful shutdown.
	e0d6f3ceb1775a96672d9a7eee730f2b6c6a1e2f:strip=tests/	# connectd: DNS Bolt7 #911 no longer EXPERIMENTAL
#	8452d903b4514adcea9b7c554b0dba3669fc1eda	# bkpr: failing test for bookkeeper crash
	1980ba420b1e79dc360add83ee4c2b791ac59131:strip=tests/	# notif: dont send balance snapshot for not yet opened channel
#	c143914ebf7b4881ec6f1f1b1f66e6ab6947a050	# bkpr: migration to delete any duplicate lease_fee entries
#	efad09f96652557df4f23b8ab71f1c7c1a593ce5	# bkpr: confirm that replaying the open+lock-in txs at start is ok
#	3ad8347969cce2b6f5b9b16ba8821d8413f9cb42	# bkpr-test: maybe fix race in test_bookkeeping_closing_trimmed_htlcs
#	daeec66bd7815d73f0e00b8610bd024d54be7ba8	# db: Add completed_at field to payments
#	cb3ee0ac2ea126092775e46b56e4ed8650b4c23c	# wallet: Load and value `completed_at` timestamp from DB
	a80211e960f6e8135170d9753953e1703d85403c	# doc: Update generated artifacts to match master
#	246e1fb0b3db11af1c9286e0f0ae635658c14f33	# wallet: Set the `completed_at` timestamp when updating the status
#	f64d755e435dd739b041ff05c062959e4f84c048	# pay: Aggregate `completed_at` in `listpays` and `pay`
	4167fe8dd962458c9ceacdb6c79832e3e8fad26f	# gossip_store: fix offset error
	746b5f3691525a37f837fdabd8bd967e8683834b	# Makefile: fix msggen regeneration when schemas change.
#	897245e3b7646987980a3246de03c089e3e82bd1	# pytest: test for escapes in commando values.
#	1f9730748cf747655783adacabba4ae6c65d53aa	# CCAN: update to get latest rune decode fix.
#	d57d87ea3a5f5d30e855cdc6e4a131ee3af70f62	# commando: unmangle JSON.
#	a6d4756d0876fba4d9739d22b75cc314dce23206	# commando: make rune alternatives a JSON array.
	023a688e3f1ebdf1b41ea97720b0ccccf7ccbfaa	# lightningd: fix spurious leak report.
	112115022c75940035ba7d5d70193ea81456f3c3	# gossmap: don't crash if we see a duplicate channel_announce.
	9b33a921f04b70a25c0979db3ad4c98f49db98c6:strip=tests/	# Add plugin notification topic "block_processed".
	1ef8fb7ef8b9f52d8167dd35e00776cab8cfb222:strip=tests/	# rename `block_processed` to `block_added`
	0a856778bcbf3bfeffc3d0bc6eaa57ce2cdf1f11	# plugins/bcli: load RPC password from stdin instead of an argument
	4ca6b36439074f41729da679815792ee73b5fb24:scrub-stamps	# lightningd: refuse to upgrade db on non-released versions by default.
	c8ab8192ca65a2b3ac3153dd881309a4dee76e2c:strip=tests/	# peer_control: getinfo show correct port on discovered IPs
	532544ce4fa859037faf177b0af4b01a9025e3c1:resolve-conflicts	# gossipd: rename remote_addr to discovered_ip within gossipd
	5d259348657324dbfb2e3bcb4bf8a6280e8d6533	# plugins/Makefile: regenerate plugins list when config changes.
	88354b79bd5bd067abea32781865a2644cc74bcd	# common: helper to get id field as a string.
	6c07f1365fa8adfb1e8f5f896177c88ec15be924	# lightning-cli: don't consume 100% CPU if lightningd crashes.
	2d7cf153ad4b99656e34eea5e8348d829c77fe23	# lightningd: log JSON request ids.
	87112415356ac08ac59de05af3b9a17e418feab3	# lightning-cli: use cli:<method>-<pid> for all requests.
	db89a3413592eafcf424d7d8cdabc0be2ba52178:strip=plugins/bkpr/	# libplugin: allow lightningd to give us non-numeric ids.
	bd18fbc4882e9723f47f185f4b4cf4abcd242371	# contrib/pyln-client: allow lightningd to give us non-numeric ids.
	ce0b765c9604e8bb74a3dc88db1451ace9a3f378	# cln-rpc: allow id to be any token.
	99f2019a24738fa4f7b003d345e73813c76d393e	# lightningd: add jsonrpc_request_start_raw instead of NULL method.
	ed3f700991ce9c8b1a41cdff24d5d250f8190426	# lightningd: use string as json req ids when we create them.
	8fcf880e0ff6acd37e1d887a9e46166c260fb23e	# lightningd: explicitly remember if JSON id was a string.
	a9557d5194f8aa6b41c2c35a6e17d47bf9d87e37	# lightningd: derive JSONRPC ids from incoming id (append /cln:<method>#NNN).
	ea7903f69a2df3ac51e25422f7d111bea9f693c7	# lightningd: trace JSON id prefixes through sendrawtx.
	eceb9f432814830b7b84e8a9b1f4c9eefdbe60cd	# lightningd: wire plugin command JSON id through to plugin commands.
	e8ef42b7418c23e68b9ed8e9f8b990dd5daf05d5	# plugin: wire JSON id for commands which caused hooks to fire.
	d360075d2231865b7a20645cbd4ec07ed04a27fb:strip=tests/	# libplugin: use string ids correctly.
	f1f2c1322d750361c2751cd63acb8dff51580c6b:strip=tests/	# contrib/pyln-client: construct JSON ID correctly.
	fdc59dc94a69066a5b4c4a2209f9a352214a6ddd	# contrib/pyln-testing: pass through id correctly.
	bf54d6dcf58733399d240fbddf99380882f49674	# libplugin: use proper JSON id for rpc_scan().
	42c9aa1a5f683fbee50b84a1cd677814ba97f98a	# libplugin: forget pending requests if associated command freed.
	caecd1ee0aad1b391b3019c78a7e075165061bcf:strip=tests/	# lightningd: don't log JSON ids as debug, use log io.
	bbe1711e1683739dbfea07c81dabe594d7c98b08	# lightningd: use jcon logging for commands where possible.
#	74cd0a72801967f2c459c7613c4d8ca604f17fb9	# gci: Use stable rust instead of nightly
#	37c07ddfe5cbe63dadbddb4e6d29ef9ec76221f2	# pyln: Add grpcio and protobuf dependencies to pyln-testing
#	37fc0d8c6f9b6b7de6e9dbffe61d3d3db162cb3a	# docker: use pip install + poetry export instead of poetry update
#	05e23171421eb47466af7920af36eaa74deac21b	# doc/install: get rid of out of date mrkd / mistune install instructions
	cc206e1f0e281b33cf86e1eede5f3545fdcec2ea	# connectd+: Flake/race fix for new channels
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
	3380f559f9cca7f6085c3b01af6a74fe1eac04a4:strip=plugins/commando	# memleak: simplify API.
	701dd3dcefd7a005e042c310a902f4b3dea15e61	# memleak: remove exclusions from memleak_start()
	5b58eda7486d2fe613396e197d9a538f84a85820:strip='plugins/\(bkpr/\|commando\)'	# libplugin: mark the cmd notleak() whenever command_still_pending() called.
	248d60d7bd7e9a1961e70a3579ea93a0d496d6cc	# Don't report redundant feerates to subdaemons
#	ab95d2718f1dfa1f0190159e2ba56c5ffdfc84fc	# pyln: Reduce dependency strictness for pyln-testing
#	fcd2320de7be182af0ed4c04409165bae912d38d	# gha: Make the setup and build scripts exit if anything fails
	7159a25e7358a6eae4ca2f3d1c64407ac304bb96	# openingd: Add method to set absolute reserve
	5c1de8029a0b48ab69f394384e750dc89c1a89b3:strip=contrib/pyln-testing/	# openingd: Add `reserve` to `fundchannel` and `multifundchannel`
	9a97f8c154dfc84e69d494a1a72bfdc00041de5a	# plugin: Add `reserve` to `openchannel` hook result
	8d6423389a4d58bafde6af417c7b52add0475d32	# openingd: Wire `reserve` value through to `openingd`
	5a54f450bdc5f659f9e8dfae27d931cebe9d462c	# openingd: Pass `reserve` down to openingd when funding
	2def843dcea8ea70b9b5a80763a10f4cc6378bdd	# pay: Allow using a channel on equality of estimated capacity
#	c3e9cb7a47a1497a32c0c0fdc49209674d1155de	# openingd: Add zeroconf-no-really-zero mode
#	c5b2aee5c69071141fb99ead92a437d7b3e46816	# pytest: Add a zeroreserve test
#	67467213cb246386c9615add6ecff3dbca7c2249	# opening: Add `dev-allowdustreserve` option to opt into dust reserves
#	1bd3d8d9f98991c1958dda66ffaae3e0887fbd98	# openingd: Remove dust check for reserve imposed on us
#	54b4baabb00d046c0725aeabb2b1737143a896c1	# opening: Add `dev-allowdustreserve` option to opt into dust reserves
#	bdda62e1a44ce4be0cc6a3ec9507d21cef291b91	# pytest: Add test for mixed zeroreserve funding
	759fcb64a8c28a90a7659c2b1791ce9993067796	# pay: If the channel_hint matches our allocation allow it
#	493a0dfcd4e4ec8f53389b837b07c85be82efb30	# pytest: Exercise all dust zeroreserve case
	75fe1c1a668cc80e63ca13bb80cd448f2ad7491f	# common: Add multiplication primitives for amount_msat and amount_sat
#	774d16a72e125e4ae4e312b9e3307261983bec0e	# openingd: Fail if dust and max_htlcs result in 0output commitment tx
	5a1c2447cb9d4bfe3970ecac6df6d5849bfab0c4	# pyln-client: use f strings to concatenate JSON ids, handle older integer ids.
#	0db01c882f11de1f683ee1cf00e91c4f7fc5d725	# pytest: fix flake in test_sendcustommsg
#	43556126467126ee60fd629482db6747b15ade08	# gh: Mark some derived files as such
#	41502be60ac619dd78b64b15987029182171a134	# Fix a small typo
	ce0f5440733901984672757c9e4b1f93854c4e97:strip=tests/	# keysend: try to find description in TLV.
	df4b477e88d2b93bb030d27b23ea9f12c9b3031c	# keysend: allow extratlvs parameter, even in non-experimental mode.
	0868fa9f1edb2cb7430ca5ecf436ecfead0ac459:strip=tests/:scrub-stamps:resolve-conflicts	# lightningd: allow extra tlv types in non-experimental mode.
	775d6ba193497dac5526fd6e6b6f9bc8eb656dee	# doc: Fix wrong_funding description in manpage and type in schema
	b9a7f36ab3cc44b3b69711592002490088ceb3f8:strip=contrib/pyln-testing/	# msggen: Add conversion from cln-rpc to cln-grpc for Option<Outpoint>
#	910116c9e6cd6074864e995da59308aafaa995cd	# build-release: configure before submodcheck
#	3c80b22d6fd6d6c0e4cfcd550adeaf7da7e3652d	# pyln: use poetry version, add target to check version, use poetry publish.
#	0514269f48f37c49c2df49a5733fc15dcb09f647	# Makefile: add targets to upgrade pyln versions, push releases.
#	7c2c100145eea0abacffabe42bbbfde3fead1fd3	# pyln: results of make update-pyln-versions NEW_VERSION=0.12.0
#	aace5b51efbc10e6908c7e6242de6c1264dee7a6	# pyln: Adjust the auto-publish task to trigger on tags
#	8ae0af7962b4e19064d5bfa6341ef7816dc749b1	# pyln: Bump pyln-client dependency in pyln-testing
#	4693803c355db5cfa93ebd188a8a2232ca6e9535	# ci: Use the new make upgrade-version target to manage versions
	41a52929f7ac6a2ad0cc771d477efbdf42b9d285	# libplugin: handle JSON reply after command freed.
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
#	7420a7021f4805d8b8058e86eec791f4ce3e27fa	# lightningd: add `listhtlcs` to list all the HTLCs we know about.
#	3079afb024e9307a696046d0e936ff240a5f4c86	# lightningd: add `delforward` command.
#	a15f1be5f88bdae5a6e816026e35a035791875e8	# autoclean: clean up listforwards as well.
#	399288db3f2a90e52fcea587424c1287705c69d1	# autoclean: use config variables, not commands.
#	612f3de0d4a07851c8f25ed8e2c359ecea7e3e2f	# doc: manpages and schemas for autoclean-status.
#	13e10877de9dde1b5aa784894a15a4611b62a46a	# autoclean: add autoclean-once command.
#	540a6e4b99c5c0b5b49dbd6b1c604f599eb45718	# autoclean: remove per-delete debugging messages.
	4d8c3215174e1436dccb66d60fa69536f3b4d31a	# libplugin: optimize parsing lightningd rpc responses.
	8b7a8265e7ad80bb0e1882ad5dffada14f7425df:strip=plugins/bkpr/	# libplugin: avoid memmove if we have many outputs to lightningd.
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
#	45cdfd2ff75c8d0f73deb2a24c81575760619fce	# BOLT: update to fix gossip pruning quote.
	fe556d1ed9b11087ecfdfc86f00e9397c2db7973:strip=tests/	# gossipd: don't try to upgrade ancient gossip_store.
	3817a690c9708b1873264582d66a39bdf358e0cc	# gossipd: actually validate gossip_store checksums at startup.
	6338758018ee5b199c56fbae8ffb09813d94dd6c	# gossmap: make API more robust against future changes.
	daa5269ea259a855dac282c17c83e0eff09821b5	# gossipd: bump gossip_store to indicate all channel_update have htlc_max.
	253b25522b4c0eb33064e0d35070d6148e053776:strip=Makefile	# BOLT: update to version which requires option_channel_htlc_max.
	bb49e1bea586991f6e4cedeb277c3aece2593b25:strip=contrib/pyln-testing/	# common: assume htlc_maximum_msat, don't check bit any more.
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
	6e86fa92206eb6e935a8dcba37b9e7849d2cc816:strip=tests/:resolve-conflicts	# lightningd: figure out optimal channel *before* forward_htlc hook.
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
	8771c863794d2774e93ea759f4eb23873a236112:strip=plugins/bkpr/:resolve-conflicts	# common/onion: expunge all trace of different onion styles.
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
	0195b41461dfedae09ca5cfdf8cd1abae8d4a174:strip=tests/	# pytest: test that we don't change our payer_key calculation.
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
	38e2428f12af69bbd9af145d969eaca6c6ade99f:strip=tests/	# funder: use utxopsbt to build psbt for RBFs
	efd096dc96f156b6b223be4f32c638bf3fc7ab64	# funder: filter prev-outs such that we only use still unspent ones
	e00857827fd5b45a3022753edf855df4765a4e93	# funder: cleanup datastore on state-change/channel failure
	fee9a7ce04bb20c8e77e3d01a190e636156007aa	# hsmd: introduce a simple API versioning scheme.
	987adb97180848908ec54ff43d3b564f1a40c45a	# Makefile: check that hsm_version.h changes if wire/hsmd_wire.csv contents does
	bed905a394dee7f7584628b6389b3f202fd0112b	# lightningd: use 33 byte pubkeys internally.
	4e39b3ff3dfa2e552b0c0bfabee2853e4a38248e	# hsmd: don't use point32 for bolt12, but use pubkeys (though still always 02)
	7745513c5106fa1cc5ea568527594b96e4ff3d52:strip=tests/	# bolt12: change our payer_key calculation.
	82d98e4b9696093c19bf040b4b298f7a24dadaa1	# gossmap: move gossmap_guess_node_id to pay plugin.
	eac8401f8486b7d61252831bc0bccdfb41c43896:strip=plugins/bkpr/	# Makefile: separate bolt12 wireobjects
	e30ea91908c58018f775a92179d150a0f2f6d71a:strip=tests/:scrub-stamps	# BOLTs: update to more recent bolt12 spec.
	1cdf21678e00897ea288907c051c124d11bf66ae:scrub-stamps	# offers: print out more details, fix up schema for decode of blinded paths.
	662c6931f3b44c5f21f8a05f8ef911cdf952fd92	# Remove point32.
	56939295de342d4b8a887e2eefcf46336c0a6107	# wire: add latest Route Blinding htlc fields from https://github.com/lightning/bolts/pull/765
	1d4f1a5199334ef81c26a04a980279c6083f662e	# common: remove old route-blinding-override test, update route-blinding test for new vectors.
	85baca56c6d0119b7c65ed92d5d30006d14ce99a	# channeld: don't calculate blinding shared secret, let lightningd do it.
	53e40c4380df362ac2fe6b7107d011898e26eca2	# common/blindedpath: generalize routines.
	c0ae2394d85da90e565450aa56dbe208e3dd02ae	# common/blindedpath: generalize construction routines.
	c94c742e581f767e16f5c7f41afe4c82873a2cb5:resolve-conflicts	# common/features: understand the route_blinding feature (feature 24)
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
#	f158b529d3e4c56b70c44aaebc821c1f15477fa2	# wire/Makefile: fix missing wire/bolt12_exp_wiregen.c in ALL_C_SOURCES.
	83beaa5396acd15874311bce4b01431e583a6113	# json: Add helper for quoted numbers
	8a4f44a58dd0f0514f9b05c8089cb5ac6f16f3a4:strip=tests/	# keysend: Allow quoted numbers in `extratlvs`
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
	f0731d2ca11ee647566bd6fc11809c9519252cf8:strip=plugins/bkpr/	# common/json_stream: support filtering don't print fields not allowed.
	3b4c1968a3d9b5333c31d253f3d1d951b25506e0	# common/test: add unit tests for JSON filtering.
	2a14afbf216f5964e01a1c347e798461bb3ffe2c	# lightningd: set filter when we see 'filter' object.
	1436ad334d59612bc3f1e323023724d793b24e59:strip=tests/	# pytest: add filter tests.
	b6134303d467becc58136d30fc9ddf06f93fc50c:strip=tests/	# pyln: add context manager to simpify filter use.
	cb1156cd328f31e068e09afe0667784ec21a1077:strip=tests/	# libplugin: support filters.
	c31fb99d2d705dfa793c0aa45f860cf5af67b7cb	# doc: add lightingd-rpc documentation.
	ae3550cb00c3a8539a58d5d272d921c748da2ac5	# lightning-cli: support --filter parameter.
#	d60dbba43bf2dd69360aa9b98bddcee3952ab984	# tests: test for coinbase wallet spend.
#	26f5dcd2a5af21ca9a902084872014566497058b	#  wallet: mark coinbase outputs as 'immature' until spendable
#	adf14151fa868763d7b4ff05032cf45f3115312f	# wallet: Use boolean to determine whether an output is coinbase
#	eb122827f6c82ae2fa1852309b53a511b7397706	# wallet: Add utxo_is_immature helper
	2760490d5d4fcc20f6b404fc90807ed756d7114d	# common: catch up on latest routeblinding spec.
	987df688ed4aca0d806e2da179b4c69386b3ace2	# lightningd: don't return normal errors on blinded path entry, either.
	c5656ec90a788b87280b910ecc7aa664986f960d:resolve-conflicts	# common/onion: handle payment by node_id.
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
	846a520bc238c9011a2e7acbe30561ffe4e10f29:strip=tests/	# offers: remove 'send-invoice' offers support.
	1e3cb015469088880e7976647fd5625598434c5e:strip='\(plugins/bkpr/\|tests/\)':scrub-stamps	# bolt12: import the latest spec, update to fit.
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
	d5ce5cbab302fcc3f88e78a4c3132705d3cc7867:strip=tests/	# lightningd: only use non-numeric JSON ids if plugin says we can.
	ece77840f906bba94d77889d651dd39208c9127d:strip=tests/	# pyln-client, libplugin, rust cln-plugin: explicitly flag that we allow non-numeric JSON ids.
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
	ec025344cc03140f18161cf3ce38e0c9e18c7695:strip=tests/:scrub-stamps:resolve-conflicts	# lightningd: don't announce names as DNS by default.
	2ed10196d092d7aba22a700b0f26d248d04c36f7	# build(deps): bump secp256k1 from 0.22.1 to 0.22.2
#	b3a1d01e51f913cff5fe68f4c79caa0bc9933f16	# meta: Add changelog for hotfix release v22.11.1
#	41987ed379093b4bd61db9907b130d2f0279252f	# doc: check-manpages: add check for unescaped underscores
	09d52b3cb4f5930036a5d4b6b32525fe6d4d917f:strip='.*\b\(bkpr\|commando\|delforward\|reckless\)':resolve-conflicts	# doc: escape more naughty underscores
	31732f7825ab59878cb4704bc2a7b5384cf9c2a0:strip='.*\b\(autoclean\|bkpr\|commando\|delforward\|listhtlcs\)':scrub-stamps:resolve-conflicts	# fromschema.py: escape underscores in descriptions
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
#	845503f72ecd4ee72dd32a8350cea397c0b78fab	# db: Fix the ordering of `channel_htlcs` in postgres
#	89534f749a617a8434018a1bc469b4424cfad2b9	# rs: Add cln-rpc metadata
#	dd8fafd8345184961908c99e29fe936e678c3e29	# rs: Add cln-grpc metadata
#	5a4c8402a718b0fb207f06f4810091c394cf20f7	# rs: Add cln-plugin metadata
	22eac967502bc465cb63bfcf337e23e552ec0465	# connectd: don't ask DNS seeds for addresses on every reconnect.
	9d5eab1b69d3d6ae23bf5d1350af65400afb4fed	# topology: fix memleak in listchannels
#	42e038b9ad876a945a6a4eb5584ef8bd1b0b7c27	# lightningd: Look for channels by alias when finding channels
	241cd8d0124960d015ea89425d3f5e01faa5318c:strip=contrib/pyln-testing/:resolve-conflicts	# generate composite fields in grpc
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
	a1e894a4455fc59c1818016d396fe0739493a8ce:strip=tests/	# lightningd: treat JSON ids as direct tokens.
	435f8d84dca79aa48d753773baf3324543b78abc	# lightning-cli: fix error code on invalid options, document them.
#	19db6a25e40c70fe7a95547d124dae4a0cfa155a	# commando: require that we have an `id` field in JSON request.
#	b3fa4b932e1abe6f9cd2ab4709ac80ad8075f670	# commando: send `id` inside JSON request.
	0201e6977f285bd15d51aab536287ed699ec8d46:strip='\(tests/\|.*\bcommando\)'	# commando: build ID of command based on the id they give us.
#	b75ada701759773ce68ff3bc60094e11cc66b300	# commando: track incoming and outgoing JSON IDs.  Get upset if they don't match!
#	1250806060e1067987b175b350c8ccbd96924818	# commando: correctly replace the `id` field in responses.
#	3f0c5b985beb9771ed3673c3a675c8685c6aa62d	# commando: add filtering support.
#	404e961bad774e37d09fa2c4ff09f01dde074e6e	# cli: add -c/--commando support.
#	3f8199bbfdb0ac1872bff55c3767b712bf13fa30	# doc: document that we should annotate added and deprecated schemas.
	b2148d0eabdf8e2ca8a1c62f829ec826ff8a0930:strip='.*\b\(autoclean\|bkpr\|commando\|delforward\|listhtlcs\)':scrub-stamps	# docs: handle "added": "version" and "deprecated": "version" from schemas.
	717cb03f51f0920e67cb4adcc0ac546a2cc9c3ec:scrub-stamps:resolve-conflicts	# doc: add recent additions, fix annotation on listpeers to actually deprecate.
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
#	0d93841cc7c79d3fc92163d327486498acd4dd25	# plugins/command: ensure htables are always tal objects.
	f07e37018d61052f11ad2bf679a576fe183ccf39	# setup: make all htables use tal.
	5dfcd1578215fa98b7a7937dc48088384c60bf1a	# all: no longer need to call htable_clear to free htable contents.
	60441843233f80d74ae2337f2942a944abd3fcc9	# lightningd: don't call memcpy with NULL.
	300f732bbe7fe04a2ad800785584b5e8cdf5de4d	# proposal_meets_depth tracked output always has a proposal
	1d8b8995514b95846d74173d9317d6301694b04c	# lightningd: prepare internal json routines for listpeerchannels.
	6fa904b4fb19941a98d99f526300085df478338c:scrub-stamps	# lightningd: add listpeerchannels command
#	cb5ee7e49caae35a3b825c942803e82201952151	# plugins: make bookkeeper use the new listpeerchannels command.
	57dcf68c0b97f1d7d553f420451481147283461b:resolve-conflicts	# plugins/libplugin: flatten return from json_to_listpeers_result.
	5d5b9c6812f86646929e5655b2b211637d88f9a9:resolve-conflicts	# libplugin: don't return unopened channels from json_to_listpeers_channels().
	ff2d7e6833201e82748932f41af5580aa956e878:strip=plugins/bkpr/:resolve-conflicts	# pay: use json_to_listpeers_channels() for local_channel_hints.
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
#	288f5df8d11f225f0e1996f9092e3d1b8848c84f	# ccan: update to fix recent gcc "comparison will always evaluate as 'false'" warning
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
	d9fed06b900368e59f4d1f432b87d40fd28ce8d3:strip=plugins/bkpr/	# common/bolt11: const cleanup, fix parsing errors.
	cbd0ef4192f1140c25ad39a5bd81a8ebb6bc9ef5	# common/bolt11: add pull_all helper for common case of entire field.
	fa4b61d13d19daba938cecae4d1d37de5958b3b3	# common/bolt11: convert to table-driven.
	182a9cdcb61fa388dd58d468c8981a67e882b6e6:resolve-conflicts	# cln-rpc: use serde rename instead of alias
#	9482e0619c005bb183e4d120844b9ade545fdd0a	# docker: Install protobuf-compiler for builder
#	f29343d740c087e2b7c477386025b82c22341d82	# hsmd: add hsmd_preapprove_invoice and check_preapproveinvoice pay modifier
#	a4dc714cdcf409afcee24c540730ae3bc8bcf82c	# hsmd: add hsmd_preapprove_keysend and check_preapprovekeysend pay modifier
#	7b2c5617c16dab22f94a51955b5bdea38f284a12	# hsmd: increase HSM_MAX_VERSION to 3
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
#	4b9cb7eb760849e4166307c2658f28379f60edd0	# doc: remove unused offerout schema.
	578f07540744d924f9d8f4907a22c20638a82cd9	# wallet: remove unused TX_ANNOTATION type in transaction_annotations table.
	611795beee1bdecbde9e7b8c17db96d0934346be:strip='.*\bpreapprove':scrub-stamps:resolve-conflicts	# listtransactions: get rid of per-tx type annotations.
	9ab488fc41ea5f57efbd2eccfd58511755938549:scrub-stamps	# plugins/topology: add direction field to listchannels.
#	d6f46e237398bdedb4dd8b8410ce00439b0f5a62	# lightningd: fix type of listhtlcs payment_hash.
	83c690fe5f7b9312a4c29b1c045ce1facafd3e0b:scrub-stamps	# doc: fix listsendpays man page.
	0274d88bad83049ba9a4a2355ed6d88bb0f2f109	# common/gossip_store: clean up header.
	7e8b93daa1b2765373124bc660d94e070cc99815	# common/gossip_store: expose routine to read one header.
	153b7bf192942086f565127565b31f40635993be	# common/gossip_store: move subdaemon-only routines to connectd.
	eb6b8551d41ffcec8c98c89d39b47bfc6db50076:strip='.*\b\(autoclean\|bkpr\|commando\|delforward\|listhtlcs\|preapprove\)':scrub-stamps	# tools/fromschema.py: don't try to handle more complex cases.
	9589ea02402875b2dc8d0391c29975bc911765b7	# common: add routine to get double from JSON.
	fa127a40715f3361f86ca522490be6fbbb2f437c:scrub-stamps	# doc/schemas: remove unnecessary length restrictions.
	2c41c5d52d4e92f77d059ff30f4be6180f5cd3b3:scrub-stamps	# doc: use specific types in schema rather than "hex".
#	24d86a85c3af99ee7408c3cedfb1b346ffb49dbb	# plugins/sql: initial commit of new plugin.
#	260643157d902cfd7690c6efffb4b6fe6a528c06	# plugins/sql: create `struct column` to encode column details.
#	c230291141a2ba74532bac6e134c36139147a134	# plugins/sql: rework to parse schemas.
#	51ae7118f11cfca0697d46afb28b4ea00e50c884	# plugins/sql: make tables for non-object arrays.
#	8a0ee5f56ef917c0569615654952daa5f7773dc0	# plugins/sql: add listpeerchannels support.
#	68370a203eea01d3248efcefba896e510de1f5d2	# pytest: perform more thorough testing.
#	aa3a1131aa3a9d2a549a15b62f36241e91bdc3c6	# plugins/sql: include the obvious indexes.
#	9b08c4f25a0c9c7a574e0ebd7378c57c98119f19	# plugins/sql: refresh listnodes and listchannels by monitoring the gossip_store.
	40fe893172ba27610409151667b474bbca699af6:scrub-stamps:resolve-conflicts	# doc/schemas: fix old deprecations.
#	20654ebd49f5e98b15cd94a130cf1fda21ade2a2	# plugins/sql: pay attention to `deprecated` in schema.
#	adb8de3e071ea06aea01f438cd406be44802a675	# plugins/sql: print out part of man page referring to schemas.
#	14aac0769cf1d6a4105ca502e2a117010a8d8386	# doc: document the sql command.
#	9a591277f5a3e2452c2ec3e075da2e5b1dc3b139	# plugins/sql: allow some simple functions.
#	d8320f015fc6f6b474941816873d91bada62fba9	# plugins/sql: add bkpr-listaccountevents and bkpr-listincome support.
#	0240c2493622a9d757d47fb24fac9cc48126816a	# plugins/sql: listsqlschemas command to retrieve schemas.
#	259dd2a652f28da01d77529ea787705c5ad94dbc	# doc: add examples for sql plugin.
#	fea73680d70a97422c434ce8d9f03445cc9fd60c	# typo fixes found by @niftynei
#	959678244caa56b1935ca9fa616009c532d75024	# doc: remove sections on litestream, .dump and vacuum into
	80250f9b60c984d886fec8867255c7ac6d08a903	# datastore: Add check for empty key array
	a9eb17adf95c216976aa004a5431a3d1be1db222	# db: catch postgres error on uninitialized database
#	dcb9b4b8d157b6b2a609f3d82fac683d6c7f56a8	# make: fix make doc error
	18397c0b878eca2d540971204058d6bb14e42a56:scrub-stamps	# doc-schema: make address field in getinfo response required
#	12761c38e31fe37eccbf253ef5b26898fbb01c08	# libwally: update to cln_0.8.5_patch
	6176912683ef10e86c3fc119f6641f3a9d0ef56d	# plugins/pay: fix htlc_budget calc when we get temporary_channel_failure
	4502340daca76093634720ea23252801bbe73afc	# lightningd: flag false-positive memleak in lightningd
#	3dde1ca39923169a7b5df2e053b493f32142db71	# pyln-testing: fix wait_for_htlcs helper
#	f87c7ed43951dfc0b63981ef99a97cd76fec99fb	# plugins/sql: fix foreign keys.
#	38510202c4a34febd70b35c0e52c8afe4d3599d4	# pytest: fix flake in test_closing_simple when we mine too fast.
#	7c7e32b32436f1d85b647d3527f846ed3499ed5d	# tests: add Carl Dong's example exhaustive zeroconf channel pay test.
#	0cbd9e02de9fe32d1904d4737b2f3ada2f508339	# pytest: limit test_cln_sendpay_weirdness to only failures.
	ec8aab7cb2b3172841126be521aa525ca47ab4bc:resolve-conflicts	# libplugin-pay: fix (transitory) memleak which memleak detection complains about.
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
#	bcab3f7e8399608e66b6c181d684bcdd03d66a15	# Makefile: don't try to build sql plugin if there's no sqlite3 support.
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
	e736c4d5f403032e3a668391020af7db0cdfe0a1:strip='.*\bsql':scrub-stamps	# doc: listpeers new attribute num_channels
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
	sed -e 's: *\(-[IL]/usr/local/[^/ ]\+ *\)\+: :g' \
		-i configure Makefile || die

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
	newins "${FILESDIR}/lightningd-0.11.0.conf" lightningd.conf
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
