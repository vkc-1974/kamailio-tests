# Regex - matches Tests #

Summary: regex - check regex matches

Following tests are done:

  * run kamailio with `kamailio-tregex0001.cfg`, send SIP MESSAGE bodies via
    SIPp (`sipp_message_body_uac.xml`, `-key msgbody`) and check the output
  * reload the regex_group file and recheck other rules
  * SIPp replaces sipsak (message mode segfault: nils-ohlmeier/sipsak#95;
    SIPp from Debian `sip-tester`)
