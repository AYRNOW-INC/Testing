# AYRNOW Next Actions — Tomorrow

## PRIORITY 1: Security Baseline (manual, 5 min)
1. Go to GitHub repo settings → set repo to **Private**
2. Enable **Secret scanning** + **Push protection**
3. Enable **Dependabot alerts**
4. Add **branch protection** for `main` (no force push, no deletion)
5. Confirm **2FA** is enabled on GitHub account

## PRIORITY 2: Stripe Live Test (requires keys)
6. Get Stripe TEST mode keys from dashboard.stripe.com
7. Install Stripe CLI: `brew install stripe/stripe-cli/stripe && stripe login`
8. Start webhook listener: `stripe listen --forward-to localhost:8080/api/webhooks/stripe`
9. Set env vars in backend:
   ```
   export STRIPE_SECRET_KEY=sk_test_YOUR_KEY
   export STRIPE_WEBHOOK_SECRET=whsec_FROM_CLI_OUTPUT
   ```
10. Restart backend with real keys
11. Run end-to-end test:
    - Register landlord + tenant
    - Create property + unit
    - Create lease → sign → auto-creates payment
    - Tenant calls checkout → open Stripe URL → pay with test card 4242424242424242
    - Verify webhook fires → payment status SUCCESSFUL in DB
    - Verify tenant payment history + landlord dashboard

## PRIORITY 3: Final Verification
12. Run flutter analyze (0 errors)
13. Run backend compile (BUILD SUCCESS)
14. Test all primary flows on simulator
15. Update _build_memory/FINAL_VERIFICATION.md

## PRIORITY 4: Minor Refinements (optional)
16. Landlord account edit screen (B5)
17. Lease clause editor (E6/E7)
18. Payment ledger screen (H3)
19. Payment success screen (H5)
20. Landlord document review screen (I2)

## PRIORITY 5: Release
21. If Stripe test passes → tag v1.1.0
22. Push final state
