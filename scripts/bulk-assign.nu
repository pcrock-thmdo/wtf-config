#!/usr/bin/env nu

use ../modules/util/sentry.nu

const teams = {
  INSTALL_FIX_MAINTAIN: 1855812
  PLATFORM: 1218304
}

# Assign obvious Sentry issues that Sentry ownership rules don't cover
def main [
  --obvious-only:  # only assign blindingly obvious issues with no edge cases
] {
  assign-craftspeople-service-consecutive-http
  assign-craftspeople-app-n-plus-one

  if (not $obvious_only) {
    assign-backend-memory-exceeded
  }

  ignore
}

def assign-craftspeople-service-consecutive-http [] {
  let issues = (
    {
      query: "is:unresolved is:unassigned issue.type:performance_consecutive_http"
      statsPeriod: "30d"
      environment: [prod production production_release]
      project: $sentry.projects.CRAFTSPEOPLE_SERVICE
    }
    | sentry issues
  )
  $"assigning ($issues | length) consecutive HTTP issues to IFM..." | print
  $issues | sentry assign team $teams.INSTALL_FIX_MAINTAIN
}

def assign-craftspeople-app-n-plus-one [] {
  let issues = (
    {
      query: "is:unresolved is:unassigned issue.type:performance_n_plus_one_db_queries"
      statsPeriod: "30d"
      environment: [prod production production_release]
      project: $sentry.projects.CRAFTSPEOPLE_APP
    }
    | sentry issues
  )
  $"assigning ($issues | length) N+1 issues to IFM..." | print
  $issues | sentry assign team $teams.INSTALL_FIX_MAINTAIN
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
