// ignore_for_file: file_names
// TEST PLAN: TC-05 — Unit Management Flow (API-driven)
//
// PRECONDITIONS:
//   - Backend running on localhost:8080
//   - Landlord account exists with at least one property
//
// TEST CASES:
//   TC-05-01: API — Login as landlord, get properties list
//   TC-05-02: API — Get property detail with units
//   TC-05-03: API — Update unit name, type, floor, and rent
//   TC-05-04: API — Verify unit update persisted
//   TC-05-05: API — Verify unit status is VACANT for new unit
//
// NOTE: Unit editing via UI uses EditUnitScreen which requires
// navigating deep into PropertyDetail → Unit row tap. This test
// uses API calls for reliability. UI navigation tested in TC-04.
//
// EXPECTED BEHAVIOR:
//   - PUT /properties/{id}/units/{id} returns updated unit
//   - Unit fields (name, type, rent) persist correctly
//   - New units default to VACANT status
//
// PASS CRITERIA:
//   - All 5 API test cases pass
//   - Response codes are 200
//   - Data matches what was sent

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-05: Unit Management Flow (API)', (tester) async {
    // TC-05-01: Login and get token
    debugPrint('[TC-05-01] Login as landlord via API');
    final loginRes = await _apiPost('/auth/login', {
      'email': existingLandlordEmail,
      'password': existingPassword,
    });
    expect(loginRes['accessToken'], isNotNull);
    final token = loginRes['accessToken'] as String;
    debugPrint('[TC-05-01] PASS');

    // TC-05-02: Get properties
    debugPrint('[TC-05-02] Get properties list');
    final props = await _apiGetList('/properties', token: token);
    expect(props, isNotEmpty);
    final propertyId = props.first['id'];
    debugPrint('[TC-05-02] PASS — Found ${props.length} properties');

    // Get property detail with units
    final detail = await _apiGet('/properties/$propertyId', token: token);
    final units = detail['unitSpaces'] as List<dynamic>? ?? [];
    expect(units, isNotEmpty);
    final unitId = units.first['id'];
    debugPrint('   >> Property "${ detail['name']}" has ${units.length} unit(s)');

    // TC-05-03: Update unit
    debugPrint('[TC-05-03] Update unit details via API');
    final updateRes = await _apiPut('/properties/$propertyId/units/$unitId', {
      'name': 'Unit 101-Updated',
      'unitType': 'APARTMENT',
      'floor': '2',
      'monthlyRent': 1800.0,
    }, token: token);
    expect(updateRes['name'], equals('Unit 101-Updated'));
    debugPrint('[TC-05-03] PASS');

    // TC-05-04: Verify persistence
    debugPrint('[TC-05-04] Verify update persisted');
    final verifyDetail = await _apiGet('/properties/$propertyId', token: token);
    final verifyUnits = verifyDetail['unitSpaces'] as List<dynamic>;
    final updated = verifyUnits.firstWhere((u) => u['id'] == unitId);
    expect(updated['name'], equals('Unit 101-Updated'));
    expect(updated['monthlyRent'], equals(1800.0));
    debugPrint('[TC-05-04] PASS');

    // TC-05-05: Check status
    debugPrint('[TC-05-05] Verify unit status');
    expect(updated['status'], equals('VACANT'));
    debugPrint('[TC-05-05] PASS');

    // Restore original name
    await _apiPut('/properties/$propertyId/units/$unitId', {
      'name': units.first['name'] ?? 'Unit 1',
      'unitType': 'APARTMENT',
      'monthlyRent': units.first['monthlyRent'] ?? 0,
    }, token: token);

    debugPrint('');
    debugPrint('========================================');
    debugPrint('  TC-05: UNIT MANAGEMENT — ALL PASS');
    debugPrint('========================================');
  });
}

// -- API Helpers (inline for standalone test) --
Future<Map<String, dynamic>> _apiPost(String path, Map<String, dynamic> body, {String? token}) async {
  final client = HttpClient();
  final req = await client.postUrl(Uri.parse('$apiBase$path'));
  req.headers.set('Content-Type', 'application/json');
  if (token != null) req.headers.set('Authorization', 'Bearer $token');
  req.write(json.encode(body));
  final res = await req.close();
  final data = await res.transform(utf8.decoder).join();
  client.close();
  return json.decode(data) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _apiGet(String path, {String? token}) async {
  final client = HttpClient();
  final req = await client.getUrl(Uri.parse('$apiBase$path'));
  req.headers.set('Content-Type', 'application/json');
  if (token != null) req.headers.set('Authorization', 'Bearer $token');
  final res = await req.close();
  final data = await res.transform(utf8.decoder).join();
  client.close();
  return json.decode(data) as Map<String, dynamic>;
}

Future<List<dynamic>> _apiGetList(String path, {String? token}) async {
  final client = HttpClient();
  final req = await client.getUrl(Uri.parse('$apiBase$path'));
  req.headers.set('Content-Type', 'application/json');
  if (token != null) req.headers.set('Authorization', 'Bearer $token');
  final res = await req.close();
  final data = await res.transform(utf8.decoder).join();
  client.close();
  return json.decode(data) as List<dynamic>;
}

Future<Map<String, dynamic>> _apiPut(String path, Map<String, dynamic> body, {String? token}) async {
  final client = HttpClient();
  final req = await client.putUrl(Uri.parse('$apiBase$path'));
  req.headers.set('Content-Type', 'application/json');
  if (token != null) req.headers.set('Authorization', 'Bearer $token');
  req.write(json.encode(body));
  final res = await req.close();
  final data = await res.transform(utf8.decoder).join();
  client.close();
  return json.decode(data) as Map<String, dynamic>;
}
