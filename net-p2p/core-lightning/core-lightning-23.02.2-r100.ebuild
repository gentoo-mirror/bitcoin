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
MyPV=${PV/_}
BACKPORTS=(
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
	fca62113f5f166a1877907f870620c5df6680e5d	# plugin: fetchinvoice: set the quantity in invreq
	906279a46e6b795f61056abb8a5e19d83cd3774b:scrub-stamps	# Output channel_id in listfunds
	9a3f69aecfbe2c9c4734ac051073949ebc619a33	# connectd: log status_failed on TOR problems
#	2f188622b7545b99178060451beb31cdf7b2e525	# pytest: add timeout to test_feerate_stress.
	03c153ac0bc4847b8bc523170d8c8e75a5e9185a	# channeld: don't spin trying to send commitment while waiting.
#	48c334dc81085f2518186328c81248812b9092b5	# build(deps): bump werkzeug from 2.2.2 to 2.2.3
	21a1b4e6aabc26d5210d09699dc921e8c6f108ea	# common: update HSM_MIN_VERSION to reflect reality.
	e02f5f5bb8ec2e101e5284c2a0a37fbb8e56fd22	# hsmd: new version, which tells us the HSM version, and capabilities.
	91a9cf351290ecccd4a75925c59e22e334798bc6	# hsmd: capability addition: ability to check pubkeys.
	3f02797e88c4d4f955f3ae7ad007ff275f89fcda:strip=common/test/	# lightningd: move bip32_base pointer into struct lightningd.
	3db3dc946f1ee6249394186216a89041ab979617	# lightningd: move bip32_pubkey here from common/, add hsm check.
	df085a8a875e1a02f93bd823ef2cb915563f21dd	# wallet/db: don't use migration_context.
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
	3424f70585e61103eaaae3bf5f443c57407abf97	# plugin: autoclean: cleanup the forwards with localfailed
	97de4f8e0f34665ba6c531cf5ad78f1026856b46	# grpc: make the mTLS private keys user-readable only
	7d7b2abd0203b3b3616866294c267acb55c94114	# msggen: Allow using deprecated fields in the rpc -> grpc conversion
#	98d425f1f40d90078f9efb7a613207f7875293e0	# wallet: add comment on db noting that `ON DELETE CASCADE` is never used.
	09011177a88ded25eacf63dc5c26eb73416b7a25	# wallet: only delete peer from db if it's unused.
	ae861d17931179c319665a40496ffdd00e63d788	# wallet: don't clear reference from channel to peers table when we close channel.
	d9e274cee2610f8c8881ec70ab5e3b944e1ea988	# db_bind_scid: rename to db_bind_short_channel_id
	aae77802efa5a821dfcb76bdac59c2528f124276	# db_col_optional: wrapper for case where a field is allowed to be NULL.
	f720e0ff0be1b2c8eb73ddb4153972086189eb54	# wallet: use db_col_optional.
	6e1eafbb0bb1baf5d57308dcc505c250a20a969d	# wallet: make it clear that `enum state_change` is in db.
	4b6e9649ebfa680138086f7a7373607e8e4aa462	# wallet: add accessor for closed channels.
	454900210593384bcca35338b5819ad493d969c0	# common: expose routine to map channel_type to feature names.
	c9ddf9d1c3bbc5910b691e7aef1cfdd4391820e9	# plugins/sql: handle case of subobject with sub-arrays.
	d818614aa9e67419c03760fa9f05245da255b281	# plugins/sql: recurse correctly into complex objects during processing.
	e75cf2e7fbc143a927f404f70a4c254bd5a4129e:scrub-stamps	# listpeerchannels: add channel_type, both in hex and as array of names.
	89f91b9bb4174b258db237b3dfd78bf3cd3791c0:resolve-conflicts	# lightningd: add listclosedchannels command.
	b8519a6a1a4cf90e2c9b6d93499e112a1a7041e5:scrub-stamps	# plugins/sql: add listclosedchannels
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
	5df469cfca74a2b32cb4d9bdd41cba170f2e33e3:resolve-conflicts	# msggen: Add patching system, add `added` and `deprecated` to Field
	392cacac8170f71f8e1bcffa8673b91964a53bd2	# msggen: Add an optional patch
	60b12ec096dae01aabde25a8ba835a2933f8d70c	# msggen: Use the inferred optional field
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
	3e53c6e359223384ae56319c19cc48c914e375d6	# onchaind: have lightningd create our penalty txs.
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
	e61401aab9962e3e0d5ac96955fa7d1173db4a0c	# reckless: don't crash on subprocess calls
	55cddcd3506acf674dc9515525f500e3227e4f41	# reckless: add support for additional networks
	cf203369bc4aee3fc21b328d39e01a2d41ffcfe5	# reckless: use environment variable redirects
#	2f050621b01f7435aac509d76a5fc530bb0bf8b2	# pytest: add blackbox tests for reckless
#	9384692e2a154f66e9d26fbd0e4b34d8c291310a	# fuzz: add initial seed corpora
#	a1a1373090064d6f38b02981ad6309f2d0e04dd3	# fuzz: improve corpus merging
#	fa988d29420ace0ab7940167ed5cc3c78b87beec	# fuzz: add check-fuzz.sh
#	14afa6efe7e66fcc30218ac5b01badc1f6f8bf41	# make: add check-fuzz target
#	6e11a2e4160eba493e7cac1d7643202a934e9e98	# doc: document "make check-fuzz"
#	ca80dee5145ff9240aa6b4e342e14332bec9973b	# doc: add section about improving fuzzing corpora
	b53cc69cfd4c2cdc6be5e62fc8e706e1b8c43054	# msggen: fix incorrect assertion.
	6799cd5d0b2bc270183660c8944d56daa8661626:scrub-stamps	# plugins/bcli: move commit-fee (dev-max-fee-multiplier) and into core.
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
	a000ee015af7235e0a4ebc14c88ce3cb0f663ce1	# lightningd: do RBF again for all the txs.
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
	62d9ecb6d30fcba766a23aabb445d6607d559a91	# hsmtool: makerune command.
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
	b59b6b9cec0402d497a523f35e07c0171fdca0dd	# reckless: fix CLI redirect, minor cleanup
	61631384203fda2a3ef04407d88b53c1af589dde	# reckless: avoid superfluous config rewrites
	f5a132314a96d29d2cc9fc4d31621e2220d1b273	# reckless: remove extraneous web request
	6ac0842aa1709bd75d777cc7e5d074c35b804a33	# reckless: fix crash on non-verbose output
	d5df26f61312d176c93f51410a5004137c8ec77e	# reckless: add Installer class to support additional languages
	32dd8258d4788b8152d9c28a62f627b1eaba6587	# reckless: add installer methods
	2577096e71e05aa5d7f47f35717d7b99b693e859	# reckless: install command now uses `Installer` class methods
	347e7237f89e23ff163844297bc3fe3092f09558	# reckless: match name using installer entry formats
	d279da551b90d48139244487515709f3625c96ef	# reckless: add missing type hints
	233f05e0e221d9a762b5fe2884e7f8b524cf1b24:strip=tests/	# reckless: enable case-insensitive searching
	f7316954308ae1169b3a51813f775314afb6da77	# reckless: provide response when failing to add source
#	15795c969a7f33d25b9b605b64098f40e9d32bf9	# meta: Add changelog for 23.05rc1
	8163bfc7bd767e3e997fe5c12cd271f418ce29bd	# reckless: simplify installer registration
#	782c17996e31b5b32695f7db6a887a108a9a6076	# pytest: ignore pip warning
	f382ec0452065391269d1d76cc78ecf51c6334e2	# connectd: pass correct buflen to memmem
	ca2a162d70d0907966896634ea5b8df1aa673775	# fix: build with gcc 13 with enum and int mismatch
#	21cc16fb5bfe116bd0430a19c1301ef606c424b9	# meta: Add changelog for 23.05rc2
	2a52e52015f2386ead5999464edd457736906659:scrub-stamps	# jsonrpc: Add versioning annotation to listpeerchannels
	65f513464341e3ed5a4bd223053a162504d1a10d	# msggen: Add ListPeerChannels to generated interfaces
	e7a96cac110812752b275528be222a88b7e91f3c	# msggen: Normalize enum and field names if they contain a '/'
	d28815f7b8bcbfcd5f440e1b1f18d418db101f7c:resolve-conflicts	# msggen: Disable grpc response -> json response temporarily
#	318f35b24372f8c6dd382b668ec4e53d08c2b93a	# pytest: Add a test for the grpc conversion of listpeerchannels
	bff3b1ca8ce89f912bcf956976ce111523cac82d:resolve-conflicts	# msggen: Add ListClosedChannels and overrides
	b41cb2f0050cb94ed671f605e8e7c33eaf10e814	# cln-grpc: Rename the ChannelSide variants
#	90ede052ad3b6f5f10c6aed551a220fc33194cc7	# pytest: Extend ListPeerChannels test to include ListClosedChannels
	1e614dfb8a9d700d6bca812cf8d207bb02f6ca4a	# jsonrpc: Add request schemas for decode and decodepay
	db843159eadf5f638b92d609dbc687046875328c	# msggen: Move overrides into the model itself
	0031f1160bf479906195ceca3628b0c6c090380b	# msggen: Map arrays of hashes and add HtlcState enum
	fc26675336eeee5ed22590f60087af8cfc0ccc63	# msggen: Add DecodePay to the mappings
#	ef9e0fcf6079f096461cf8d561f4f18f5fbf88d0	# pyln: Set the correct envvar for logging for rust plugins
	acc3bb2276ae0b3a7e6f9788519a40cd67ed6765	# msggen: Switch signatures to string instead of bytes
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
	>=sys-libs/zlib-1.2.13:=
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
	newins "${FILESDIR}/lightningd-23.02.conf" lightningd.conf
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
	if [[ -e ${EROOT%/}/etc/lightning/config && ! -e ${EROOT%/}/etc/lightning/lightningd.conf ]] ; then
		elog "Moving your /etc/lightning/config to /etc/lightning/lightningd.conf"
		mv --no-clobber -- "${EROOT%/}/etc/lightning/"{config,lightningd.conf}
	fi
}

pkg_postinst() {
	elog 'To use lightning-cli with the /etc/init.d/lightningd service:'
	elog " - Add your user(s) to the 'lightning' group."
	elog ' - Symlink ~/.lightning to /var/lib/lightning.'
}
