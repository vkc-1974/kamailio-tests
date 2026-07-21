# pv - $xavi(...) Tests #

Summary: pv - $xavi() tests

Following tests are done:

  * run kamailio with `kamailio-tpvxxx0001.cfg` and test if `$xavi` in config
  * send one SIP MESSAGE with SIPp (`sipp_message_uac.xml`) instead of sipsak
    (sipsak message mode segfault: nils-ohlmeier/sipsak#95; SIPp from Debian
    `sip-tester`)
  * expect SIP 200 and log lines `test0: OK` / `test1: OK`
