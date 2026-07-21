# XKeys Authentication - Using KEMI Lua Script #

Summary: xkeys authentication - using KEMI Lua script

Following tests are done:

  * run kamailio with `kamailio-tauthx0002.cfg` and do xkeys authentication
    using a KEMI Lua script
  * send one SIP MESSAGE with SIPp (`sipp_message_uac.xml`) instead of sipsak
    (sipsak message mode is known to segfault: nils-ohlmeier/sipsak#95;
    SIPp comes from Debian package `sip-tester` as `/usr/bin/sipp`)
  * expect SIP 200 from Kamailio and log line `auth xkeys ok`
