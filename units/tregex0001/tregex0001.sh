#!/bin/bash

. ../../etc/config
. ../../libs/utils

LOG=/tmp/kamailio-tregex0001.log

cp regex_groups_1 /tmp/regex_groups
echo "--- start kamailio -f ./kamailio-tregex0001.cfg"
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -f ./kamailio-tregex0001.cfg -a no -ddd -E ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}" 2>&1 | tee ${LOG} &
ret=$?
sleep 1

# sipsak MESSAGE mode segfaults (nils-ohlmeier/sipsak#95); use SIPp instead.
SIPP_BASE="sipp 127.0.0.1:5060 -sf ./sipp_message_body_uac.xml -s test -m 1 -timeout 10s -timeout_error -trace_err -nostdin"

CMD="${SIPP_BASE} -key msgbody \"HOLA caracola\""
echo "--- start sipp (HOLA)"
echo "${CMD}"
eval "${CMD}"
sipp_ret=$?
echo "--------- sipp HOLA (exit=${sipp_ret})"
if [ ! "$sipp_ret" -eq 0 ] ; then
	kill_pidfile ${KAMPID} 2>/dev/null || true
	exit 1
fi

echo "--- regex reload ---"
cp regex_groups_2 /tmp/regex_group
${KAMCTL} kamcmd regex.reload
sleep 1

CMD="${SIPP_BASE} -key msgbody \"ADIOS caracola\""
echo "--- start sipp (ADIOS)"
echo "${CMD}"
eval "${CMD}"
sipp_ret=$?
echo "--------- sipp ADIOS (exit=${sipp_ret})"
if [ ! "$sipp_ret" -eq 0 ] ; then
	kill_pidfile ${KAMPID} 2>/dev/null || true
	exit 1
fi

sleep 1
kill_pidfile ${KAMPID}
sleep 1
echo
echo "--- grep output"
echo

if ! grep -q '\^HOLA matches' ${LOG} ; then
    exit 1
fi
if ! grep -q '\^HOLA group 0 matches' ${LOG} ; then
    exit 1
fi

if ! grep -q '\^ADIOS matches' ${LOG} ; then
    exit 1
fi
if ! grep -q '\^ADIOS group 0 matches' ${LOG} ; then
    exit 1
fi
exit 0
