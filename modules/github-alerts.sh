#!/usr/bin/env bash
set -euo pipefail

main() {
    gh alerts --org thermondo | grep --invert-match --perl-regex "(?:low|moderate) severity"
}

main
