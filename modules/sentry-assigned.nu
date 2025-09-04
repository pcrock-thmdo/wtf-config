#!/usr/bin/env nu

use ./util/sentry.nu
use ./util/wtf-table.nu

def main [] {
  let query_str = (
    {
      query: "is:unresolved assigned_or_suggested:[me,my_teams]"
      statsPeriod: "30d"
      environment: [prod production]
    } | url build-query
  )

  (
    sentry get $"organizations/($sentry.ORG)/issues/?($query_str)"
    | each {
      {
        project: $in.project.name
        count: $in.count
        userCount: $in.userCount
        lastSeen: ($in.lastSeen | into datetime)
        title: $in.title
      }
    }
    | wtf-table
  )
}
