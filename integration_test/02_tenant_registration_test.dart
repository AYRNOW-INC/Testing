/// TEST PLAN: TC-02 — Tenant Registration Flow
///
/// PRECONDITIONS:
///   - Backend running on localhost:8080
///   - PostgreSQL running
///   - No prior login session
///
/// TEST CASES:
///   TC-02-01: Splash screen → Create Account → Register Step 1
///   TC-02-02: Fill personal info with valid tenant data
///   TC-02-03: Tap Next → Step 2, select "I am a Tenant" role
///   TC-02-04: Tap Continue → Tenant Dashboard loads
///
/// EXPECTED BEHAVIOR:
///   - After registration, user lands on Tenant Dashboard
///   - Bottom nav shows: Home | Lease | Pay | Docs | Account
///   - Invite code field appears when Tenant role selected
///
/// PASS CRITERIA:
///   - All 4 test cases pass
///   - Tenant-specific navigation visible

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final email = uniqueEmail('e2e_tenant');

  testWidgets('TC-02: Tenant Registration Flow', (tester) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // TC-02-01: Splash → Register
    print('[TC-02-01] Splash → Register Step 1');
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Personal Information'), findsOneWidget);
    print('[TC-02-01] PASS');

    // TC-02-02: Fill personal info
    print('[TC-02-02] Fill tenant personal info');
    await enterByHint(tester, 'e.g. John', testFirstName);
    await enterByHint(tester, 'e.g. Smith', testTenantLastName);
    await enterByHint(tester, 'john@example.com', email);
    final pwField = byHint('At least 8 characters');
    await tester.ensureVisible(pwField);
    await tester.enterText(pwField, testPassword);
    await tester.pumpAndSettle();
    print('[TC-02-02] PASS');

    // TC-02-03: Step 2 → Select Tenant
    print('[TC-02-03] Select Tenant role');
    await ensureAndTap(tester, find.text('Next: Account Type'));
    expect(find.text('I am a Tenant'), findsOneWidget);
    await tester.tap(find.text('I am a Tenant'));
    await tester.pumpAndSettle();
    // Invite code field should appear for tenant
    expect(find.text('Invite Code (optional)'), findsOneWidget);
    print('[TC-02-03] PASS');

    // TC-02-04: Continue → Tenant Dashboard
    print('[TC-02-04] Complete registration → Tenant Dashboard');
    await ensureAndTap(tester, find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await waitForText(tester, 'Home', timeout: const Duration(seconds: 10));
    expect(find.text('Lease'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);
    print('[TC-02-04] PASS');

    FlutterError.onError = originalOnError;

    print('');
    print('========================================');
    print('  TC-02: TENANT REGISTRATION — ALL PASS');
    print('  Email: $email');
    print('========================================');
  });
}
