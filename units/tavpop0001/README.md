# avpops - avp_subst() Tests #

Summary: avpops - avp_subst() and avp_subst_pv() tests

Following tests are done:

  * run kamailio with `kamailio-tavpop0001.cfg` and test if avps are set
    accordingly with the subst rules
  * send one SIP MESSAGE with SIPp (`sipp_message_uac.xml`) instead of sipsak
    (sipsak message mode segfault: nils-ohlmeier/sipsak#95; SIPp from Debian
    `sip-tester`)
  * expect SIP 200 and log lines `test0: OK` … `test9: OK`
