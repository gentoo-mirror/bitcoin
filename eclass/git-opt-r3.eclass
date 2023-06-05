# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: git-opt-r3.eclass
# @MAINTAINER:
# Matt Whitlock <gentoo@mattwhitlock.name>
# @AUTHOR:
# Matt Whitlock <gentoo@mattwhitlock.name>
# @SUPPORTED_EAPIS: 8
# @BLURB: The functionality of git-r3.eclass gated behind USE="git-src"
# @DESCRIPTION:
# This eclass inherits the functionality of git-r3.eclass but gates it behind
# USE="git-src" to make it optional.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GIT_OPT_R3_ECLASS} ]] ; then
_GIT_OPT_R3_ECLASS=1

# @ECLASS_VARIABLE: EGIT_OPT_DEFAULT
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If (and only if) this variable is defined to 1 prior to inheriting this
# eclass, then "+git-src" will be appended to IUSE.  Otherwise, "git-src" will
# be appended instead.
if [[ "${EGIT_OPT_DEFAULT}" == 1 ]] ; then
	IUSE="+git-src"
else
	IUSE="git-src"
fi

for var in E_{{I,REQUIRED_}USE,{,R,P,B,I}DEPEND,PROPERTIES,RESTRICT} ; do
	unset "B${var}" ; declare -n bvar="B${var}"
	[[ -v "${var}" ]] && { bvar="${!var}" ; unset "${var}" ; }
done ; unset {,b}var

inherit git-r3

for var in E_{{I,REQUIRED_}USE,{,R,P,B,I}DEPEND,PROPERTIES,RESTRICT} ; do
	declare -n bvar="B${var}" evar="${var}"
	if [[ -n "${evar}" ]] ; then
		evar="${bvar:+${bvar} }git-src? ( ${evar} )"
	elif [[ -v "B${var}" ]] ; then
		evar="${bvar}"
	fi
	unset "B${var}"
done ; unset {,b,e}var

git-opt-r3_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"
	if use git-src ; then
		git-r3_src_unpack
	else
		default
	fi
}

fi # [[ -z ${_GIT_OPT_R3_ECLASS} ]]

EXPORT_FUNCTIONS src_unpack
