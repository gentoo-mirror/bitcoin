# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: backports.eclass
# @MAINTAINER:
# Matt Whitlock <gentoo@mattwhitlock.name>
# @AUTHOR:
# Matt Whitlock <gentoo@mattwhitlock.name>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Applies upstream Git commits to releases
# @DESCRIPTION:
# This eclass facilitates the creation and maintenance of backports versions by
# applying a series of patches fetched from an HTTP-accessible Git repository
# such as GitHub.  The individual patches may be tweaked by specification of a
# sequence of patch mods.  Predefined mods are provided to strip specified
# hunks from upstream patches and to apply local patches to upstream patches
# for the purpose of resolving conflicts.  Additional mods may be user-defined.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: BACKPORTS
# @REQUIRED
# @DESCRIPTION:
# An array of patch specifications.  These patches will be applied by
# backports_apply_patches() after applying any specified mods to them.  Each
# patch specification consists of a commit hash, optionally followed by a colon
# and a colon-separated list of one or more patch mods.  Each patch mod is the
# name of a mod, optionally followed by an equals sign and some argument for
# the mod.
#
# The following patch mods are predefined:
#
# strip=<regex> - Removes from the patch all hunks whose source file path,
# excluding the leading `a/`, matches the specified regular expression.
#
# pick=<regex> - Removes from the patch all hunks whose source file path,
# excluding the leading `a/`, does not match the specified regular expression.
#
# resolve-conflicts - Applies a patch to the patch, typically to resolve
# conflicts that would occur when applying the patch to the source files.  The
# patch patch is read from "${FILESDIR}/${COMMITHASH}.patch", where
# ${COMMITHASH} is the commit hash given at the beginning of the current patch
# specification.  If "${FILESDIR}/${PV}-${COMMITHASH}.patch" exists, then it
# takes precedence.
#
# Eclass users may define additional patch mods by defining functions named
# backports_mod_MODNAME, where MODNAME is the name of the mod to define.  This
# MODNAME may then be referenced in the sequence of patch mods given in a patch
# specification.  To apply the mod, backports_apply_patches() will invoke the
# user-defined function with ${1} set to a path in ${T}, where the patch may
# be found and modified in place.  If the mod is specified with an argument,
# then such argument will be passed to the user-defined function in ${2}.  The
# user-defined function should die if it fails.

# @ECLASS_VARIABLE: BACKPORTS_BASE_URI
# @REQUIRED
# @DESCRIPTION:
# The base URI from which to fetch upstream patches.  This should end in a
# forward slash.  To this base URI will be appended each patch's commit hash
# and ".patch".  You must append $(backports_patch_uris) to SRC_URI to fetch
# these patches.
# @EXAMPLE:
# https://github.com/acme/frobnicator/commit/

# @FUNCTION: backports_patch_uris
# @RETURN: A whitespace-separated list of URIs to be added to SRC_URI.
# @DESCRIPTION:
# Must be called only after setting BACKPORTS.
backports_patch_uris() {
	[[ -n "${BACKPORTS_BASE_URI}" ]] || die 'BACKPORTS_BASE_URI not set'
	local spec
	for spec in "${BACKPORTS[@]}" ; do
		echo "${BACKPORTS_BASE_URI}${spec%%:*}.patch"
	done
}

# @FUNCTION: backports_apply_patches
# @DESCRIPTION:
# Applies the patches specified in BACKPORTS.  This function typically should
# be called in src_prepare().  The default src_prepare() exported by this
# eclass does this for you.  This function dies on failure.
backports_apply_patches() {
	debug-print-function ${FUNCNAME} "${@}"
	local spec patch mod
	local -a args
	for spec in "${BACKPORTS[@]}" ; do
		IFS=: read -r -a args <<<"${spec}"
		set "${args[@]}" ; patch="${1}.patch" ; shift
		if (( ${#} )) ; then
			cp -- {"${DISTDIR}","${T}"}/"${patch}" || die "copying ${patch}"
			patch="${T}/${patch}"
			for mod ; do
				if [[ "${mod}" == *=* ]] ; then
					args=( "${mod#*=}" ) ; mod="${mod%%=*}"
				else
					args=( )
				fi
				declare -f "backports_mod_${mod}" >/dev/null ||
					die "unknown patch mod: ${mod}"
				"backports_mod_${mod}" "${patch}" "${args[@]}"
			done
		else
			patch="${DISTDIR}/${patch}"
		fi
		eapply "${patch}"
	done
}

# @FUNCTION: backports_mod_pick
# @USAGE: <patch> <regex>
# @INTERNAL
# @DESCRIPTION:
# The predefined "pick" patch mod.
# See the description of backports_apply_patches().
backports_mod_pick() {
	(( ${#} == 2 )) || die 'pick mod requires argument'
	sed -ne ':0;/^diff --git/{/^diff --git a\/'"${2////\\/}"'/!{:1;n;/^diff --git /!b1;b0}};p' \
		-i "${1}" || die
}

# @FUNCTION: backports_mod_resolve-conflicts
# @USAGE: <patch>
# @INTERNAL
# @DESCRIPTION:
# The predefined "resolve-conflicts" patch mod.
# See the description of backports_apply_patches().
backports_mod_resolve-conflicts() {
	(( ${#} == 1 )) || die 'resolve-conflicts mod takes no argument'
	if [[ -f "${FILESDIR}/${PV}-${1##*/}" ]] ; then
		patch "${1}" "${FILESDIR}/${PV}-${1##*/}" || die
	else
		patch "${1}" "${FILESDIR}/${1##*/}" || die
	fi
}

# @FUNCTION: backports_mod_strip
# @USAGE: <patch> <regex>
# @INTERNAL
# @DESCRIPTION:
# The predefined "strip" patch mod.
# See the description of backports_apply_patches().
backports_mod_strip() {
	(( ${#} == 2 )) || die 'strip mod requires argument'
	sed -ne ':0;/^diff --git a\/'"${2////\\/}"'/{:1;n;/^diff --git /!b1;b0};p' \
		-i "${1}" || die
}

backports_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"
	backports_apply_patches
	default
}

EXPORT_FUNCTIONS src_prepare
