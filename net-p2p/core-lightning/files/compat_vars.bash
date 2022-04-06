local var val ver
local -a COMPAT_CFLAGS
local -A saved_compat_vars

# load previously saved compatibility flags
while IFS=$'= \t\n' read -r var val ; do
	saved_compat_vars[${var}]=${val}
done < <(cat "${PORTAGE_CONFIGROOT%/}/etc/portage/savedconfig/${CATEGORY}/"{"${PF/ore}","${P/ore}","${PN/ore}","${PF}","${P}","${PN}"} 2>/dev/null)

# initialize compatibility flags based on saved flags and presently installed version
for var in $(sed -ne 's/^COMPAT_CFLAGS=//p' Makefile) ; do
	val=${var#*=} ; var=${var%%=*}
	case "${var}" in
	-DCOMPAT_V[0-9][0-9][0-9])
		ver="${var: -3:1}.${var: -2:1}.$((${var: -1:1}+1))"
		;;
	-DCOMPAT_V[0-9][0-9][0-9][0-9])
		ver="${var: -4:1}.${var: -3:2}.$((${var: -1:1}+1))"
		;;
	*)
		eqawarn "QA Notice: Upstream has added ${var} to COMPAT_CFLAGS,\nand this ebuild does not yet know what to do about it."
		continue
		;;
	esac
	var=${var#-D}
	if [[ ${saved_compat_vars[${var}]} ]] ; then
		val=${saved_compat_vars[${var}]}
	elif ! has_version "<${CATEGORY}/${PN}-${ver}" ; then
		val=0
	fi
	COMPAT_CFLAGS+=( "${var}=${val}" )
done

# write out compatibility flags
printf '%s\n' "${COMPAT_CFLAGS[@]}" >compat.vars

elog "Configuring ${PN} with these compatibility flags:" \
	"${COMPAT_CFLAGS[@]/#/$'\n  '}" \
	$'\n'"Edit /etc/portage/savedconfig/${CATEGORY}/${PN} to customize if needed."

# prepend -D for compiler arguments
COMPAT_CFLAGS=( "${COMPAT_CFLAGS[@]/#/-D}" )
