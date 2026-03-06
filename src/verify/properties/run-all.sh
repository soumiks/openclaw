#!/usr/bin/env bash
# Run all 6 property files and summarize results
set -euo pipefail
cd "$(dirname "$0")"

PASS=0
FAIL=0
FILES=(
  p1-dangerous-bypass.smt2
  p2-deny-dominance.smt2
  p3-stripping-soundness.smt2
  p4-subagent-containment.smt2
  p5-profile-monotonicity.smt2
  p6-owner-only-completeness.smt2
)

echo "========================================"
echo " Z3 Tool Policy Verification Suite"
echo "========================================"
echo ""

for f in "${FILES[@]}"; do
  echo "--- Running $f ---"
  if output=$(z3 "$f" 2>&1); then
    echo "$output"
    PASS=$((PASS + 1))
  else
    echo "$output"
    FAIL=$((FAIL + 1))
    echo "*** Z3 returned non-zero for $f ***"
  fi
  echo ""
done

echo "========================================"
echo " Summary: $PASS passed, $FAIL failed"
echo "========================================"
