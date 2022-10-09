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
#	c77eda6d64b6092cc1fd26ae93798acc40d6414e	# pyln-spec: upgrade to the last bolt version
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
#	9d3cb95489a2d74f7fc624b9a1d8ad074e9fd66a	# wire: Add funding_locked tlv patch from PR lightning/bolts#910
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
#	312751075c0ef069e771698852d650dab3d09dda	# lightningd: save outgoing information for more forwards.
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
#	12275d0bfe0e0745aa5c3d9507f534cb0e2e39a2	# cln-grpc: Skip serializing fields when Option<Vec<T>> is empty too
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
#	305a2388108e638a7c24c097be4a5814d081dc52	# plugins/Makefile: put bitcoin/chainparams.o in PLUGIN_COMMON_OBJS since everyone needs it.
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
#	6fe570820e66491778b9e60d2b2942bbffbee813	# Remove general shadowed variables.
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
#	e0259b246e6f372cf585446ce239b3a7bdc6d4b1	# test: fix tlvs test in funding_locked tlv.
#	a56b17c759c53e7705fd6f002d53e809c03e4c26	# wire/test: neaten and complete tlv checks.
	6c33f7db65caf619c2c9ceea1071b38c05e3357d	# common: remove unused parameter "allow_deprecated" from parse_wireaddr_internal.
#	bfe342c64b5fb298f6739e940ddcaf778af3ba33	# lightningd: remove double-wrapped rpc_command hook.
#	43b037ab0b372397cecc477a50fef201b0b313ed	# lightningd: always require "jsonrpc": "2.0"  in request.
#	a45ec78c36c869534b78cbfa238befdb64107666	# lightningd: don't allow old listforwards arg order.
#	15751ea1b8c10186dd3ac4fec679a6699d1d7d01	# lightningd: do inline parsing for listforwards status parameter
#	733ce81bd4d115779450f87a8e2287af0c55574e	# plugins: require usage for plugin APIs.
#	29264e83fbac59771164ece2361a135a15140b20	# lightningd: remove `use_proxy_always` parameter to plugin init.
	318650a6275d7246c4a2aa6c663aecac5070dd5e	# listchannels: don't show "htlc_maximum_msat" if channel_update didn't set it.
#	136d0c8005ed56d9a36a91656bb00d8f3b4a86f4	# offers: update to remove "vendor" and "timestamp" fields.
#	6cf3d4750526a6d4f5d70bd6a47e16a8aab30529	# offers: remove backwards-compatiblity invoice_request signatures.
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
#	2022e4a7a9d02473b521a24258c210a2ce357368	# wallet: simplify payments lookup so sqlite3 uses index.
#	63457229cbe287cb04ddf907898794a12288d721	# wallet: replace forwarded_payments table with forwards table.
#	33a6b188919ffb6f0abfc5902eb50f8bc564641e	# db/bindings: rename db_bind_short_channel_id to db_bind_short_channel_id_str, add db_bind_scid.
#	e286c38c6ff66680638384e0c22210ccd86fb49d	# wallet: use db_col_scid / db_bind_scid where possible.
#	2752e04f8f24f68c7e55244fe39d6fc27677222f	# db: add `scid` field to channels table.
#	d7c1325e38dfa15ccb2021430d118ee6a14dd1ee	# wallet: use scid not string for failchannel (now failscid) in payments table.
#	311807ff1f4f3574413b2ef86f63bf28e5363ee2	# lightningd: add in_htlc_id / out_htlc_id to listforwards.
#	7420a7021f4805d8b8058e86eec791f4ce3e27fa	# lightningd: add `listhtlcs` to list all the HTLCs we know about.
#	3079afb024e9307a696046d0e936ff240a5f4c86	# lightningd: add `delforward` command.
#	a15f1be5f88bdae5a6e816026e35a035791875e8	# autoclean: clean up listforwards as well.
#	399288db3f2a90e52fcea587424c1287705c69d1	# autoclean: use config variables, not commands.
#	612f3de0d4a07851c8f25ed8e2c359ecea7e3e2f	# doc: manpages and schemas for autoclean-status.
#	13e10877de9dde1b5aa784894a15a4611b62a46a	# autoclean: add autoclean-once command.
#	540a6e4b99c5c0b5b49dbd6b1c604f599eb45718	# autoclean: remove per-delete debugging messages.
	4d8c3215174e1436dccb66d60fa69536f3b4d31a	# libplugin: optimize parsing lightningd rpc responses.
	8b7a8265e7ad80bb0e1882ad5dffada14f7425df:strip=plugins/bkpr/	# libplugin: avoid memmove if we have many outputs to lightningd.
