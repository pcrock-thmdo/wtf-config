#!/usr/bin/env nu

use ./util/sentry.nu
use ./util/wtf-table.nu
const STATS_PERIOD = "30d"
const QUERY = "is:unresolved is:unassigned"

def main [] {
  (
    sentry get $"organizations/($sentry.ORG)/issues/?statsPeriod=($STATS_PERIOD)&query=($QUERY)&environment=prod&environment=production"
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
