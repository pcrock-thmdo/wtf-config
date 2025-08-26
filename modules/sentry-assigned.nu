#!/usr/bin/env nu

use ./util/sentry.nu
const STATS_PERIOD = "30d"
const QUERY = "is:unresolved assigned_or_suggested:[me,+my_teams]"

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
    | table --index false --theme none
  )
}
