#!/bin/bash
#
# @brief   Create a heap dump of a Java process
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_JHEAPDUMP=jheapdump
UTIL_JHEAPDUMP_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_JHEAPDUMP_VERSION
UTIL_JHEAPDUMP_CFG=$UTIL/conf/$UTIL_JHEAPDUMP.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/loadutilconf.sh

declare -A JHEAPDUMP_USAGE=(
    [USAGE_TOOL]="__$UTIL_JHEAPDUMP"
    [USAGE_ARG1]="[PID_OF_JVM] PID of JVM"
    [USAGE_EX_PRE]="# Create a heap dump of a Java process"
    [USAGE_EX]="__$UTIL_JHEAPDUMP 2334"	
)

#
# @brief  Create a heap dump of a Java process
# @param  Value required pid of java app
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __jheapdump "$PID_OF_JVM"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __jheapdump() {
    local PID_OF_JVM=$1
    if [ -n "$PID_OF_JVM" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		declare -A configjheapdumputil=()
		__loadutilconf "$UTIL_JHEAPDUMP_CFG" configjheapdumputil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local jmap=${configjheapdumputil[JMAP]}
			__checktool "$jmap"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Create a heap dump of a java process [$PID_OF_JVM]"
					printf "$DSTA" "$UTIL_JHEAPDUMP" "$FUNC" "$MSG"
				fi
				local i="0"
				while [ $i -lt 10 ]
				do
					eval "$jmap -dump:file=/tmp/java-`date +%s`.hprof $PID_OF_JVM"
					sleep 30
					i=$[$i+1]
				done
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_JHEAPDUMP" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
		return $NOT_SUCCESS
    fi
    __usage JHEAPDUMP_USAGE
    return $NOT_SUCCESS
}

