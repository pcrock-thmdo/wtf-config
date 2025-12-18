#!/usr/bin/env nu
use util/wtf-table.nu

def main [] {
  ^task +ACTIVE export
  | from json
  | select --optional id impact urgency description
  | wtf-table
}
