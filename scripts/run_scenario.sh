#!/bin/bash
# =============================================================================
# AYRNOW — Run a single test scenario
# Usage: ./scripts/run_scenario.sh <number> [simulator_id]
# Example: ./scripts/run_scenario.sh 01
#          ./scripts/run_scenario.sh 04 DF7E7361
# =============================================================================

set -e

SCENARIO="${1:?Usage: ./scripts/run_scenario.sh <number> [simulator_id]}"
SIM_ID="${2:-DF7E7361-5CF5-407B-AC46-7F8896AC115C}"
FRONTEND_DIR="/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/frontend"

# Find the test file
TEST_FILE=$(ls integration_test/${SCENARIO}_*_test.dart 2>/dev/null | head -1)

if [ -z "$TEST_FILE" ]; then
  echo "Error: No test file found for scenario $SCENARIO"
  echo "Available scenarios:"
  ls integration_test/*_test.dart | sed 's/integration_test\//  /' | grep -v helpers | grep -v test_data
  exit 1
fi

SCENARIO_NAME=$(echo "$TEST_FILE" | sed 's/integration_test\///' | sed 's/_test.dart//' | sed 's/^[0-9]*_//')
echo "Running: $TEST_FILE ($SCENARIO_NAME)"
echo "Simulator: $SIM_ID"
echo ""

# Copy test files to app frontend
cp integration_test/*.dart "$FRONTEND_DIR/integration_test/" 2>/dev/null

cd "$FRONTEND_DIR"
flutter test "integration_test/$(basename $TEST_FILE)" -d "$SIM_ID" --timeout 300s 2>&1

echo ""
echo "Done: $SCENARIO_NAME"
