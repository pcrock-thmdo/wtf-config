#!/usr/bin/env nu

use ./util/sentry.nu
use ./util/wtf-table.nu
const STATS_PERIOD = "7d"

def main [] {
  let query_str = (
    {
      query: "is:unresolved assigned_or_suggested:#organize-and-schedule"
      statsPeriod: "7d"
      environment: [prod production]
      sort: date
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
