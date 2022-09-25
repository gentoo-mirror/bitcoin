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
	4e902fbd883e710d1324c8c0870b5d15c0d1db0f	# msggen: introduce chain of responsibility pattern to make msggen extensible
	8dd51d127fff01b9302009906dcbdc83ea3b6548	# Restore description of "reserved" field for listfunds
	c7d359baf455e5260dc5d126b05211279e186ef8	# cln-grpc: API updates after 8dd51d127fff01b9302009906dcbdc83ea3b6548
	572942c783a58e518f0a1b449412a82717594636:strip='.*test/run-'	# psbt: use DER encoded + sighash byte for PSBT_IN_PARTIAL_SIG items
	7c8dc620359f6d3e614551e9491c70e9d07e2d31	# channeld: take over gossip_rcvd_filter.c and is_msg_gossip_broadcast.
	87a471af982ddce932e9facbc86f75a17bdcb0fc	# connectd: use is_msg_gossip_broadcast into gossip_rcvd_filter.c
	d922abeaba9e8700c6449efe836300a86d5614f7	# connectd: optimize gossip_rcvd_filter.
	0c9017fb762981dd30f6130f7821bc022c3e2936	# connectd: shrink max filter size.
	033ac323d165147a445cb80aeab8d0b0786957df	# connectd: prefer IPv6 when available
	de9bc172de9f23bc8ca57f156809c1e55a450800	# connect: adds nodeid to remote_addr log message
	55cf413fc3df2548c5a1841955186ecf30e71cb1	# wireaddr: moves wireaddr_arr_contains to wireaddr.h
	32c4540fc03f7feebc39af60c26dc48801879446	# jsonrpc: adds dynamicaly detected IP addresses to `getinfo`
	475e4c9bd97124b058b0a271fbfa9fac4249264c:resolve-conflicts	# jsonrpc: adds optional `remote_addr` to listpeers
	1e9ecc55e7a37c5f15edc5a7a37d885d9bc48005	# Mistaken default directory in plugin docs
	e7393121b16bbb06fd6cf813a91ea2684ca1c90c	# Fix typo and convert paragraph to a list
	928a81f24a7b13a12ab2ed12de322e78c9942860	# docs: Fix  manpage title
	47a7b4a55b347bc55eeabd14995573d0e00510cb	# log: Add termination to prefix log
	83c31f548f0011a1503a086489c73f8b22703b05	# log: Add termination to log level
	c5b032598ec5d2c45563fe86e829c4cd27e2818e	# lightningd: fix outgoing IO logging for JSONRPC.
	a52bdeee015bd7236d03a1763764a8db4acc6c08	# common: add msat to sat convert helper.
	6461815dd929cacacaaee1baa74bd9866478cdf7	# plugins/funder: fix parameter parsing.
	bb53a178559207ba221dc5b091bc0918ca733b91	# doc: Tor needs CookieAuthFile set
	acc78397eb811e7751e6b583adf675a664383809	# Remove native-tls dependency from cln-rpc
	49c6459148502df5be6f62574bd0ca52524c9259	# Update hsm error formatting.
	d4bc4f646035a9efa566109da561b00698abd8c9	# signmessage: improve the UX of the rpc command when zbase is not a valid one
	5444a843b60e0b1d1f6742fa9e912fcdfe5736f8	# git: Ignore some more generated files and the cln-grpc plugin
	a1b8b40d135c64e580d6767288a1ca5d6188e54a	# connectd: fix debug message on bind fail.
	2b7915359cfecaa8a4926e36088c321e3896e7e1	# gossmap: handle case where private channel turns into public.
	11de721ba96a3d8c35e1949b486bdf1c5377dc0d	# gossipd: fix gossmap race.
	517828adb26fc1a42af0ee5d3b19e84857d27d8e:strip=tests/	# lightningd: don't print nasty message when onchaind fails partially-failed HTLC
	b4820d670678f9bc48d93ea43793122368fb1a95	# lightningd: don't run off end of buffer if db_hook returns nonsense.
	70b091d9f67d68e1cdccd53eed041fba16bb2d68	# lightningd: fix transient leak report when openingd shutting down.
	3f98cf3fceab2fa85ec90180fe13ce1568e0bde9	# lightningd: track weird CI crash in test_important_plugin
	e120b4afd6dd7d763f7dd0bf671ab3f0efa821bc	# lightningd: add more information should subd send wrong message.
	cc7a405ca4acb8e96cc7890439663e5474236767	# lightningd: use the standard port derivation in connect command
	4b11f968ad15c28b526e02a4068b6243220efa6a	# lightningd: change the regtest default port according with the tests
	c07d44b4d4acddecf232d859b7b424c086d06706	# docs: update the docs in according with the new code
	7ff62b4a00c71987841db6cc1f63f8533f522b08:strip=tests/	# lightnind: remove DEFAULT_PORT global definition
	2754e30269e918525e49cf871006c9a5d569fdf5:strip=tests/	# devtools: revert changes and make sure chainparams always set.
	8e2dcc11673a4c6d39350a0b439350e2312d482c	# doc: document the [] IPv6 address hack.
	6d07f4ed85be91d5af0bfffa75895d4b33fd4cc2	# json: Add parser for u32 params
	185cd81be408320b8e078060dc2d5cff43149f0b	# jsonrpc: Add `mindepth` argument to fundchannel and multifundchannel
	9296537edb98649031f947b03ba7104ff180da22	# peer_control: Fix check_funding_details assert
	cbafc0fa33419551a159c6b9be92cabc983ce01f:strip='.*\.xz\b'	# gossip_store: add flag for spam gossip, update to v10
	9dc794dba8299b076d519f449c4fcbfbe2a8e583	# gossipd: make use of new ratelimit bit in gossip_store length mask
	87a66c180250e3c7ba99ac0461f7d16d5b411dbe:strip=tests/	# gossipd: store and index most recent and last non-rate-limited gossip
	c0253ebc6894c8afaf6d1c3c8ea94baa15b70542	# Fix broken link
	d0937a2e97e4f412cbd67c149485665f3624d4df	# df: check mempool/block for funding output on broadcast fail
	ba4e9b64b57fa09ccf9adbac7bb9533aed17a607	# options: print empty options properly.
	4633085ffd179bd430ffde7e92f056dc42fb81f2	# lightningd: mark subd->conn notleak() properly in transition.
	7dd8e27862f832f71d0bd11cf428d9b1198e5cdf:strip=tests/	# connectd: don't insist on ping replies when other traffic is flowing.
	3a61e0e18182b3e5ba704f4386ecceb333eb9df6	# invoice: turn assert failure into more informative log_broken message.
	36e51568322f6bd3b2bf6fbcc48695cbe081caa9	# lightningd: fix close of ancient all-dust channel.
	6753675c310e2f13f7c9f5434dd90b119ede3607	# lightningd: fire watches on blocks before telling lightningd.
	ae71a87c404475bbbe351a39265e726a8f4ef7eb	# ccan: update to latest htable fixes, and update gossmap to meet new assertions.
	981fd2326a64945e7096c46fce8a2732f3894bc6:strip=tests/	# lightningd: convert plugin->cmd to absolute path, fail plugin early when non-existent
	2fddfe3ffc256a9d0f7e9851f2e3227b3936f34c	# lightningd: don't increment plugin state to NEEDS_INIT when error in getmanifest
	9ff9d3d4e33c690d8c600bc740c76dd2554dd6b6	# tests: Fix the canned gossmap
	d6afb0cd8d40fe3836dbc27375caee37bc95fb96	# lightningd: allow outgoing_scid without outgoing amount.
	ddf8fbdb5d224909cfade68178cc41efb0b9d61f	# gossipd: fix crash from gossip_store v10 changes
	da85014fdf33e7a7561df4fba04f83cbe493ac0f	# gossipd: nit: update a misleading comment
	301acc9556fcfe6bbeb2fd378731f7c6a18438bf	# gossipd: only use IP discovery if no addresses are announced
	95ec897ac0709be12935ac522ff0ff414c8daf54:strip=tests/	# dual-fund: Fail if you try to buy a liquidity ad w/o dualfunding on
	27e5ddc7b766cc8dad607d01c9c1de1fb22ebf45	# gossipd: fix of gossip v10 channel removal handling
	64c03f8990707247996846899c56448481d99fe9	# hsmd: Create derive_secret and makesecret RPC for deriving pseudorandom keys from HSM
	286d6c31654be0e34117bd981da2e93a27c32241	# tools/gen: Always return bool!
	bdefbabbeff96ca22e8281cd964de22cf8894d3a:strip=tests/	# lightningd: re-transmit all closing transactions on startup.
	b624c530515b3966ae08b740eac35bbec19da5de	# plugin: add check on the type json object during the IO message handling
	92fe871467e32a6631b473398341a9dc16edd7b2	# connectd: optimize case where peer doesn't want gossip.
	62a5183fb5de6ab1af682280f8473238cf9064fb	# common: add ability for gossip_store to track by timestamp.
	6fd8fa4d959705d6835deacdcf470bf0ed367923	# connectd: optimize requests for "recent" gossip.
	f2e7e9d919c1670b6bdfd3e672d476988951d43b	# coin-moves: only log htlc_timeout pair for penalty txs
	0236d4e4dafe4f1e78f3af5b14f9276fb8a723db	# common/json_stream: remove useless attempt at oom handling.
	814cde56235951c5f700c45829506f5bda373820	# lightningd/closing_control: remove param_tok().
	ec76ba3895f63adb9c4159575530b9feda1a697d	# lightningd/connect_control: remove param_tok from connect.
	e621b8b24efbbc750ae132f6406f893e4681c057	# lightningd: remove gratuitous param_tok from help and config.
	a9b992ff4a1aeee4f7f1b0684b80c79eb0bf7456	# plugins/spender/multifundchannel: remove json_tok.
	f12f0d6929b358ba9c1cd0c551484aa7e52ff680	# common: remove json_tok.
	ad3cbed7c28b2d4e9327885f6c3763f8f4acef41:strip=tests/	# plugin: autoclean fix double free when re-enable, remove xfail mark from test_
	65433de05f48bb1bfa1e1ab0363eb28cb7fc4fc5:strip=tests/	# options: set DNS port to network default if not specified
	73762de18c5032984e507f2430e0d3a9744af878	# lightningd: reduce log level for remote address reporting.
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
	ab0e5d30ee73e389f12fcdcdcb003bfe18fda07a	# connectd: don't io_halfclose()
	a12e2209ff382286adf17fa59cb9f8a87b784b2f	# dualopend: fix memleak report.
	571f0fad1b5f4fd18385db2b2d3c0319764e9d14	# lightningd: remove delay on succeeding connect.
	eff53495dbfeeed35ed496e9043af78090a3c14c	# lightningd: make "is peer connected" a tristate.
	430d6521a0a95b0cb084a43a614b01d721f95902	# common/daemon_conn: add function to read an fd.
	41b379ed897ad24bf2d68ce022eb15339e430761:resolve-conflicts	# lightningd: hand fds to connectd, not receive them from connectd.
	d31420211ad6e3d665cd75ae2ee9e870161feb22	# connectd: add counters to each peer connection.
	6a2817101d07fdc497cc57fb22592a45cea056e5	# connectd: don't move parent while we're being freed.
	671e66490e8633c49221f37e008ed73b0f18ae0c	# lightningd: don't kill subds immediately on disconnect.
	9cff125590a30328660db9abacb6de1c524ca8c3	# common/gossip_store: fix leak on partial read.
	719d1384d15b3bb782a7f09c14aec6d68edb7ed9	# connectd: give connections a chance to drain when lightningd says to disconnect, or peer disconnects.
	c57a5a0a06c9fd5e8b4b8674f6bebaeddb6eea98	# gossipd: downgrade broken message that can actually happen.
	e15e55190b8ce35440f626e8648fa3844203bdb5	# lightningd: provide peer address for reconnect if connect fails.
	e59e12dcb64c92667619e9bed8b414741f726d0a	# lightningd: don't forget peer if it's still connected.
	aec307f7ba760efcf1eea3d2ce87a9012188625a:resolve-conflicts	# multifundchannel: fix race where we restart fundchannel.
	a3c4908f4a33aae31c433106e1069bc761a7202f:strip='tests/\|.*test/run-'	# lightningd: don't explicitly tell connectd to disconnect, have it do it on sending error/warning.
	02e169fd2727a75a1a27a14b7d924287c91eb626:strip=tests/:resolve-conflicts	# lightningd: drive all reconnections out of disconnections.
	a08728497bdd6c7fa882360356cd0700b6061545	# lightningd: reintroduce "slow connect" logic.
	0363c628abdadba8031853213909c526916fdc7e	# channeld: exit after we send an error at lightningd's request.
	1d671a23804ffb4934dd7080a75adbbe28b1d81c:strip=tests/	# rpc: checkmessage return an error if pubkey is not found
	7ae616ef60413428f40a5f77bffdf9576d49dc30:strip=tests/:resolve-conflicts	# rpc: improve error format
	e96eb07ef417a260bc8edd2a7202d83dbad61b9d	# lightningd: test that hsm_secret is as expected, at startup.
	5979a7778fc3cebe65e26cff5b6a33ec13ba59a1	# lightningd: expand exit codes for various failures.
	2d35c9a9298513da88be6fd357774a178b485a85	# msggen: Do not override method names when loading Schema
	1efa5c37be5e7bfc806eaf48e49ba0056eaa2e62	# cln-plugin: Notify waiting tasks if the lightningd connection closes
	e586a612282cb851d89dbd7c26792d843c650072	# cln-plugin: Add metadata required by crates.io
	aa82a96034def8bab3bb0e6faed273d5d9d78a15	# cln-plugin: Fix plugin dependencies
	8d9c181e3b9e91d68b1d6eb3ced2030c07137d82	# dualopend: plug memleak.
	84675218222f0f9164227c3580a1b0b940a11117	# rs: Add Cargo.lock for reproducible builds
	43e5ef3cc462732529dba76645a198be1700a879	# libplugin: don't call callbacks if cmd completed before response.
	7bbfef5054ec222d6675b52fa6953e06aba6fef0:strip=tests/	# tests: flake fix; l1 was waiting too long to reconnect
	0fd8a6492e1e233aa03dc5246b044a58a01cb309	# lightningd: fix fatal() log message in log.
	9498e14530fea53167b4fa2488446643b60e7595	# connectd: two logging cleanups.
	008a59b004486053c07bc269a928da00e807bc74	# lightningd: ignore default if it's a literal 'null' JSON token.
	b55df5c62648ceaae5bd8558c7a3ebaecfe5f3a2	# msggen: Use tempfile + rename to make changes to .msggen.json atomic
	79a76a96f7a60616464937acf7e18b75b51e1061	# v2open: dont rely on ordering of interprocess messages
	75c89f0b8e39a45cd1d2fdaa1b718e1f6ed0c3de	# doc: fix bolt 12 link (it's not in master), update bolt 11 to new "bolts" repo.
	967c56859f6cb15f13d077f7238458e1914e0c99	# sql: use last " as " to find name token for column
	aa7ffb78bd8d3dcd9f3d04f69a81b8b3403e76b5	# wallet: resolve crash when blockheight is null
	9cad7d6a6a71f13cc7665c295da3c57747ae51c9:strip=tests/	# lightningd: don't consider AWAITING_UNILATERAL to be "active".
	22ff007d642d6b716fbbe6c2b210878775a9d760	# connectd: control connect backoff from lightningd.
	78804d9ea82b66dfd5095e745c3ca08d1a5c6d30	# fix doc: deschashonly
	645b1b505b6d0a93da45007c6825abe032f84ac6	# lightningd: fix funding_locked in channel_opened notification.
	2632cddfe46bc35f76796ff1c1154b82a6870cef	# pay: Fix a memory leak when retrying getroute
	e0a48c2aa7b50391c200b414fbb4cdb1b08188b6	# am_opener unused
	65a449e2c384ec1b86a7b437d6df82054b4c75a0	# pay: Remove use-after-free bug
	da0b651803f47b3e45eb5be55d728d5e6398e298	# pay: Use safe list traversal when completing suspended payments
	054339e0cb66d0fa89ee205ab869e4f91c780d32	# lightningd: obey first hop channel id.
	eb006dcaddd2539cfa5413798131833df1072ae8	# wallet: fix incorrect column-width access.
	0878002fe6669f3ebf23e907c6cdd402f2c96e44:strip=tests/	# Fix derived_secret, use correct size of secretstuff.derived secret
	63f8c74da90430066999481322a78ec46a3106a8	# psbt: dont crash when printing psbt to log
	4e7f89f211523e2fac8ce0435137b17a255133c0	# signpsbt: don't crash if HSM doesn't like your psbt, just return err
	fdfca9e7212eb7a4521ab4517a85964c9c65be29	# sqlite3: no NULLS FIRST
	7c9985fd9c0c532581a46a75a1fe43ecb9013850	# channeld: correct reversed shutdown message in billboard.
	dc56b2a9ac05ccf810ec27b31ba4f87bd0ee32cb	# connectd: better diagnostics on invalid gossip_store entries.
	ec95c7c18c9200145545de0b491db3cc2f51bb28	# peer_control: fix getinfo showing unannounced addr
	c6858748bb7d9446d45275ab3f86f7cc8cabb28b	# cleanup: fix mixed indentation of json_getinfo
	6c33f7db65caf619c2c9ceea1071b38c05e3357d	# common: remove unused parameter "allow_deprecated" from parse_wireaddr_internal.
	318650a6275d7246c4a2aa6c663aecac5070dd5e	# listchannels: don't show "htlc_maximum_msat" if channel_update didn't set it.
	2ac775f9f4343338a0782a07d446920582f576b8	# lightningd: fix crash with -O3 -flto.
	bef2a47ab7a1acb01582d33db406cf0b6e06b8ac	# db: fix renaming/deleting cols of DBs when there are UNIQUE(x, b, c) constraints.
	d7aa2749c3f2d596a33f8e86de8d276410b4aa9b	# db: fix migrations which write to db.
	e853cdc3ff3732629c912eb5b4ab880944d3ccff	# db: fix sqlite3 code which manipulates columns.
	375215a141f60ed2d458cd8606933098de397152	# lightningd: more graceful shutdown.
	4167fe8dd962458c9ceacdb6c79832e3e8fad26f	# gossip_store: fix offset error
	746b5f3691525a37f837fdabd8bd967e8683834b	# Makefile: fix msggen regeneration when schemas change.
	023a688e3f1ebdf1b41ea97720b0ccccf7ccbfaa	# lightningd: fix spurious leak report.
	112115022c75940035ba7d5d70193ea81456f3c3	# gossmap: don't crash if we see a duplicate channel_announce.
	c8ab8192ca65a2b3ac3153dd881309a4dee76e2c:strip=tests/	# peer_control: getinfo show correct port on discovered IPs
	532544ce4fa859037faf177b0af4b01a9025e3c1:resolve-conflicts	# gossipd: rename remote_addr to discovered_ip within gossipd
	6c07f1365fa8adfb1e8f5f896177c88ec15be924	# lightning-cli: don't consume 100% CPU if lightningd crashes.
	cc206e1f0e281b33cf86e1eede5f3545fdcec2ea	# connectd+: Flake/race fix for new channels
	6a48ed9e826efed1ea53b18a8308f97c2d5bbe34	# gossmap: fail to get capacity of locally-added chans (don't crash!).
	4cdb4167d2e3c3052d42e1a38a0dfebef496d48a	# gossmap: make local_addchan create private channel_announcement in correct order.
	fd71dfc7f79e71b5e3b8017dbdd11d469415bf7a	# gossmap: optimize asserts().
	248d60d7bd7e9a1961e70a3579ea93a0d496d6cc	# Don't report redundant feerates to subdaemons
	759fcb64a8c28a90a7659c2b1791ce9993067796	# pay: If the channel_hint matches our allocation allow it
	939a7b2b1881a0658ee9f9711cf6b808aedc9f29	# db/postgres: avoid memleak.
	9b5bc81541e30e6a9bda98e15d5495ca77aff457	# onchaind/onchaind_wire.c duplicated in ONCHAIND_SRC
	fe556d1ed9b11087ecfdfc86f00e9397c2db7973:strip=tests/	# gossipd: don't try to upgrade ancient gossip_store.
	3817a690c9708b1873264582d66a39bdf358e0cc	# gossipd: actually validate gossip_store checksums at startup.
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
	>=dev-python/pycparser-2.20[${PYTHON_USEDEP}]
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
	doc? ( >=app-text/mrkd-0.2.0 )
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
	rm -r "${S}/external"/*/
	cd "${S}/external" || die
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
		set ${patch//:/ } ; patch="${1}.patch" ; shift
		cp -- {"${DISTDIR}","${T}"}/"${patch}" || die
		local flag ; for flag ; do
			case "${flag}" in
				strip=*)
					local strip="${flag#*=}"
					sed -ne ':0;/^diff --git a\/'"${strip////\\/}"'/{:1;n;/^diff --git /!b1;b0};p' \
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

	if use doc; then
		dodoc doc/{PLUGINS.md,TOR.md}
	else
		# Normally README.md gets installed by `make install`, but not if we're skipping doc installation
		dodoc doc/TOR.md README.md
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
