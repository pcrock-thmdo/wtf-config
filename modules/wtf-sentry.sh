#!/usr/bin/env bash

set -Eeuo pipefail

readonly ORG="thermondo"
readonly PROJECT="thermondo-backend"
readonly STATS_PERIOD="14d"
readonly QUERY="is%3Aunresolved+assigned%3A%5B%23field_service%2C%23svmx%5D"
readonly SENTRY_KEY_ID="com.philcrockett.wtfutil.sentry"

get_sentry_api_key() {
    secret-tool lookup xdg:schema "${SENTRY_KEY_ID}"
}

SENTRY_API_KEY="$(get_sentry_api_key)"
readonly SENTRY_API_KEY

curl "https://sentry.io/api/0/projects/${ORG}/${PROJECT}/issues/?statsPeriod=${STATS_PERIOD}&query=${QUERY}" \
    -H "Authorization: Bearer ${SENTRY_API_KEY}" \
    | jq ".[] | [.count, .userCount, (.lastSeen | .[0:10]), .title] | join(\" \")"
