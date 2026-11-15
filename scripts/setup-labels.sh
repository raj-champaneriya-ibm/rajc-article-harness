#!/usr/bin/env bash
# Creates the labels the issue form, the router and the spike rely on. Safe to re-run.
# Usage: scripts/setup-labels.sh [owner/repo]
set -euo pipefail
repo="${1:-rajchampaneriya/rajc-article-harness}"

while IFS='|' read -r name color description; do
  gh label create "$name" --repo "$repo" --color "$color" --description "$description" --force
done <<'EOF'
article|0F2744|An article tracked by the harness
stage:idea|C5CFDD|Captured, not yet interviewed
stage:interviewing|85B7EB|Interviewer has asked questions
stage:drafted|2F6FD6|Draft pull request is open
ready-to-publish|1D9E75|Publisher may merge and deploy
spike|C98A12|Opened by the spike workflow
EOF
