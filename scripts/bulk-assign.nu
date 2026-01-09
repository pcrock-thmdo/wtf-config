#!/usr/bin/env nu

use ../modules/util/sentry.nu

const projects = {
  CRAFTSPEOPLE_APP: 4507335033815040
  CRAFTSPEOPLE_SERVICE: 4507498856710144
}

const teams = {
  INSTALL_FIX_MAINTAIN: 1855812
}

def main [] {
  assign-craftspeople-service-consecutive-http
  assign-craftspeople-app-n-plus-one
  ignore
}

# for some reason consecutive HTTP issues don't get auto-assigned, so we do that here
# for craftspeople service
def assign-craftspeople-service-consecutive-http [] {
  let query_str = (
    {
      query: "is:unresolved is:unassigned issue.type:performance_consecutive_http"
      statsPeriod: "30d"
      environment: [prod production production_release]
      project: $projects.CRAFTSPEOPLE_SERVICE
    } | url build-query
  )

  let issues = sentry get $"organizations/($sentry.ORG)/issues/?($query_str)"
  $"assigning ($issues | length) consecutive HTTP issues to IFM..." | print
  $issues | each { $in.id } | sentry assign team $teams.INSTALL_FIX_MAINTAIN
}

def assign-craftspeople-app-n-plus-one [] {
  let query_str = (
    {
      query: "is:unresolved is:unassigned issue.type:performance_n_plus_one_db_queries"
      statsPeriod: "30d"
      environment: [prod production production_release]
      project: $projects.CRAFTSPEOPLE_APP
    } | url build-query
  )

  let issues = sentry get $"organizations/($sentry.ORG)/issues/?($query_str)"
  $"assigning ($issues | length) N+1 issues to IFM..." | print
  $issues | each { $in.id } | sentry assign team $teams.INSTALL_FIX_MAINTAIN
}
