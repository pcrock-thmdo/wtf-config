#!/usr/bin/env nu

use util/wtf-table.nu
use util/str.nu

def main [] {
  # <https://docs.github.com/en/rest/activity/notifications>
  let notifications = (
      gh api
        --header "Accept: application/vnd.github+json"
        --header "X-GitHub-Api-Version: 2022-11-28"
        /notifications
    )
    | from json

  $notifications
    | each {|notif|
      {
        title: ($notif.subject.title | str truncate 35)
        updated_at: ($notif.updated_at | into datetime)
        repo: ($notif.repository.name | str truncate 35)
        reason: $notif.reason
      }
    }
    | wtf-table
}
