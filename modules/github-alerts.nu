#!/usr/bin/env nu
use ./util/wtf-table.nu

const IGNORED_SEVERITIES = [LOW MODERATE]

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
      link: $in.securityAdvisory.permalink
    }
  }
  | wtf-table
}
