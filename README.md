## wtf config

**VERY** rough proof-of-concept.

This is my [wtf](https://wtfutil.com/) dashboard configuration. For rationale and a recorded demo session, see [the JF
page where I presented the PoC](https://thermondo.atlassian.net/l/cp/BRMRT6BT).

## TODO:

* [ ] Rethink [./wtf script](wtf) so it doesn't require Linux and `secret-tool`
    * Accept the risk of putting all your secrets in a config file?
    * Install necessary files under `~/.config` etc?
* [ ] Rewrite Sentry module in Python instead of Bash
* [ ] [Freshdesk module](https://developers.freshdesk.com/api/#list_all_tickets)
* [ ] [Gmail module](https://developers.google.com/gmail/api/guides/filtering)
* [ ] [Calendar module](https://wtfutil.com/modules/google/gcal/)
* [ ] Remove unnecessary modules that came in default config file
* [ ] Rearrange panels so they make sense
