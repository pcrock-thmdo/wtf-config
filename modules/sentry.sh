#!/usr/bin/env bash

set -Eeuo pipefail

readonly ORG="thermondo"
readonly STATS_PERIOD="30d"

# tip:
#
# ```python
# from urllib.parse import urlencode
# urlencode("is:unresolved assigned_or_suggested:[me, my_teams]")
# ```
#
readonly QUERY="is%3Aunresolved+assigned_or_suggested%3A%5Bme%2C+my_teams%5D"

readonly SENTRY_KEY_ID="com.philcrockett.wtfutil.sentry"

get_sentry_api_key() {
    secret-tool lookup xdg:schema "${SENTRY_KEY_ID}"
}

SENTRY_API_KEY="$(get_sentry_api_key)"
readonly SENTRY_API_KEY

curl "https://sentry.io/api/0/organizations/${ORG}/issues/?statsPeriod=${STATS_PERIOD}&query=${QUERY}&environment=prod&environment=production" \
    -H "Authorization: Bearer ${SENTRY_API_KEY}" \
    | jq --raw-output ".[] | [.count, .userCount, (.lastSeen | .[0:10]), .title] | join(\" \")"
