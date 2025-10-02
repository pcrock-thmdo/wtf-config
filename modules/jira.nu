#!/usr/bin/env nu

use util/wtf-table.nu
use util/str.nu

const JIRA_BASE_URL = "https://thermondo.atlassian.net/rest/api/2"
const JIRA_USER_EMAIL = "philip.crockett@thermondo.de"

def main [] {
  # <https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issue-search/#api-rest-api-2-search-jql-get>
  let query_str = (
    {
      jql: 'assignee = currentUser() AND status = "In progress" ORDER BY updated DESC'
      fields: "*all"
    } | url build-query
  )
  (
    (jira-api-call get $"search/jql?($query_str)").issues
    | each {
      {
        key: $in.key
        title: ($in.fields.summary | str truncate 50)
        updated: ($in.fields.updated | into datetime)
        priority: $in.fields.priority.name
      }
    }
    | sort-by updated --reverse
    | wtf-table
  )
}

def get-jira-key [] {
  ^secret-tool lookup xdg:schema "com.philcrockett.wtfutil.jira"
}

def jira-api-call [$method: string, $endpoint: string] {
  match $method {
    "get" => {
      http get $"($JIRA_BASE_URL)/($endpoint)" --user $JIRA_USER_EMAIL --password (get-jira-key)
    }
    _ => {
      error make { msg: "only GET is implemented at the moment" }
    }
  }
}
