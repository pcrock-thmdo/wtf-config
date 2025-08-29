#!/usr/bin/env nu

use ./util/sentry.nu
use ./util/wtf-table.nu
const STATS_PERIOD = "7d"
const QUERY = $"is%3Aunresolved%20assigned_or_suggested%3A%23organize-and-schedule"

def main [] {
  (
    sentry get $"organizations/($sentry.ORG)/issues/?statsPeriod=($STATS_PERIOD)&query=($QUERY)&environment=prod&environment=production&sort=date&statsPeriod=7d"
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
