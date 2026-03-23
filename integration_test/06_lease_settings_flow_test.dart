/// TEST PLAN: TC-06 — Lease Settings Flow (API-driven)
///
/// PRECONDITIONS:
///   - Backend running on localhost:8080
///   - Landlord account with at least one property
///
/// TEST CASES:
///   TC-06-01: API — Get current lease settings for property
///   TC-06-02: API — Update lease term, rent, deposit, due day
///   TC-06-03: API — Verify updated settings persisted
///   TC-06-04: API — Verify grace period and late fee saved
///
/// EXPECTED BEHAVIOR:
///   - GET /properties/{id}/lease-settings returns defaults
///   - PUT /properties/{id}/lease-settings saves new values
///   - Settings apply to new leases created under this property
///
/// PASS CRITERIA:
///   - All 4 test cases pass
///   - Values round-trip correctly through API

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-06: Lease Settings Flow (API)', (tester) async {
    // Login
    final loginRes = await _post('/auth/login', {
      'email': existingLandlordEmail, 'password': existingPassword,
    });
    final token = loginRes['accessToken'] as String;
    final props = await _getList('/properties', token: token);
    expect(props, isNotEmpty);
    final pid = props.first['id'];

    // TC-06-01: Get current settings
    print('[TC-06-01] Get lease settings');
    final settings = await _get('/properties/$pid/lease-settings', token: token);
    expect(settings, isNotNull);
    print('[TC-06-01] PASS — Term: ${settings['defaultLeaseTermMonths']} months');

    // TC-06-02: Update settings
    print('[TC-06-02] Update lease settings');
    final updated = await _put('/properties/$pid/lease-settings', {
      'defaultLeaseTermMonths': 12,
      'defaultMonthlyRent': 1500.0,
      'defaultSecurityDeposit': 1500.0,
      'paymentDueDay': 1,
      'gracePeriodDays': 5,
      'lateFeeAmount': 50.0,
    }, token: token);
    expect(updated, isNotNull);
    print('[TC-06-02] PASS');

    // TC-06-03: Verify persistence
    print('[TC-06-03] Verify settings persisted');
    final verify = await _get('/properties/$pid/lease-settings', token: token);
    expect(verify['defaultLeaseTermMonths'], equals(12));
    expect(verify['defaultMonthlyRent'], equals(1500.0));
    expect(verify['defaultSecurityDeposit'], equals(1500.0));
    expect(verify['paymentDueDay'], equals(1));
    print('[TC-06-03] PASS');

    // TC-06-04: Verify grace period and late fee
    print('[TC-06-04] Verify grace period and late fee');
    expect(verify['gracePeriodDays'], equals(5));
    expect(verify['lateFeeAmount'], equals(50.0));
    print('[TC-06-04] PASS');

    print('');
    print('========================================');
    print('  TC-06: LEASE SETTINGS — ALL PASS');
    print('========================================');
  });
}

Future<Map<String, dynamic>> _post(String p, Map<String, dynamic> b, {String? token}) async {
  final c = HttpClient(); final r = await c.postUrl(Uri.parse('$apiBase$p'));
  r.headers.set('Content-Type', 'application/json');
  if (token != null) r.headers.set('Authorization', 'Bearer $token');
  r.write(json.encode(b)); final res = await r.close();
  final d = await res.transform(utf8.decoder).join(); c.close();
  return json.decode(d) as Map<String, dynamic>;
}
Future<Map<String, dynamic>> _get(String p, {String? token}) async {
  final c = HttpClient(); final r = await c.getUrl(Uri.parse('$apiBase$p'));
  r.headers.set('Content-Type', 'application/json');
  if (token != null) r.headers.set('Authorization', 'Bearer $token');
  final res = await r.close(); final d = await res.transform(utf8.decoder).join(); c.close();
  return json.decode(d) as Map<String, dynamic>;
}
Future<List<dynamic>> _getList(String p, {String? token}) async {
  final c = HttpClient(); final r = await c.getUrl(Uri.parse('$apiBase$p'));
  r.headers.set('Content-Type', 'application/json');
  if (token != null) r.headers.set('Authorization', 'Bearer $token');
  final res = await r.close(); final d = await res.transform(utf8.decoder).join(); c.close();
  return json.decode(d) as List<dynamic>;
}
Future<Map<String, dynamic>> _put(String p, Map<String, dynamic> b, {String? token}) async {
  final c = HttpClient(); final r = await c.putUrl(Uri.parse('$apiBase$p'));
  r.headers.set('Content-Type', 'application/json');
  if (token != null) r.headers.set('Authorization', 'Bearer $token');
  r.write(json.encode(b)); final res = await r.close();
  final d = await res.transform(utf8.decoder).join(); c.close();
  return json.decode(d) as Map<String, dynamic>;
}
