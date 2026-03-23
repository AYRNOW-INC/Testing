import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Shared E2E test helpers for AYRNOW integration tests.
// Test data constants are in test_data.dart — import that for uniqueEmail, testPassword, etc.

/// Find a TextField/TextFormField by its hint text.
Finder byHint(String hint) => find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == hint,
    );

/// Find a TextField/TextFormField by its prefix text.
Finder byPrefix(String prefix) => find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.prefixText == prefix,
    );

/// Scroll down in the first SingleChildScrollView and pump.
Future<void> scrollDown(WidgetTester tester, {double dy = -300}) async {
  final scrollable = find.byType(Scrollable).first;
  await tester.scrollUntilVisible(
    find.byType(ElevatedButton).last,
    dy,
    scrollable: scrollable,
  );
}

/// Scroll a specific widget into view within a Scrollable.
Future<void> scrollToWidget(WidgetTester tester, Finder target,
    {double delta = -200}) async {
  final scrollable = find.byType(Scrollable).first;
  await tester.scrollUntilVisible(target, delta, scrollable: scrollable);
}

/// Tap a widget found by text, scrolling into view first.
Future<void> tapText(WidgetTester tester, String text,
    {bool scroll = false}) async {
  final finder = find.text(text);
  if (scroll) {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

/// Ensure visible, then tap. Most reliable pattern for buttons in scrollable views.
Future<void> ensureAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

/// Enter text in a field found by hint text.
Future<void> enterByHint(
    WidgetTester tester, String hint, String text) async {
  final finder = byHint(hint);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Enter text in a field found by prefix text (e.g., "$ ").
Future<void> enterByPrefix(
    WidgetTester tester, String prefix, String text) async {
  final finder = byPrefix(prefix);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Wait for a widget to appear with a timeout.
Future<void> waitFor(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 15)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 500));
    if (tester.any(finder)) return;
  }
  // Final check — will throw if not found
  expect(finder, findsWidgets);
}

/// Wait for any text to appear on screen.
Future<void> waitForText(WidgetTester tester, String text,
    {Duration timeout = const Duration(seconds: 15)}) async {
  await waitFor(tester, find.text(text), timeout: timeout);
}

/// Tap a NavigationDestination by its label.
Future<void> tapNavTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

/// Call the backend API (from test code running on simulator).
Future<Map<String, dynamic>> apiGet(String path,
    {String? token}) async {
  final client = HttpClient();
  final request =
      await client.getUrl(Uri.parse('http://localhost:8080/api$path'));
  request.headers.set('Content-Type', 'application/json');
  if (token != null) {
    request.headers.set('Authorization', 'Bearer $token');
  }
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();
  return json.decode(body) as Map<String, dynamic>;
}

Future<List<dynamic>> apiGetList(String path, {String? token}) async {
  final client = HttpClient();
  final request =
      await client.getUrl(Uri.parse('http://localhost:8080/api$path'));
  request.headers.set('Content-Type', 'application/json');
  if (token != null) {
    request.headers.set('Authorization', 'Bearer $token');
  }
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();
  return json.decode(body) as List<dynamic>;
}

Future<Map<String, dynamic>> apiPost(String path, Map<String, dynamic> data,
    {String? token}) async {
  final client = HttpClient();
  final request =
      await client.postUrl(Uri.parse('http://localhost:8080/api$path'));
  request.headers.set('Content-Type', 'application/json');
  if (token != null) {
    request.headers.set('Authorization', 'Bearer $token');
  }
  request.write(json.encode(data));
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();
  if (body.isEmpty) return {};
  return json.decode(body) as Map<String, dynamic>;
}

/// Login via API and return the access token.
Future<String> apiLogin(String email, String password) async {
  final res = await apiPost('/auth/login', {
    'email': email,
    'password': password,
  });
  return res['accessToken'] as String;
}

/// Write a value to a shared temp file for cross-simulator coordination.
void writeSharedValue(String key, String value) {
  File('/tmp/ayrnow_e2e_$key.txt').writeAsStringSync(value);
}

/// Read a value from a shared temp file.
String readSharedValue(String key) {
  return File('/tmp/ayrnow_e2e_$key.txt').readAsStringSync().trim();
}
