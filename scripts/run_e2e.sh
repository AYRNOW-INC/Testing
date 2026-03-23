#!/bin/bash
# =============================================================================
# AYRNOW E2E Test Runner
# =============================================================================
# Runs the full landlord→tenant flow across two iOS simulators:
#   Simulator 1 (iPhone 17 Pro):  Landlord registration, property, unit, invite
#   Simulator 2 (iPhone 16e):     Tenant invite accept, onboarding, payment
#
# Prerequisites:
#   - Backend running on localhost:8080
#   - PostgreSQL running
#   - Both simulators booted
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SIM1_ID="DF7E7361-5CF5-407B-AC46-7F8896AC115C"  # iPhone 17 Pro
SIM2_ID="2620A3BC-3BE4-458B-9914-5DCCF40DD747"  # iPhone 16e
FRONTEND_DIR="/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/frontend"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  AYRNOW E2E Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Backend running?
if ! curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
  # Try a simple GET that might return 401/404 but proves the server is up
  if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ > /dev/null 2>&1; then
    echo -e "${RED}Backend not running on :8080. Start it first.${NC}"
    exit 1
  fi
fi
echo -e "${GREEN}  ✓ Backend running on :8080${NC}"

# Simulators booted?
if ! xcrun simctl list devices | grep -q "$SIM1_ID.*Booted"; then
  echo -e "${YELLOW}  Booting iPhone 17 Pro...${NC}"
  xcrun simctl boot "$SIM1_ID" 2>/dev/null || true
fi
echo -e "${GREEN}  ✓ iPhone 17 Pro (Sim 1) booted${NC}"

if ! xcrun simctl list devices | grep -q "$SIM2_ID.*Booted"; then
  echo -e "${YELLOW}  Booting iPhone 16e...${NC}"
  xcrun simctl boot "$SIM2_ID" 2>/dev/null || true
fi
echo -e "${GREEN}  ✓ iPhone 16e (Sim 2) booted${NC}"

# Clean up old coordination files
rm -f /tmp/ayrnow_e2e_*.txt

echo ""
echo -e "${BLUE}── Phase 1: Landlord Flow (iPhone 17 Pro) ──${NC}"
echo ""

cd "$FRONTEND_DIR"

# Run landlord test on Simulator 1
flutter test integration_test/landlord_e2e_test.dart \
  -d "$SIM1_ID" \
  --timeout 300s \
  2>&1 | tee /tmp/ayrnow_e2e_landlord.log

LANDLORD_EXIT=${PIPESTATUS[0]}

if [ $LANDLORD_EXIT -ne 0 ]; then
  echo -e "${RED}Landlord flow failed! Check /tmp/ayrnow_e2e_landlord.log${NC}"
  exit 1
fi

echo -e "${GREEN}Landlord flow completed successfully!${NC}"
echo ""

# Check if invite code was captured
if [ ! -f /tmp/ayrnow_e2e_invite_code.txt ]; then
  echo -e "${YELLOW}Invite code not captured from UI. Attempting API lookup...${NC}"

  TENANT_EMAIL=$(cat /tmp/ayrnow_e2e_tenant_email.txt 2>/dev/null)
  LANDLORD_EMAIL=$(cat /tmp/ayrnow_e2e_landlord_email.txt 2>/dev/null)

  if [ -n "$LANDLORD_EMAIL" ]; then
    # Login as landlord and get invitations
    TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
      -H 'Content-Type: application/json' \
      -d "{\"email\":\"$LANDLORD_EMAIL\",\"password\":\"Test1234A\"}" | \
      python3 -c "import sys,json; print(json.load(sys.stdin).get('accessToken',''))" 2>/dev/null)

    if [ -n "$TOKEN" ]; then
      INVITE_CODE=$(curl -s http://localhost:8080/api/invitations \
        -H "Authorization: Bearer $TOKEN" | \
        python3 -c "import sys,json; data=json.load(sys.stdin); print(data[-1].get('inviteCode','') if data else '')" 2>/dev/null)

      if [ -n "$INVITE_CODE" ]; then
        echo "$INVITE_CODE" > /tmp/ayrnow_e2e_invite_code.txt
        echo -e "${GREEN}  ✓ Invite code retrieved via API: $INVITE_CODE${NC}"
      fi
    fi
  fi
fi

if [ ! -f /tmp/ayrnow_e2e_invite_code.txt ]; then
  echo -e "${RED}Could not retrieve invite code. Tenant flow cannot proceed.${NC}"
  exit 1
fi

INVITE_CODE=$(cat /tmp/ayrnow_e2e_invite_code.txt)
echo -e "${GREEN}  Invite code: $INVITE_CODE${NC}"

echo ""
echo -e "${BLUE}── Phase 2: Tenant Flow (iPhone 16e) ──${NC}"
echo ""

# Run tenant test on Simulator 2
flutter test integration_test/tenant_e2e_test.dart \
  -d "$SIM2_ID" \
  --timeout 300s \
  2>&1 | tee /tmp/ayrnow_e2e_tenant.log

TENANT_EXIT=${PIPESTATUS[0]}

if [ $TENANT_EXIT -ne 0 ]; then
  echo -e "${RED}Tenant flow failed! Check /tmp/ayrnow_e2e_tenant.log${NC}"
  exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  E2E TEST SUITE PASSED${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Landlord email: $(cat /tmp/ayrnow_e2e_landlord_email.txt 2>/dev/null)"
echo -e "Tenant email:   $(cat /tmp/ayrnow_e2e_tenant_email.txt 2>/dev/null)"
echo -e "Invite code:    $(cat /tmp/ayrnow_e2e_invite_code.txt 2>/dev/null)"
echo -e "Property:       E2E Sunset Heights"
echo ""
echo -e "Logs:"
echo -e "  Landlord: /tmp/ayrnow_e2e_landlord.log"
echo -e "  Tenant:   /tmp/ayrnow_e2e_tenant.log"
