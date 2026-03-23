/// Centralized test data constants for all AYRNOW E2E tests.
///
/// Usage: import 'test_data.dart';

// -- Test Accounts (pre-existing in DB) --
const existingLandlordEmail = 'landlord@ayrnow.app';
const existingTenantEmail = 'tenant@ayrnow.app';
const existingPassword = 'Demo1234A';

// -- New Account Defaults --
const testPassword = 'Test1234A';
const testFirstName = 'E2E';
const testLandlordLastName = 'Landlord';
const testTenantLastName = 'Tenant';

// -- Property Defaults --
const testPropertyName = 'E2E Sunset Heights';
const testPropertyAddress = '123 Main Street';
const testPropertyCity = 'New York';
const testPropertyState = 'NY';
const testPropertyZip = '10001';
const testPropertyType = 'RESIDENTIAL';

// -- Unit Defaults --
const testUnitName = 'Unit 101';
const testUnitType = 'APARTMENT';
const testMonthlyRent = '1500';
const testSecurityDeposit = '1500';

// -- Lease Defaults --
const testLeaseTermMonths = '12';
const testPaymentDueDay = '1';
const testGracePeriodDays = '5';
const testLateFeeAmount = '50';

// -- API Base --
const apiBase = 'http://localhost:8080/api';

// -- Simulator IDs --
const sim1Id = 'DF7E7361-5CF5-407B-AC46-7F8896AC115C'; // iPhone 17 Pro
const sim2Id = '2620A3BC-3BE4-458B-9914-5DCCF40DD747'; // iPhone 16e

/// Generate a unique email with timestamp to avoid collisions.
String uniqueEmail(String prefix) {
  final ts = DateTime.now().millisecondsSinceEpoch;
  return '${prefix}_$ts@test.ayrnow.app';
}
