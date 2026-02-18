#!/usr/bin/env nu
#
# **SENTRY API KEY NOTE**: If you are assigning issues to a team of which you are not a
# member, your API key needs the "team admin" scope.
#

use ../modules/util/sentry.nu

const teams = {
  FULFILLMENT: 4510545440669696
  INSTALL_FIX_MAINTAIN: 1855812
  PLATFORM: 1218304
}

# Assign common Sentry issues that Sentry ownership rules don't cover
def main [
  --obvious-only:  # only assign blindingly obvious issues with no edge cases
] {
  assign-consecutive-http CRAFTSPEOPLE_SERVICE INSTALL_FIX_MAINTAIN
  assign-consecutive-http CRAFTSPEOPLE_APP INSTALL_FIX_MAINTAIN
  assign-n-plus-one CRAFTSPEOPLE_APP INSTALL_FIX_MAINTAIN
  assign-n-plus-one FULFILLMENT FULFILLMENT

  if (not $obvious_only) {
    assign-backend-memory-exceeded
  }

  ignore
}

def assign-backend-memory-exceeded [] {
  let issues = (
    {
      query: 'is:unresolved is:unassigned "Memory quota exceeded (R14)"'
      statsPeriod: "7d"
      environment: [production]
      project: $sentry.projects.BACKEND
    }
    | sentry issues
  )
  $"assigning ($issues | length) memory quota exceeded issues to platform..." | print
  $issues | sentry assign team $teams.PLATFORM
}

def assign-n-plus-one [project: string, team: string] {
  assign-issue-type $project $team performance_n_plus_one_db_queries
}

def assign-consecutive-http [project: string, team: string] {
  assign-issue-type $project $team performance_consecutive_http
}

def assign-issue-type [project: string, team: string, issue_type: string] {
  let project_id = $sentry.projects | get $project
  let team_id = $teams | get $team
  let issues = (
    {
      query: $"is:unresolved is:unassigned issue.type:($issue_type)"
      statsPeriod: "30d"
      environment: [prod production production_release]
      project: $project_id
    }
    | sentry issues
  )
  $"assigning ($issues | length) ($project) project ($issue_type) issues to ($team) team..." | print
  $issues | sentry assign team $team_id
}
