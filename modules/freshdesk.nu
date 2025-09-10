#!/usr/bin/env nu

use ./util/wtf-table.nu

const FRESHDESK_BASE_URL = "https://thermondo.freshdesk.com/api/v2"

def main [] {

  # https://developers.freshdesk.com/api/#filter_tickets
  #
  # group_id: platform
  # status: open, pending, or in progress
  let query_str = (
    {
      query: "\"group_id:35000338410 AND (status:2 OR status:3 OR status:8)\""
    } | url build-query
  )

  (
    freshdesk get $"search/tickets?($query_str)"
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
