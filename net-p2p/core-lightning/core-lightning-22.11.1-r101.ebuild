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
MyPV=${PV/_}
BACKPORTS=(
#	41987ed379093b4bd61db9907b130d2f0279252f	# doc: check-manpages: add check for unescaped underscores
	09d52b3cb4f5930036a5d4b6b32525fe6d4d917f	# doc: escape more naughty underscores
	31732f7825ab59878cb4704bc2a7b5384cf9c2a0:scrub-stamps	# fromschema.py: escape underscores in descriptions
	4d64374b857e97b4e1c3cc6ea068e5f3fca7e238:scrub-stamps	# doc: drive-by spelling corrections
#	48cfc437c052c030d9f00aba00109dc76fc422a6	# docs: remove the table inside the reoribuild docs
#	df2999045415c4786141bd3a6302bbcd586a8905	# docs: fix typo
	28b7c704dcf8ddc0c3545371acd5f2eee6eb3c9c	# add reserve to the fundchannel docs
	80dacd183e6f8050595e661a33d5313118349501	# doc: replace deprecated parameter keyword "msatoshi" with "amount_msat"
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
	241cd8d0124960d015ea89425d3f5e01faa5318c	# generate composite fields in grpc
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
	879db694e117150c9498ef062eab62ac3d10c163:scrub-stamps	# Ping request types are changed from number to u16
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
	b2148d0eabdf8e2ca8a1c62f829ec826ff8a0930:scrub-stamps	# docs: handle "added": "version" and "deprecated": "version" from schemas.
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
	3c4ce9e448aed2bb10086ff2822fc58256e683ba	# plugins/pay: ensure htables are always tal objects.
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
	611795beee1bdecbde9e7b8c17db96d0934346be:strip='.*\bpreapprove':scrub-stamps	# listtransactions: get rid of per-tx type annotations.
	9ab488fc41ea5f57efbd2eccfd58511755938549:scrub-stamps	# plugins/topology: add direction field to listchannels.
	d6f46e237398bdedb4dd8b8410ce00439b0f5a62:scrub-stamps	# lightningd: fix type of listhtlcs payment_hash.
	83c690fe5f7b9312a4c29b1c045ce1facafd3e0b:scrub-stamps	# doc: fix listsendpays man page.
	0274d88bad83049ba9a4a2355ed6d88bb0f2f109	# common/gossip_store: clean up header.
	7e8b93daa1b2765373124bc660d94e070cc99815	# common/gossip_store: expose routine to read one header.
	153b7bf192942086f565127565b31f40635993be	# common/gossip_store: move subdaemon-only routines to connectd.
	eb6b8551d41ffcec8c98c89d39b47bfc6db50076:strip='.*\bpreapprove':scrub-stamps	# tools/fromschema.py: don't try to handle more complex cases.
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
#	959678244caa56b1935ca9fa616009c532d75024	# doc: remove sections on litestream, .dump and vacuum into
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
	c9c367d770ac16065ebe95cc350578000d92c88e	# dual-fund: remove anchor assumption for all dual-funded channels
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
	dc4ae9deb4dfb7231974ce216fb290fa8911ff94	# msggen: Regenerate for addition of SignInvoice
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
	a71bd3ea37dbcb4edf905b7c3f739ba40939c92f:scrub-stamps	# options: create enable/disable option for peer storage.
	9c35f9c13a04ef4d6e529411c091567ca890f596	# Implement conversion JSON->GRPC also for requests type
	21a8342289a8a8836b7043b7ae565cb8f4eebc39	# Implement GRPC -> JSON conversions also for response types
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
	70aee529037e074c4cd2f034b97536ec04103b3b:strip=tests/	# libplugin: don't spew datastore errors to LOG_DEBUG.
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
	38d90b250596d38a777ab064c3788a730f14d753	# autoclean: fix timer crash when we're cleaning two things at once.
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
	newins "${FILESDIR}/lightningd-22.11.1.conf" lightningd.conf
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
