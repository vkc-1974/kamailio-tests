#!/bin/bash

. ../../etc/config
. ../../libs/utils

echo "--- run default config check"
CMD="${KAMBIN} -c ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}"
ret=$?
if [ ! "$ret" -eq 0 ] ; then
    exit $ret
fi

echo
echo "--- start with default config"
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -a no ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}"
ret=$?
sleep 1
kill_pidfile ${KAMPID}
if [ ! "$ret" -eq 0 ] ; then
    exit $ret
fi

echo
echo "--- start with default config and -A WITH_DEBUG"
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -a no -A WITH_DEBUG ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}"
ret=$?
sleep 1
kill_pidfile ${KAMPID}
if [ ! "$ret" -eq 0 ] ; then
    exit $ret
fi

echo
echo "--- start with default config and main -A options (auth, ipauth, usrlodb)"
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -a no -E -e -A WITH_MYSQL -A WITH_IPAUTH -A WITH_USRLOCDB ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}"
ret=$?
sleep 1
kill_pidfile ${KAMPID}
if [ ! "$ret" -eq 0 ] ; then
    exit $ret
fi

echo
echo "--- start with default config and all non-debug -A options (auth, ipauth, usrlodb, nat, presence ..."
CMD="${KAMBIN} -P ${KAMPID} -w ${KAMRUN} -Y ${KAMRUN} -a no -E -e -A WITH_MYSQL -A WITH_AUTH -A WITH_IPAUTH -A WITH_USRLOCDB -A WITH_PRESENCE -A WITH_NAT -A WITH_PSTN -A WITH_ALIASDB -A WITH_SPEEDDIAL -A WITH_MULTIDOMAIN -A WITH_TLS -A WITH_XMLRPC -A WITH_ANTIFLOOD -A WITH_BLOCK3XX -A WITH_BLOCK401407 -A WITH_VOICEMAIL -A WITH_ACCDB ${KAMEXTRA}"
echo "${CMD}"
eval "${CMD}"
ret=$?
sleep 1
kill_pidfile ${KAMPID}
if [ ! "$ret" -eq 0 ] ; then
    exit $ret
fi

exit $ret
