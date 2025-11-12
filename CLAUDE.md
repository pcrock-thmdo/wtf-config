# CLAUDE.md

This file provides guidance to AI coding assistants when working with code in this repository.

## Overview

This is a custom [wtfutil](https://wtfutil.com/) dashboard configuration that displays real-time information from multiple services (Jira, GitHub, Sentry, Freshdesk) in a terminal dashboard. All modules are implemented as executable Nushell scripts that output formatted tables.

## Running the Dashboard

```bash
./wtf
```

The `wtf` script handles API key setup via libsecret-tools (prompting on first run) and launches wtfutil with the config file. It sets up environment variables for:
- `WTF_JIRA_API_KEY` (from secret-tool)
- `WTF_GITHUB_TOKEN` (from gh CLI)
- `WTF_SENTRY_TOKEN` (from secret-tool)
- `WTF_FRESHDESK_TOKEN` (from secret-tool)

## Architecture

### Module System

All dashboard widgets use wtfutil's `cmdrunner` module type, executing Nushell scripts that:
1. Fetch data from external APIs
2. Transform and filter the data
3. Format output via the shared `wtf-table.nu` utility
4. Append a timestamp to the output

### Core Components

**config.yml**: wtfutil configuration defining a 4x4 grid layout with modules for clocks, power, Heroku status, Jira, GitHub notifications/alerts, Sentry issues, and Freshdesk tickets.

**modules/**: Executable Nushell scripts for each data source:
- `jira.nu` - Shows "In Progress" tickets for current user
- `github-notifications.nu` - Shows GitHub notifications
- `github-alerts.nu` - Shows Dependabot security alerts (requires custom gh-alerts plugin)
- `sentry-assigned.nu` - Shows Sentry issues assigned to user or their teams
- `sentry-unassigned.nu` - Shows unassigned Sentry issues
- `freshdesk.nu` - Shows open/pending/in-progress tickets for Platform team

**modules/util/**: Shared utility modules:
- `wtf-table.nu` - Formats data as borderless tables with timestamps
- `sentry.nu` - Sentry API client with `get`, `put`, and `assign team` functions
- `str.nu` - String truncation utility

**scripts/**: Automation scripts:
- `bulk-assign.nu` - Auto-assigns specific Sentry issue types to teams

### API Integration Pattern

Each module follows this pattern:
1. Build query string with `url build-query`
2. Call API via reusable function (e.g., `jira-api-call`, `freshdesk-api-call`) or external tool (gh CLI)
3. Parse and transform response using Nushell pipelines
4. Truncate long strings to fit dashboard layout
5. Sort by relevance (usually by date or severity)
6. Format with `wtf-table`

Authentication is handled via:
- **secret-tool**: For Jira, Sentry, Freshdesk (keys stored in libsecret keyring)
- **gh CLI**: For GitHub (uses `gh auth token`)

### Hardcoded Configuration

The modules contain Thermondo-specific constants:
- Organization names and URLs
- Team IDs and project IDs (Sentry, Freshdesk)
- User email addresses
- These would need updating for use in different organizations

## Development Commands

Test individual modules:
```bash
# Run a single module to see its output
./modules/jira.nu
./modules/github-notifications.nu
./modules/sentry-assigned.nu
```

Run automation scripts:
```bash
./scripts/bulk-assign.nu
```

The modules are standard Nushell scripts with shebang, so they can be executed directly once made executable.
