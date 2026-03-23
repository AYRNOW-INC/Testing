import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ayrnow/main.dart' as app;
import 'helpers.dart';

/// E2E Landlord Flow — runs on iPhone 17 Pro (Simulator 1)
///
/// Flow: Register → Login → Add Property → Setup Unit → Set Rent → Invite Tenant
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final landlordEmail = uniqueEmail('e2e_landlord');
  final tenantEmail = uniqueEmail('e2e_tenant');
  const propertyName = 'E2E Sunset Heights';

  // Save emails to shared files so tenant test can read them
  writeSharedValue('landlord_email', landlordEmail);
  writeSharedValue('tenant_email', tenantEmail);

  testWidgets('Landlord E2E: Register → Property → Unit → Invite',
      (WidgetTester tester) async {
    // Clear any stored tokens from previous runs so we start fresh at login
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 1: Splash → Create Account ──
    print('>> Step 1: Splash screen → Create Account');
    await waitForText(tester, 'Create Account');
    await tapText(tester, 'Create Account');

    // ── Step 2: Register Step 1 — Personal Info ──
    print('>> Step 2: Register - Personal Info');
    await waitForText(tester, 'Personal Information');

    await enterByHint(tester, 'e.g. John', 'E2E');
    await enterByHint(tester, 'e.g. Smith', 'Landlord');
    await enterByHint(tester, 'john@example.com', landlordEmail);

    // Scroll down to password field
    final passwordField = byHint('At least 8 characters');
    await scrollToWidget(tester, passwordField);
    await tester.enterText(passwordField, testPassword);
    await tester.pumpAndSettle();

    // Scroll to and tap "Next: Account Type"
    await ensureAndTap(tester, find.text('Next: Account Type'));

    // ── Step 3: Register Step 2 — Role Selection ──
    print('>> Step 3: Register - Role Selection (Landlord)');
    await waitForText(tester, 'How will you use AYRNOW?');
    // Landlord is already selected by default, just tap Continue
    await ensureAndTap(tester, find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 4: Verify we're on the Landlord Dashboard ──
    print('>> Step 4: Landlord Dashboard loaded');
    await waitForText(tester, 'Dashboard', timeout: const Duration(seconds: 10));

    // ── Step 5: Navigate to Properties tab ──
    print('>> Step 5: Navigate to Properties tab');
    await tapNavTab(tester, 'Properties');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 6: Add Property ──
    print('>> Step 6: Add First Property');
    // For new accounts, we'll see the empty state with "Add First Property"
    // The button may be below the bottom nav bar, so scroll it into view
    final addFirstProp = find.text('Add First Property');
    final fabAdd = find.byIcon(Icons.add);
    if (tester.any(addFirstProp)) {
      // Scroll the button into the visible area above the nav bar
      await tester.ensureVisible(addFirstProp);
      await tester.pumpAndSettle();
      await tester.tap(addFirstProp, warnIfMissed: false);
    } else if (tester.any(fabAdd)) {
      await tester.tap(fabAdd.last);
    }
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 7: Property Step 1 — Basic Info ──
    print('>> Step 7: Property Step 1 - Basic Info');
    await waitForText(tester, 'Basic Information');

    await enterByHint(tester, 'e.g. Sunset Heights Apartments', propertyName);
    // Property type defaults to Residential — leave it

    // Scroll to address fields
    final addressField = find.byType(TextFormField).at(1);
    await tester.ensureVisible(addressField);
    await tester.enterText(addressField, '123 Main Street');
    await tester.pumpAndSettle();

    // City
    final cityField = find.byType(TextFormField).at(2);
    await tester.ensureVisible(cityField);
    await tester.enterText(cityField, 'New York');
    await tester.pumpAndSettle();

    // State
    final stateField = find.byType(TextFormField).at(3);
    await tester.ensureVisible(stateField);
    await tester.enterText(stateField, 'NY');
    await tester.pumpAndSettle();

    // Zip
    final zipField = find.byType(TextFormField).at(4);
    await tester.ensureVisible(zipField);
    await tester.enterText(zipField, '10001');
    await tester.pumpAndSettle();

    // Tap "Next: Property Structure"
    await ensureAndTap(tester, find.text('Next: Property Structure'));

    // ── Step 8: Property Step 2 — Structure ──
    print('>> Step 8: Property Step 2 - Structure');
    await waitForText(tester, 'How is it divided?');
    // Units defaults to 1, Floors defaults to 1 — leave them

    // Tap "Review Property"
    await ensureAndTap(tester, find.text('Review Property'));

    // ── Step 9: Property Step 3 — Review & Save ──
    print('>> Step 9: Property Step 3 - Review & Save');
    await waitForText(tester, propertyName);

    await ensureAndTap(tester, find.text('Save & Create Property'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 10: Success Screen ──
    print('>> Step 10: Property Created Successfully!');
    await waitForText(tester, 'Property Created!',
        timeout: const Duration(seconds: 10));

    // Tap "View Property" to go to property detail
    await tester.tap(find.text('View Property'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ── Step 11: Property Detail — Find unit and tap Setup & Invite ──
    print('>> Step 11: Property Detail - Setup & Invite on unit');
    await waitForText(tester, propertyName,
        timeout: const Duration(seconds: 10));

    // The auto-created unit should show "Setup & Invite" button
    final setupInvite = find.text('Setup & Invite');
    final inviteTenant = find.text('Invite Tenant');
    if (tester.any(setupInvite)) {
      await ensureAndTap(tester, setupInvite.first);
    } else if (tester.any(inviteTenant)) {
      await ensureAndTap(tester, inviteTenant.first);
    }
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ── Step 12: Unit Invite Wizard — Unit Details ──
    print('>> Step 12: Unit Invite Wizard');
    await waitForText(tester, 'Setup & Invite',
        timeout: const Duration(seconds: 5));

    // Step 1 might be "Unit Details" if unit needs details
    if (tester.any(find.text('Unit Details'))) {
      print('   >> Filling unit details');
      await enterByHint(tester, 'e.g. Unit 101', 'Unit 101');
      // Unit type defaults to APARTMENT — leave it

      // Tap "Save & Next"
      await tester.tap(find.text('Save & Next'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // Step 2 — Rent & Deposit (if shown)
    if (tester.any(find.text('Monthly Rent'))) {
      print('   >> Setting rent');
      await enterByPrefix(tester, '\$ ', '1500');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Next'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // Step 3 — Invite Tenant
    print('   >> Inviting tenant');
    if (tester.any(find.text('Tenant Full Name (optional)'))) {
      await enterByHint(tester, 'e.g. Sarah Jenkins', 'E2E Tenant');
    }
    await enterByHint(tester, 'tenant@example.com', tenantEmail);

    // Tap "Send Invite"
    await tester.tap(find.text('Send Invite'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // ── Step 13: Invitation sent — get invite code via API ──
    print('>> Step 13: Retrieving invite code via API');
    try {
      final token = await apiLogin(landlordEmail, testPassword);
      final invitations = await apiGetList('/invitations', token: token);
      if (invitations.isNotEmpty) {
        final inviteCode =
            invitations.last['inviteCode']?.toString() ?? '';
        writeSharedValue('invite_code', inviteCode);
        print('   >> Invite code saved: $inviteCode');
      }
    } catch (e) {
      print('   >> Warning: Could not retrieve invite code via API: $e');
      // Try alternate endpoint
      try {
        final token = await apiLogin(landlordEmail, testPassword);
        final invitations =
            await apiGetList('/invitations/landlord', token: token);
        if (invitations.isNotEmpty) {
          final inviteCode =
              invitations.last['inviteCode']?.toString() ?? '';
          writeSharedValue('invite_code', inviteCode);
          print('   >> Invite code saved (alt): $inviteCode');
        }
      } catch (e2) {
        print('   >> Could not get invite code: $e2');
      }
    }

    print('');
    print('========================================');
    print('  LANDLORD E2E FLOW COMPLETE');
    print('  Email: $landlordEmail');
    print('  Tenant invited: $tenantEmail');
    print('  Property: $propertyName');
    print('========================================');
  });
}
