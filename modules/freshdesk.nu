#!/usr/bin/env nu

use util/wtf-table.nu
use util/str.nu

const FRESHDESK_BASE_URL = "https://thermondo.freshdesk.com/api/v2"
const GROUP_PLATFORM = 35000338410
const ticket_status = {
  OPEN: 2
  PENDING: 3
  RESOLVED: 4
  CLOSED: 5
  IN_PROGRESS: 8
  CLOSED_WITHOUT_NOTIFICATION: 20
}
const ticket_priority = {
  1: LOW
  2: MEDIUM
  3: HIGH
  4: FUCKSHITFUCK
}

def main [] {

  # <https://developers.freshdesk.com/api/#filter_tickets>
  let query = [
    $"group_id:($GROUP_PLATFORM)"
    AND
    $"\(status:($ticket_status.OPEN) OR status:($ticket_status.PENDING) OR status:($ticket_status.IN_PROGRESS))"
  ] | str join " "

  let query_str = (
    {
      query: $'"($query)"'  # intentionally putting double-quotes in query string
    } | url build-query
  )

  (
    (freshdesk get $"search/tickets?($query_str)").results
    | each {
      {
        updated_at: ($in.updated_at | into datetime)
        priority: ($in.priority | into priority)
        subject: ($in.subject | str truncate 60)
      }
    }
    | sort-by updated_at --reverse
    | wtf-table
  )
}

def get-freshdesk-key [] {
  ^secret-tool lookup xdg:schema "com.philcrockett.wtfutil.freshdesk"
}

export def "freshdesk get" [$endpoint: string] {
  freshdesk-api-call get $endpoint
}

def freshdesk-api-call [$method: string, $endpoint: string] {
  match $method {
    "get" => {
      http get $"($FRESHDESK_BASE_URL)/($endpoint)" --user (get-freshdesk-key) --password "doesn't matter"
    }
    _ => {
      error make { msg: "only GET is implemented at the moment" }
    }
  }
}

def "into priority" [] {
  let prio_raw_value = ($in | into string)
  let prio = ($ticket_priority | get --optional $prio_raw_value)
  if $prio == null {
    $prio_raw_value  # values have been changed by an admin? just show the number.
  } else {
    $prio
  }
}
