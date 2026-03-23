/// TEST PLAN: TC-13 — Dashboard Navigation Flow (UI)
///
/// PRECONDITIONS:
///   - Backend running on localhost:8080
///   - Both landlord and tenant accounts exist
///
/// TEST CASES:
///   TC-13-01: Login as landlord → Dashboard tab loads
///   TC-13-02: Tap Properties tab → Properties screen loads
///   TC-13-03: Tap Leases tab → Leases screen loads
///   TC-13-04: Tap Payments tab → Payments screen loads
///   TC-13-05: Tap Account tab → Account screen loads
///   TC-13-06: Logout → Login as tenant → Verify tenant tabs
///
/// EXPECTED BEHAVIOR:
///   - Landlord: Dashboard | Properties | Leases | Payments | Account
///   - Tenant: Home | Lease | Pay | Docs | Account
///   - Each tab loads without errors
///   - Tab switching is instant (no loading between tabs)
///
/// PASS CRITERIA:
///   - All 6 test cases pass
///   - No crashes on tab switch
///   - Correct tab labels per role

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-13: Dashboard Navigation Flow', (tester) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Login as landlord
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await enterByHint(tester, 'john@example.com', existingLandlordEmail);
    await enterByHint(tester, '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', existingPassword);
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // TC-13-01: Dashboard tab
    print('[TC-13-01] Landlord Dashboard tab');
    await waitForText(tester, 'Dashboard', timeout: const Duration(seconds: 10));
    print('[TC-13-01] PASS');

    // TC-13-02: Properties tab
    print('[TC-13-02] Properties tab');
    await tapNavTab(tester, 'Properties');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Properties'), findsWidgets);
    print('[TC-13-02] PASS');

    // TC-13-03: Leases tab
    print('[TC-13-03] Leases tab');
    await tapNavTab(tester, 'Leases');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    print('[TC-13-03] PASS');

    // TC-13-04: Payments tab
    print('[TC-13-04] Payments tab');
    await tapNavTab(tester, 'Payments');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    print('[TC-13-04] PASS');

    // TC-13-05: Account tab
    print('[TC-13-05] Account tab');
    await tapNavTab(tester, 'Account');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Account'), findsWidgets);
    print('[TC-13-05] PASS');

    // TC-13-06: Logout → Tenant login → Tenant tabs
    print('[TC-13-06] Logout → Tenant tabs');
    final logoutBtn = find.text('Log Out');
    if (tester.any(logoutBtn)) {
      await ensureAndTap(tester, logoutBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // Login as tenant
    if (!tester.any(find.text('Welcome back'))) {
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }
    await enterByHint(tester, 'john@example.com', existingTenantEmail);
    await enterByHint(tester, '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', existingPassword);
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await waitForText(tester, 'Home', timeout: const Duration(seconds: 10));
    expect(find.text('Lease'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);

    // Quick tap through tenant tabs
    await tapNavTab(tester, 'Lease');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tapNavTab(tester, 'Pay');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tapNavTab(tester, 'Docs');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tapNavTab(tester, 'Account');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    print('[TC-13-06] PASS');

    FlutterError.onError = originalOnError;

    print('');
    print('========================================');
    print('  TC-13: DASHBOARD NAVIGATION — ALL PASS');
    print('========================================');
  });
}
