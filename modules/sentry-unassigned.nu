#!/usr/bin/env nu

const ORG = "thermondo"
const SENTRY_KEY_ID = "com.philcrockett.wtfutil.sentry"
const SENTRY_BASE_URL = $"https://sentry.io/api/0"
const STATS_PERIOD = "30d"
const QUERY = "is%3Aunresolved+is%3Aunassigned"

def get-sentry-key-id [] {
  ^secret-tool lookup xdg:schema $SENTRY_KEY_ID
}

def sentry-api-call [$method: string, $endpoint: string] {
  let headers = [
    "Authorization" $"Bearer (get-sentry-key-id)"
  ]
  let body = $in
  match $method {
    "get" => {
      http get $"($SENTRY_BASE_URL)/($endpoint)" --headers $headers
    }
    "put" => {
      (
        http put $"($SENTRY_BASE_URL)/($endpoint)"
          --content-type application/json
          --headers $headers
          $body
      )
    }
  }
}

def main [] {
  (
    sentry-api-call get $"organizations/($ORG)/issues/?statsPeriod=($STATS_PERIOD)&query=($QUERY)&environment=prod&environment=production"
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
