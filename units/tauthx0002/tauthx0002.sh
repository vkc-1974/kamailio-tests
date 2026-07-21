#!/bin/bash

. ../../etc/config
. ../../libs/utils

echo "--- start kamailio -f ./kamailio-tauthx0002.cfg"
CMD="${KAMBIN} -P ${KAMPID} -w . -Y ${KAMRUN} -f ./kamailio-tauthx0002.cfg -a no -ddd -E ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}" 2>&1 | tee /tmp/kamailio-tauthx0002.log &
ret=$?
sleep 1

# sipsak MESSAGE mode segfaults on several distros (nils-ohlmeier/sipsak#95);
# use SIPp instead.
CMD="sipp 127.0.0.1:5060 -sf ./sipp_message_uac.xml -s bob -m 1 -timeout 10s -timeout_error -trace_err -nostdin"
echo "--- start sipp"
echo "${CMD}"
eval "${CMD}"
sipp_ret=$?
echo "--------- sipp (exit=${sipp_ret})"
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
grep "auth xkeys ok" /tmp/kamailio-tauthx0002.log
ret=$?
if [ ! "$ret" -eq 0 ] ; then
	exit 1
fi
exit 0
