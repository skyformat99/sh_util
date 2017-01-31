#!/bin/bash
#
# @brief   Calculate md5sum from an input string
# @version ver.1.0
# @date    Tue Mar 15 16:35:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_MD5SUM=md5sum
UTIL_MD5SUM_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_MD5SUM_VERSION}
UTIL_MD5SUM_CFG=${UTIL}/conf/${UTIL_MD5SUM}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A MD5SUM_USAGE=(
	[USAGE_TOOL]="__${UTIL_MD5SUM}"
	[USAGE_ARG1]="[INSTRING] input string"
	[USAGE_EX_PRE]="# Calculate md5sum from an input string"
	[USAGE_EX]="__${UTIL_MD5SUM} simpletest"
)

#
# @brief  Calculate md5sum from an input string
# @param  Value required input string
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __md5sum "$INSTRING"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __md5sum() {
	local INSTRING=$1
	if [ -n "${INSTRING}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_md5sum=()
		__load_util_conf "$UTIL_MD5SUM_CFG" config_md5sum
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local MD5SUM=${config_md5sum[MD5SUM]}
			__check_tool "${MD5SUM}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
					MSG="Calculate md5sum from an input string!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_MD5SUM"
				eval "${MD5SUM}<<<"${INSTRING}" | cut -f1 -d' ';"
				__info_debug_message_end "Done" "$FUNC" "$UTIL_MD5SUM"
				return $SUCCESS
			fi
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_MD5SUM"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_MD5SUM"
		return $NOT_SUCCESS
	fi
	__usage MD5SUM_USAGE
	return $NOT_SUCCESS
}

