#!/bin/bash

. ../../etc/config
. ../../libs/utils

LOG=/tmp/kamailio-tregxx0001.log

SIPP_FLAGS="-m 1 -timeout 10s -timeout_error -trace_err -nostdin"

function run() {
	sed -e "s/#mask#/${mask}/g" ./kamailio-tregxx0001-inc > ./kamailio-tregxx0001-inc.cfg
	echo "--- start kamailio -f ./kamailio-tregxx0001.cfg with mask $mask"
	CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -f ./kamailio-tregxx0001.cfg -a no -ddd -E ${KAMEXTRA}"
	echo "${CMD}"
	eval "${CMD}" 2>&1 | tee ${LOG} &
	sleep 1

	# sipsak MESSAGE/REGISTER paths segfault on several distros; use SIPp.
	CMD="sipp 127.0.0.1:5060 -sf ./sipp_register_uac.xml -s test ${SIPP_FLAGS}"
	echo "--- start sipp REGISTER"
	echo "${CMD}"
	eval "${CMD}"
	sipp_ret=$?
	echo "--------- sipp REGISTER (exit=${sipp_ret})"
	if [ ! "$sipp_ret" -eq 0 ] ; then
		kill_pidfile ${KAMPID} 2>/dev/null || true
		exit 1
	fi

	CMD="sipp 127.0.0.1:5060 -sf ./sipp_message_uac.xml -s test ${SIPP_FLAGS}"
	echo "--- start sipp MESSAGE"
	echo "${CMD}"
	eval "${CMD}"
	sipp_ret=$?
	echo "--------- sipp MESSAGE (exit=${sipp_ret})"
	if [ ! "$sipp_ret" -eq 0 ] ; then
		kill_pidfile ${KAMPID} 2>/dev/null || true
		exit 1
	fi

	sleep 1
	kill_pidfile ${KAMPID}
	sleep 1
}

function check() {
	local val=${1}
	local mask=${2}
	if ! grep -q "check\\[REGISTER\\]: ${val} exists" ${LOG} ; then
		echo "[${mask}] ${val} not found in REGISTER"
		exit 1
	fi
	if ! grep -q "check\\[MESSAGE\\]: ${val} exists" ${LOG}; then
		echo "[${mask}] ${val} not found in MESSAGE"
		exit 1

	fi
}

function check_not() {
	val=${1}
	if grep -q "check\\[REGISTER\\]: ${val} exists" ${LOG} ; then
		echo "[${mask}] ${val} found in REGISTER"
		exit 1
	fi
	if grep -q "check\\[MESSAGE\\]: ${val} exists" ${LOG}; then
		echo "[${mask}] ${val} found in MESSAGE"
		exit 1

	fi
}

echo
echo "--- grep output"
echo

mask=0
run
check ruid
check contact
check expires

mask=1
run
check_not ruid
check contact
check expires

mask=2
run
check ruid
check_not contact
check expires

mask=3
run
check_not ruid
check_not contact
check expires

mask=4
run
check ruid
check contact
check_not expires

mask=5
run
check_not ruid
check contact
check_not expires

mask=6
run
check ruid
check_not contact
check_not expires

mask=7
run
check_not ruid
check_not contact
check_not expires

exit 0
