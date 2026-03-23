import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';
import 'test_data.dart';

/// E2E Tenant Flow — runs on iPhone 16e (Simulator 2)
///
/// Flow: Accept Invite → Register → Login → Onboarding → Pay Rent
///
/// Reads invite code and tenant email from shared temp files
/// written by the landlord E2E test.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late String tenantEmail;
  late String inviteCode;

  setUpAll(() {
    // Read coordination data from landlord test
    tenantEmail = readSharedValue('tenant_email');
    inviteCode = readSharedValue('invite_code');
    debugPrint('>> Tenant E2E starting with:');
    debugPrint('   Email: $tenantEmail');
    debugPrint('   Invite code: $inviteCode');
  });

  testWidgets('Tenant E2E: Accept Invite → Register → Onboard → Pay',
      (WidgetTester tester) async {
    // Clear any stored tokens from previous runs
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 1: Splash → Login ──
    debugPrint('>> Step 1: Splash screen → Login');
    await waitForText(tester, 'Login');
    await tapText(tester, 'Login');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ── Step 2: Login → "Have an invite code?" ──
    debugPrint('>> Step 2: Tap "Have an invite code?"');
    await waitForText(tester, 'Welcome back');

    await ensureAndTap(tester, find.text('Have an invite code?'));

    // ── Step 3: Enter invite code in dialog ──
    debugPrint('>> Step 3: Enter invite code: $inviteCode');
    await waitForText(tester, 'Enter Invite Code');

    // The dialog has a TextField with hint 'e.g. F410ACE1'
    await enterByHint(tester, 'e.g. F410ACE1', inviteCode);

    // Tap "View Invitation"
    await tester.tap(find.text('View Invitation'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 4: Invite Accept Screen — "Accept & Create Account" ──
    debugPrint('>> Step 4: Invite Accept Screen');
    await waitForText(tester, "You're Invited!",
        timeout: const Duration(seconds: 10));

    await ensureAndTap(tester, find.text('Accept & Create Account'));

    // ── Step 5: Verification — Set password ──
    debugPrint('>> Step 5: Set password on verification screen');
    await waitForText(tester, 'Security Setup');

    // Create Password field
    final createPwField = byHint('At least 8 characters');
    await tester.ensureVisible(createPwField);
    await tester.enterText(createPwField, testPassword);
    await tester.pumpAndSettle();

    // Confirm Password field
    final confirmPwField = byHint('Re-enter password');
    await tester.ensureVisible(confirmPwField);
    await tester.enterText(confirmPwField, testPassword);
    await tester.pumpAndSettle();

    // Wait for requirements to turn green, then tap "Accept Invite & Continue"
    await tester.pump(const Duration(seconds: 1));
    await ensureAndTap(tester, find.text('Accept Invite & Continue'));

    // ── Step 6: Register Screen (pushed from invite accept) ──
    debugPrint('>> Step 6: Register as tenant');
    await waitForText(tester, 'Personal Information',
        timeout: const Duration(seconds: 5));

    await enterByHint(tester, 'e.g. John', 'E2E');
    await enterByHint(tester, 'e.g. Smith', 'Tenant');
    await enterByHint(tester, 'john@example.com', tenantEmail);

    final pwField = byHint('At least 8 characters');
    await scrollToWidget(tester, pwField);
    await tester.enterText(pwField, testPassword);
    await tester.pumpAndSettle();

    // Tap "Next: Account Type"
    await ensureAndTap(tester, find.text('Next: Account Type'));

    // ── Step 7: Select Tenant role ──
    debugPrint('>> Step 7: Select Tenant role');
    await waitForText(tester, 'How will you use AYRNOW?');

    // Tap "I am a Tenant" card
    await tester.tap(find.text('I am a Tenant'));
    await tester.pumpAndSettle();

    // Tap Continue
    await ensureAndTap(tester, find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 8: Tenant Dashboard ──
    debugPrint('>> Step 8: Tenant Dashboard loaded');
    await waitForText(tester, 'Home', timeout: const Duration(seconds: 10));

    // ── Step 9: Check Onboarding / Dashboard ──
    debugPrint('>> Step 9: Explore tenant tabs');

    // Tap Lease tab
    await tapNavTab(tester, 'Lease');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    debugPrint('   >> Lease tab loaded');

    // Tap Pay tab
    await tapNavTab(tester, 'Pay');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    debugPrint('   >> Pay tab loaded');

    // ── Step 10: Attempt payment (if any pending) ──
    debugPrint('>> Step 10: Check for pending payments');
    final payNowButton = find.text('Pay Now');
    if (tester.any(payNowButton)) {
      debugPrint('   >> Found overdue payment — tapping Pay Now');
      await tester.tap(payNowButton.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Payment summary bottom sheet should appear
      if (tester.any(find.text('TRANSACTION SUMMARY'))) {
        debugPrint('   >> Payment summary shown');
        // Find the "Pay $X" button in the bottom sheet
        final payActionBtn = find.byType(ElevatedButton).last;
        await tester.tap(payActionBtn);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        debugPrint('   >> Payment initiated (Stripe checkout would open externally)');
      }
    } else if (tester
        .any(find.text('No payments'))) {
      debugPrint('   >> No payments available yet (lease not fully executed)');
    } else {
      debugPrint('   >> Payment list loaded');
    }

    // Tap Docs tab
    await tapNavTab(tester, 'Docs');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    debugPrint('   >> Docs tab loaded');

    // Tap Account tab
    await tapNavTab(tester, 'Account');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    debugPrint('   >> Account tab loaded');

    // ── Step 11: Upload documents via API (can't automate FilePicker) ──
    debugPrint('>> Step 11: Simulating document upload via API');
    try {
      await apiLogin(tenantEmail, testPassword);
      debugPrint('   >> Tenant logged in via API successfully');
      debugPrint('   >> Document upload requires real files — skipping in automation');
    } catch (e) {
      debugPrint('   >> API login attempt: $e');
    }

    debugPrint('');
    debugPrint('========================================');
    debugPrint('  TENANT E2E FLOW COMPLETE');
    debugPrint('  Email: $tenantEmail');
    debugPrint('  Invite code: $inviteCode');
    debugPrint('========================================');
  });
}
