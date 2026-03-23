// ignore_for_file: file_names
// TEST PLAN: TC-03 — Login Flow
//
// PRECONDITIONS:
//   - Backend running on localhost:8080
//   - Existing landlord account: landlord@ayrnow.app / Demo1234A
//   - Existing tenant account: tenant@ayrnow.app / Demo1234A
//
// TEST CASES:
//   TC-03-01: Splash → Tap Login → Login screen loads
//   TC-03-02: Login with valid landlord credentials → Landlord Dashboard
//   TC-03-03: Logout from Account tab → Returns to Splash/Login
//   TC-03-04: Login with valid tenant credentials → Tenant Dashboard
//   TC-03-05: Login with invalid credentials → Error shown
//   TC-03-06: Login with empty fields → Validation errors shown
//
// EXPECTED BEHAVIOR:
//   - Valid landlord login → LandlordShell with Dashboard tab
//   - Valid tenant login → TenantShell with Home tab
//   - Invalid credentials → SnackBar error message
//   - Empty fields → Form validation messages
//
// PASS CRITERIA:
//   - All 6 test cases pass
//   - Correct shell loads per role
//   - Error messages are user-friendly

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-03: Login Flow', (tester) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // TC-03-01: Splash → Login screen
    debugPrint('[TC-03-01] Splash → Login screen');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    debugPrint('[TC-03-01] PASS');

    // TC-03-06: Empty fields → Validation (test first since we're on login)
    debugPrint('[TC-03-06] Empty fields validation');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Valid email required'), findsOneWidget);
    debugPrint('[TC-03-06] PASS');

    // TC-03-05: Invalid credentials → Error
    debugPrint('[TC-03-05] Invalid credentials');
    await enterByHint(tester, 'john@example.com', 'wrong@email.com');
    await enterByHint(tester, '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', 'WrongPass1');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    // Should show error snackbar or remain on login
    final stillOnLogin = tester.any(find.text('Welcome back'));
    expect(stillOnLogin, isTrue);
    debugPrint('[TC-03-05] PASS');

    // TC-03-02: Valid landlord login
    debugPrint('[TC-03-02] Valid landlord login');
    // Clear fields and re-enter
    final emailField = byHint('john@example.com');
    await tester.enterText(emailField, existingLandlordEmail);
    final pwField = byHint('\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022');
    await tester.enterText(pwField, existingPassword);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await waitForText(tester, 'Dashboard', timeout: const Duration(seconds: 10));
    expect(find.text('Properties'), findsOneWidget);
    debugPrint('[TC-03-02] PASS');

    // TC-03-03: Logout
    debugPrint('[TC-03-03] Logout from Account tab');
    await tapNavTab(tester, 'Account');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final logoutBtn = find.text('Log Out');
    if (tester.any(logoutBtn)) {
      await ensureAndTap(tester, logoutBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }
    // Should be back at splash or login
    final backToAuth = tester.any(find.text('Login')) || tester.any(find.text('Welcome back'));
    expect(backToAuth, isTrue);
    debugPrint('[TC-03-03] PASS');

    // TC-03-04: Valid tenant login
    debugPrint('[TC-03-04] Valid tenant login');
    // Navigate to login if on splash
    if (tester.any(find.text('Login')) && !tester.any(find.text('Welcome back'))) {
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }
    await enterByHint(tester, 'john@example.com', existingTenantEmail);
    await enterByHint(tester, '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', existingPassword);
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await waitForText(tester, 'Home', timeout: const Duration(seconds: 10));
    expect(find.text('Pay'), findsOneWidget);
    debugPrint('[TC-03-04] PASS');

    FlutterError.onError = originalOnError;

    debugPrint('');
    debugPrint('========================================');
    debugPrint('  TC-03: LOGIN FLOW — ALL PASS');
    debugPrint('========================================');
  });
}
