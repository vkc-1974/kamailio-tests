# Registrar - xavp_rcd Tests #

Summary: registrar - check xavp_rcd values

Following tests are done:

  * run kamailio with `kamailio-tregxx0001.cfg`, send a REGISTER via SIPp
    (`sipp_register_uac.xml`, Contact `sip:test@127.2.2.1:5066`) and check
    `xavp_rcd` values depending on `xavp_rcd_mask` after `save()`
  * send a MESSAGE via SIPp (`sipp_message_uac.xml`) and check `xavp_rcd`
    after `lookup()`
  * repeat for different `xavp_rcd_mask` values
  * SIPp replaces sipsak (message mode segfault: nils-ohlmeier/sipsak#95;
    SIPp from Debian `sip-tester`)
