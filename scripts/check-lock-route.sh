#!/usr/bin/env bash
# H0 evidence: the compiled lock must send Pi inference to Z.ai with the ZAI_API_KEY secret.
# Prints the route lines for review, then fails if the Z.ai route is missing.
set -euo pipefail

lock="${1:-.github/workflows/spike-pi-glm.lock.yml}"
[ -f "$lock" ] || { echo "::error::missing $lock"; exit 1; }

echo "== Engine and route lines in $lock"
grep -nE 'api\.z\.ai|ANTHROPIC_BASE_URL|ANTHROPIC_API_KEY|ZAI_API_KEY|model-provider|GH_AW_ENGINE|GH_AW_MODEL|--model|glm-' "$lock" | head -80 || true

echo "== Copilot mentions (review by hand; detection is off in the spike)"
grep -niE 'copilot' "$lock" | head -40 || true

fail=0
grep -q 'api\.z\.ai' "$lock"          || { echo "::error::no api.z.ai route in the lock"; fail=1; }
grep -q 'ANTHROPIC_BASE_URL' "$lock"  || { echo "::error::lock does not set ANTHROPIC_BASE_URL"; fail=1; }
grep -q 'secrets.ZAI_API_KEY' "$lock" || { echo "::error::lock does not read the ZAI_API_KEY secret"; fail=1; }
grep -q 'glm-5.3' "$lock"             || { echo "::error::lock does not pin the GLM model"; fail=1; }

[ "$fail" -eq 0 ] && echo "H0 route check passed"
exit "$fail"