#	555b8a2f7a2bd728efa15dda8302084e477aa8c9	# lightningd: don't always wrap each command in a db transaction.
#	fa7d732ba6f6cbba035f8162df3ad32ec8cabbd9	# lightningd: allow a connection to specify db batching.
#	05095313f5c30a2fc20e1b188f78398c7a717863	# lightningd: listsendpays always has groupid.
#	f52ff07558709bd1f7ed0cdca65c891d80b1a785	# lightningd: allow delpay to delete a specific payment.
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
	0d94d2d269c760721a49d2e0c8951371e9a435c2:resolve-conflicts	# gossipd: batch outpoints spent, add block height.
#	f0fa42bd7370c9ee9a7b6e1d34d6bc824cc65a2e	# lnprototest: update gossip test including 12 blocks delay
	a1f62ba0e70b28ea82862aebc8ff776850073df2:strip='\(Makefile\|tests/\)'	# gossipd: don't close non-local channels immediately, add 12 block delay.
#	f53155d93b5eef9f4353c68e623cd54134aa7e2b	# BOLT: update to clarify HTLC tx amount calculation.
#	3f5ff0c148b33433b8a7a8db56d3caee363d17dd	# doc/GOSSIP_STORE.md: document the gossip_store file format.
	8898511cf6b6612bb15127bc7c8e54aa551517ce	# cln-plugin: Defer binding the plugin state until after configuring
	064a5a69406d8d44e005c94e914126626d1bf460	# cln-plugin: Add log filtering support
	e1fc88ff700aeae3123e6bbc9d8152562788f86e	# cln-plugin: Prep the logging payload in a let
#	b13ab8de3ae21fd22d09dcfb3ac6a2999764b2ba	# msggen: Use owned versions to convert from cln-rpc to cln-grpc
#	437ae11610fda83f26d56a87669ea650ab185c99	# pytest: Configure the plugin logging to debug
	b698a5a5ef4acb8d90aec0f6dccc52fb6c37afb2	# channeld: send error, not warning, if peer has old commitment number.
#	6e86fa92206eb6e935a8dcba37b9e7849d2cc816	# lightningd: figure out optimal channel *before* forward_htlc hook.
#	a7ce03bae6cd763e7796f7b961d40a83a7e64a4a	# The project is called Core Lightning
#	87bab2b85138bf99a29bb9b881d110e90e3a4e88	# Add ConfigurationDirectory
	7046252f96c0436500a1b45c379a6aab56ee9612	# Impl `std::error::Error` for `RpcError` to make it anyhow compatible
	10917743fe3fedd9d00b69ef1fa42d47989955ae	# Implement a typed version of `call` to avoid useless matching
#	e272c93a88c7302dad026dbe06627a569487a25c	# Use `bitcoin_hashes` for `Sha256`
#	b4b0b479ac1c60111a4eadda6a3b68f158f5f11c	# Use `secp256k1` for public key type
#	09dfe3931dd0d14707b52d2b2f0189da3b5c0270	# Make eligible types `Copy`
#	6abcb181457d1b52da8374ca714ff8ff0ba354c7	# Add basic arithmetic to `Amount` type
#	657b315f1cb3c25c981d0cc9ca367a96ec547e09	# pyln: Bump versions to v0.12.1
#	9023bd9334c16cc66d3731aa31f57818971d3fdc	# pytest: add test for migrations upgrade which breaks 'fees_collected_msat'.
#	cafa1a8c65117833d70cf7a1f000b41605abe1f6	# db: correctly migrate forwards for closed incoming channels.
#	6eac8dfe3c70c3b7b94cce434807b8b7fed9a920	# delforward: tally up deleted forwards so that getinfo's `fees_collected_msat` doesn't change.
#	68f15f17bb35919ca6a32f3cc95041008135c8a9	# delforward: allow deletion of "unknown in_htlc_id" and fix autoclean to use it.
#	695f0011619d758dc53b2c6463ca08d246327edb	# pytest: fix flake in test_zeroconf_forward
#	d4ef20d54a7db05d96e4df8c0906dae475697218	# pytest: fix flake in test_gossip_persistence.
#	836a2aa2616dff3bd78267d276c0902b26f7f33c	# use msat_or_all for fundpsbt request amount
	1de4e4627623d488836cffc93537d124ec1487c0	# tests: add onion-test-vector from "BOLT 4: Remove legacy format, make var_onion_optin compulsory."
#	c8ad9e18a9ff47dd047292ccc1b1a8a21e2a6712	# common/onion: remove all trace of legacy parsing.
#	8771c863794d2774e93ea759f4eb23873a236112	# common/onion: expunge all trace of different onion styles.
	f00cc23f671643446577ee9c0da3e5b9a266fbc0	# sphinx: rename confusing functions, ensure valid payloads.
	6324980484cdfe68e5228a56b74ac60542dc46d7	# channeld: do not enforce max_accepted_htlcs on LOCAL in channel reinit
