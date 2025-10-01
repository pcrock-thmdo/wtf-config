#!/usr/bin/env nu
use ./util/wtf-table.nu

const IGNORED_SEVERITIES = [LOW]
const SEVERITY_SORT = {
  CRITICAL: 0
  HIGH: 1
  MODERATE: 2
  LOW: 3
}

def main [] {
  gh alerts --org thermondo --json
  | from json
  | where {|alert|
    not ($IGNORED_SEVERITIES | any { $in == $alert.securityVulnerability.severity })
  }
  | each {
    {
      repo: $in.repository.nameWithOwner
      package: $in.securityVulnerability.package.name
      severity: $in.securityVulnerability.severity
      summary: $in.securityAdvisory.summary
    }
  }
  | sort-alerts
  | wtf-table
}

# sort alerts by severity and package name
def sort-alerts [] {
  sort-by {|item| ($SEVERITY_SORT | get $item.severity) } { $in.package }
}
