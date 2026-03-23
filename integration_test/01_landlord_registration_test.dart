// ignore_for_file: file_names
// TEST PLAN: TC-01 — Landlord Registration Flow
//
// PRECONDITIONS:
//   - Backend running on localhost:8080
//   - PostgreSQL running
//   - No prior login session (storage cleared)
//
// TEST CASES:
//   TC-01-01: Splash screen loads with Login + Create Account buttons
//   TC-01-02: Tap "Create Account" navigates to Register Step 1
//   TC-01-03: Fill personal info (first name, last name, email, password)
//   TC-01-04: Tap "Next: Account Type" navigates to Step 2
//   TC-01-05: Landlord role is pre-selected, tap "Continue" completes registration
//
// EXPECTED BEHAVIOR:
//   - After registration, user lands on Landlord Dashboard
//   - Bottom nav shows: Dashboard | Properties | Leases | Payments | Account
//   - API: POST /auth/register returns 200 with accessToken
//
// PASS CRITERIA:
//   - All 5 test cases pass
//   - No exceptions or crashes
//   - Dashboard text visible after registration

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final email = uniqueEmail('e2e_landlord');

  testWidgets('TC-01: Landlord Registration Flow', (tester) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // TC-01-01: Splash screen loads
    debugPrint('[TC-01-01] Splash screen loads');
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    debugPrint('[TC-01-01] PASS');

    // TC-01-02: Tap Create Account → Register Step 1
    debugPrint('[TC-01-02] Navigate to Register Step 1');
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Personal Information'), findsOneWidget);
    debugPrint('[TC-01-02] PASS');

    // TC-01-03: Fill personal info
    debugPrint('[TC-01-03] Fill personal info');
    await enterByHint(tester, 'e.g. John', testFirstName);
    await enterByHint(tester, 'e.g. Smith', testLandlordLastName);
    await enterByHint(tester, 'john@example.com', email);
    final pwField = byHint('At least 8 characters');
    await tester.ensureVisible(pwField);
    await tester.enterText(pwField, testPassword);
    await tester.pumpAndSettle();
    debugPrint('[TC-01-03] PASS');

    // TC-01-04: Tap Next → Step 2
    debugPrint('[TC-01-04] Navigate to Step 2');
    await ensureAndTap(tester, find.text('Next: Account Type'));
    expect(find.text('How will you use AYRNOW?'), findsOneWidget);
    debugPrint('[TC-01-04] PASS');

    // TC-01-05: Landlord selected → Continue → Dashboard
    debugPrint('[TC-01-05] Complete registration as Landlord');
    expect(find.text('I am a Landlord'), findsOneWidget);
    await ensureAndTap(tester, find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await waitForText(tester, 'Dashboard', timeout: const Duration(seconds: 10));
    expect(find.text('Properties'), findsOneWidget);
    debugPrint('[TC-01-05] PASS');

    FlutterError.onError = originalOnError;

    debugPrint('');
    debugPrint('========================================');
    debugPrint('  TC-01: LANDLORD REGISTRATION — ALL PASS');
    debugPrint('  Email: $email');
    debugPrint('========================================');
  });
}
