#!/bin/bash

. ../../etc/config
. ../../libs/utils

LOG=/tmp/kamailio-tpvxxx0001.log

echo "--- start kamailio -f ./kamailio-tpvxxx0001.cfg"
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -f ./kamailio-tpvxxx0001.cfg -a no -ddd -E ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}" 2>&1 | tee ${LOG} &
sleep 1

# sipsak MESSAGE mode segfaults (nils-ohlmeier/sipsak#95); use SIPp instead.
CMD="sipp 127.0.0.1:5060 -sf ./sipp_message_uac.xml -s test1test -m 1 -timeout 10s -timeout_error -trace_err -nostdin"
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
for i in 0 1; do
	if ! grep -q "test${i}: OK" ${LOG}; then
		echo "test${i} failed"
		exit 1
	fi
done
exit 0
