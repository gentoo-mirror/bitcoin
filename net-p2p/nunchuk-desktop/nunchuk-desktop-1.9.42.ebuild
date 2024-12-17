# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

# TODO: disembed net-libs/libquotient after Nunchuk switches to Qt6
QUOTIENT_COMMIT_HASH="77b190d822c1e980b98b84999f0cfb609ed05a49"
DESCRIPTION="Graphical multisig wallet powered by Bitcoin Core"
HOMEPAGE="https://github.com/nunchuk-io/nunchuk-desktop"
SRC_URI="
	${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tongvanlinh/libQuotient/archive/${QUOTIENT_COMMIT_HASH}.tar.gz -> ${PN}-quotient-${QUOTIENT_COMMIT_HASH}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-cpp/libnunchuk-0.1.0_pre20241213:=
	>=dev-libs/olm-3.1.3:=
	>=dev-libs/openssl-1.1.0:=
	dev-libs/qtkeychain:=[qt5]
	>=dev-qt/qtconcurrent-5.12:5=
	>=dev-qt/qtcore-5.12:5=
	>=dev-qt/qtdeclarative-5.12:5=
	>=dev-qt/qtgui-5.12:5=
	>=dev-qt/qtmultimedia-5.12:5=[qml]
	>=dev-qt/qtnetwork-5.12:5=[ssl]
	>=dev-qt/qtprintsupport-5.12:5=
	>=dev-qt/qtquickcontrols-5.12:5=
	>=dev-qt/qtsql-5.12:5=
	>=dev-qt/qtsvg-5.12:5=
	>=dev-qt/qttest-5.12:5=
	media-libs/zxing-cpp:=
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/syslibs.patch"
)

extract_icns() { {
	[[ "$(head -c4)" == icns ]] || die "${1} is not in icns format"
	local -i size=$(od --endian=big -An -N4 -tu4)
	(( size == "$(stat -c%s "${1}")" )) || die "${1} has wrong size"
	local type file ; while type=$(head -c4) && (( ${#type} == 4 )) ; do
		size=$(od --endian=big -An -N4 -tu4)
		if [[ ! -v 2 ]] || has "${type}" "${@:2}" ; then file=${1}.${type} ; else file=/dev/null ; fi
		head -c"$((size-8))" >"${file}" || die "failed to write ${file}"
	done
} <"${1:?Must specify icns file.}" ; }

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/contrib" || die
	rmdir quotient || die
	unpack "${PN}-quotient-${QUOTIENT_COMMIT_HASH}.tar.gz"
	mv libQuotient-${QUOTIENT_COMMIT_HASH} quotient || die
}

src_prepare() {
	cmake_src_prepare
	extract_icns Icon.icns ic{11,12,07,08,09}
}

src_install() {
	cmake_src_install
	local each ; for each in 11:32 12:64 07:128 08:256 09:512 ; do
		newicon -s "${each#*:}" "Icon.icns.ic${each%:*}" nunchuk.png
	done
	make_desktop_entry nunchuk-qt Nunchuk nunchuk 'Network;P2P;Qt'
}
