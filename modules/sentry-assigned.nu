#!/usr/bin/env nu

use ./util/sentry.nu
const STATS_PERIOD = "30d"
const QUERY = "is%3Aunresolved+assigned_or_suggested%3A%5Bme%2C+my_teams%5D"

def main [] {
  (
    sentry get $"organizations/($ORG)/issues/?statsPeriod=($STATS_PERIOD)&query=($QUERY)&environment=prod&environment=production"
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
