#!/usr/bin/env nu

use ../modules/util/sentry.nu

def main [] {
  resolve-timeouts
  ignore
}

def resolve-timeouts [] {
  let issues = (
    {
      query: 'is:unresolved is:unassigned "request timeout on /"'
      statsPeriod: "7d"
      environment: [production]
      project: $sentry.projects.BACKEND
    }
    | sentry issues
  )

  $"resolving ($issues | length) request timeout issues..." | print
  $issues | sentry resolve
}