#	51e243308761e056d0da23e596b7dfedbb909db1	# Setchannel request is provided
#	93b315756f80cbd9a112c0ca627243017c55213f	# schema: Add `enforcedelay` to `setchannel`
#	6adb1e0b4b419e723d53b1e54e16593f58656986	# pytest: Bypass schema verification for some RPC calls
	49fe1c8ed7aea1f109b4bcc4944ddcd0cc30117b	# lightningd: have `makesecret` take `hex` or `string` (just like `datastore`)
	342e330b565fd3326f8a046dfa2c0e63e8785c24:scrub-stamps	# doc: update references to old BOLTs repo.
#	41ef85318d367c8e6f34df0749f2bc373c5451b8	# onionmessages: remove obsolete onion message parsing.
#	2fbe0f59f1142f1c5ded0c5048c20b9398ddbb47	# plugins/fetchinvoice: remove obsolete string-based API.
	125b17b7fc570f57486a42e176cd48caa3492a94	# devtools: enhance bolt12-cli to convert to/from hex
#	0195b41461dfedae09ca5cfdf8cd1abae8d4a174	# pytest: test that we don't change our payer_key calculation.
	c9d42d82795ef5b8846bfc37775d744bcf00f326	# bitcoin: add routine to check a Schnorr sig given a 33-byte pubkey.
#	2749b1f61eaf9db789f63c91a2f0f65f7c80f79b	# common/onion: remove old blinded payment handling.
#	22c8cfc3744b1cd868b24b4df2f1809f0c729be4	# channeld: remove onion objects.
#	52be59587c5acc030dfa9a4079b217627e40d0cd	# msggen: generate deprecated fields in rust.py
#	6aca9f665b580aa9ad2beed8ab10f511e56ac180	# devtools: Make fund_nodes compatible w/zsh
#	335f52d1a8b002018270194654c9e53c5a65fa5d	# cln-rpc: implement from Secret to slice conversion
#	e7e7a7186f7b2ae145f756a757d576b7ac0c51e1	# tests/test_misc.py: Check if funds are getting recovered on reconnecting... Changelog-None: Increasing test scope
#	e855ac2f9e6453913df64602b680b3644d847a6c	# keysend: just strip even unknown fields.
)
PATCH_FILES=( )
PATCHES=( )
for hash in "${PATCH_HASHES[@]}" ; do
	if [[ ${hash} == *:* ]] ; then
		hash=${hash%%:*}
		PATCHES+=( "${T%/}/${hash}.patch" )
	else
		PATCHES+=( "${DISTDIR%/}/${hash}.patch" )
	fi
	PATCH_FILES+=( "${hash}.patch" )
done ; unset hash

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="${HOMEPAGE}/archive/v${MyPV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	https://github.com/valyala/gheap/archive/67fc83bc953324f4759e52951921d730d7e65099.tar.gz -> gheap-67fc83b.tar.gz
	rust? ( $(cargo_crate_uris) )
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
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
	rm -r */ || die
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

	local patch ; for patch in "${PATCH_HASHES[@]}" ; do
		[[ ${patch} == *:* ]] || continue
		local -a flags ; IFS=: read -r -a flags <<<"${patch}"
		set "${flags[@]}" ; patch="${1}.patch" ; shift
		cp -- {"${DISTDIR}","${T}"}/"${patch}" || die
		local flag ; for flag ; do
			case "${flag}" in
				scrub-log)
					sed -e '0,/^---$/d' -i "${T}/${patch}" || die
					;;
				scrub-stamps)
					sed -e 's/\(SHA256STAMP:\)[[:xdigit:]]\{64\}/\1/' \
						-i "${T}/${patch}" || die
					;;
				strip=*)
					local strip="${flag#*=}"
					sed -ne ':0;/^diff --git a\/'"${strip////\\/}"'/{:1;n;/^diff --git /!b1;b0};p' \
						-i "${T}/${patch}" || die
					;;
				pick=*)
					local pick="${flag#*=}"
					sed -ne ':0;/^diff --git/{/^diff --git a\/'"${pick////\\/}"'/!{:1;n;/^diff --git /!b1;b0}};p' \
						-i "${T}/${patch}" || die
					;;
				resolve-conflicts)
					patch {"${T}","${FILESDIR}"}/"${patch}" || die
					;;
				*)
					die "unknown patch mod: ${flag}"
					;;
			esac
		done
	done

	# blank out all embedded SHA256STAMPs to make cherry-picking easier
	sed -e 's/\(SHA256STAMP:\)[[:xdigit:]]\{64\}/\1/' -i doc/*.md || die

	# delete all pre-generated manpages; they're often stale anyway
	rm -f doc/*.[0-9] || die

	default

	sed -e 's|\(path = \)subprocess.*"git".*$|\1b"'"${S}"'"|' \
		-i contrib/msggen/msggen/utils/utils.py || die

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
