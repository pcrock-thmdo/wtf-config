## wtf config

This is my [wtf](https://wtfutil.com/) dashboard configuration. For
rationale and a recorded demo session, see [the JF page where I presented the
PoC](https://thermondo.atlassian.net/l/cp/BRMRT6BT).

## Dependencies

Besides [wtfutil](https://wtfutil.com/installation/), you need:

* GNU coreutils
* Bash
* libsecret-tools
* [Nushell](https://www.nushell.sh/)
* GitHub CLI with:
  * [my fork of the gh-alerts plugin](https://github.com/pcrock-thmdo/gh-alerts/)
  * `jq`
  * [gh-notify plugin](https://github.com/pcrockett/gh-notify)

## Getting Started

This has only been tested on my development laptop running an Ubuntu-based Linux distro.
PRs welcome for adding macOS support (see [the to-do list](#ideas-for-future-work)).

Assuming you're on a similar dev machine: install the dependencies above and run [the
wtf script](./wtf).

The first run will prompt you to go generate a bunch of API keys etc. Assuming you
follow the prompts correctly, all successive runs will just launch the dashboard in
your terminal.

## Ideas for future work

* [ ] [Slack module](https://api.slack.com/methods/search.messages)
* [ ] [Calendar module](https://wtfutil.com/modules/google/gcal/)
* [ ] [Gmail module](https://developers.google.com/gmail/api/guides/filtering)
* [ ] [Freshdesk module](https://developers.freshdesk.com/api/#list_all_tickets)
