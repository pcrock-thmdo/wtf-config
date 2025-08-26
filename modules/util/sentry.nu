export const ORG = "thermondo"
const SENTRY_KEY_ID = "com.philcrockett.wtfutil.sentry"
const SENTRY_BASE_URL = $"https://sentry.io/api/0"

export def get [$endpoint: string] {
  sentry-api-call get $endpoint
}

export def put [$endpoint: string] {
  $in | sentry-api-call put $endpoint
}

# assign one or more issues to a team
export def "assign team" [$team_id: int] {
  $in | each {|issue_id|
    print $"assigning issue ($issue_id) to team ($team_id)..."
    { assignedTo: $"team:($team_id)" } | put $"organizations/($ORG)/issues/($issue_id)/"
  }
}

def get-sentry-key [] {
  ^secret-tool lookup xdg:schema $SENTRY_KEY_ID
}

def sentry-api-call [$method: string, $endpoint: string] {
  let body = $in
  let headers = [
    "Authorization" $"Bearer (get-sentry-key)"
  ]
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

