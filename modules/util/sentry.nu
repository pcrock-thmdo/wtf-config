export const ORG = "thermondo"
export const projects = {
  BACKEND: 12187
  CRAFTSPEOPLE_APP: 4507335033815040
  CRAFTSPEOPLE_SERVICE: 4507498856710144
}
const SENTRY_KEY_ID = "com.philcrockett.wtfutil.sentry"
const SENTRY_BASE_URL = $"https://sentry.io/api/0"

export def get [$endpoint: string]: nothing -> any {
  sentry-api-call get $endpoint
}

export def put [$endpoint: string]: record -> record {
  sentry-api-call put $endpoint
}

# get a list of issues. expects search parameters as record input.
export def issues []: record<query: string, statsPeriod: string, environment: list<string>, project: int> -> list<record> {
  let query_str = $in | url build-query
  sentry-api-call get $"organizations/($ORG)/issues/?($query_str)"
}

# assign one or more issues to a team
export def "assign team" [$team_id: int]: list<record<id: string>> -> list<record> {
  each {|issue|
    { assignedTo: $"team:($team_id)" } | put $"organizations/($ORG)/issues/($issue.id)/"
  }
}

# resolve one or more issues
export def resolve []: list<record<id: string>> -> list<record> {
  each {|issue|
    { status: resolved } | put $"organizations/($ORG)/issues/($issue.id)/"
  }
}

def get-sentry-key []: nothing -> string {
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

