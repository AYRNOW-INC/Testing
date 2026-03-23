# AYRNOW — App Store Submission Runbook

Step-by-step guide for submitting the AYRNOW iOS app to the Apple App Store.

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| Apple Developer Account | Enrolled in the Apple Developer Program ($99/year) |
| Xcode | Latest stable version installed from Mac App Store |
| Xcode CLI Tools | `xcode-select --install` |
| CocoaPods | `gem install cocoapods` (or bundled with Flutter) |
| Flutter | 3.41+ with iOS toolchain configured |
| Physical device (optional) | Recommended for final smoke test before submission |

---

## 1. Bundle ID Configuration

**Bundle ID:** `com.ayrnow.app`

Verify the bundle ID is set correctly in the Xcode project:

1. Open `frontend/ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target.
3. Under **General > Identity**, confirm:
   - **Bundle Identifier:** `com.ayrnow.app`
   - **Display Name:** `AYRNOW`
   - **Version:** Set to the release version (e.g., `1.0.0`).
   - **Build:** Increment for each upload (e.g., `1`, `2`, `3`).

---

## 2. Apple Developer Portal Setup

### 2.1 Register the App ID

1. Go to [developer.apple.com/account](https://developer.apple.com/account).
2. Navigate to **Certificates, Identifiers & Profiles > Identifiers**.
3. Click **+** to register a new identifier.
4. Select **App IDs > App**.
5. Enter:
   - **Description:** `AYRNOW`
   - **Bundle ID:** Explicit — `com.ayrnow.app`
6. Enable required capabilities:
   - **Associated Domains** (if using universal links for Authgear callbacks)
   - **Push Notifications** (if sending push notifications)
7. Click **Continue > Register**.

### 2.2 Create a Distribution Certificate

1. Navigate to **Certificates, Identifiers & Profiles > Certificates**.
2. Click **+** and select **Apple Distribution**.
3. Follow the CSR (Certificate Signing Request) instructions:
   - Open **Keychain Access** on your Mac.
   - Go to **Keychain Access > Certificate Assistant > Request a Certificate From a Certificate Authority**.
   - Enter your email, select **Saved to disk**, and generate the CSR.
4. Upload the CSR file and download the certificate.
5. Double-click the downloaded `.cer` file to install it in Keychain Access.

### 2.3 Create a Provisioning Profile

1. Navigate to **Certificates, Identifiers & Profiles > Profiles**.
2. Click **+** and select **App Store Connect**.
3. Select the App ID: `com.ayrnow.app`.
4. Select the distribution certificate created above.
5. Name the profile: `AYRNOW App Store Distribution`.
6. Download and double-click to install.

---

## 3. Xcode Project Configuration

### 3.1 Signing Settings

1. Open `frontend/ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target > **Signing & Capabilities**.
3. Uncheck **Automatically manage signing** for Release builds.
4. Set:
   - **Team:** Your Apple Developer team.
   - **Provisioning Profile:** `AYRNOW App Store Distribution` (the profile created above).
   - **Signing Certificate:** Apple Distribution.

### 3.2 Info.plist — Authgear URL Schemes

Authgear requires a URL scheme for OAuth callback handling. Verify the following is present in `frontend/ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.ayrnow.app</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.ayrnow.app</string>
        </array>
    </dict>
</array>
```

If using Authgear with universal links, also add under the **Associated Domains** capability:

```
applinks:your-authgear-project.authgear.com
```

### 3.3 Info.plist — Required Privacy Descriptions

Apple requires usage description strings for any accessed hardware/data. Verify these exist as needed:

| Key | When Required | Example Value |
|-----|--------------|---------------|
| `NSCameraUsageDescription` | Document photo capture | `AYRNOW needs camera access to photograph documents.` |
| `NSPhotoLibraryUsageDescription` | Selecting photos for upload | `AYRNOW needs photo library access to upload documents.` |
| `NSFaceIDUsageDescription` | Biometric login (future) | `AYRNOW uses Face ID for secure login.` |

### 3.4 Build Settings

Confirm the following in Xcode build settings for the **Release** configuration:

- **iOS Deployment Target:** 15.0 or higher (match `Podfile` minimum).
- **Swift Language Version:** Matches CocoaPods dependencies.
- **Bitcode:** Disabled (Flutter does not support bitcode).

---

## 4. App Store Connect Listing

### 4.1 Create the App

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com).
2. Click **My Apps > +** > **New App**.
3. Fill in:
   - **Platform:** iOS
   - **Name:** `AYRNOW`
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** `com.ayrnow.app`
   - **SKU:** `ayrnow-ios-mvp`
4. Click **Create**.

### 4.2 App Information

Fill out each section:

| Field | Value |
|-------|-------|
| **Subtitle** | `Rent Collection & Property Management` |
| **Category** | Business or Finance |
| **Content Rights** | Does not contain third-party content |
| **Age Rating** | Complete the questionnaire (likely 4+) |

### 4.3 Prepare Screenshots

Required screenshot sizes:

| Device | Resolution |
|--------|-----------|
| iPhone 6.9" (iPhone 16 Pro Max) | 1320 x 2868 |
| iPhone 6.7" (iPhone 14 Pro Max) | 1290 x 2796 |
| iPhone 6.5" (iPhone 11 Pro Max) | 1284 x 2778 |
| iPhone 5.5" (iPhone 8 Plus) | 1242 x 2208 |
| iPad Pro 12.9" (if supporting iPad) | 2048 x 2732 |

Recommended screenshots (minimum 3, maximum 10 per size):

1. Login / Welcome screen
2. Landlord dashboard
3. Property list / management
4. Lease creation or signing
5. Rent payment screen
6. Tenant dashboard

### 4.4 App Description

Prepare the following text fields:

- **Promotional Text** (170 chars max): Short marketing tagline.
- **Description** (4000 chars max): Full feature description.
- **Keywords** (100 chars max): Comma-separated. Example: `rent,landlord,tenant,property,lease,payment,management`
- **Support URL:** `https://ayrnow.com/support`
- **Marketing URL:** `https://ayrnow.com`
- **Privacy Policy URL:** `https://ayrnow.com/privacy` (required)

### 4.5 App Review Information

- **Contact:** Provide name, phone, and email for the review team.
- **Demo Account:** Create a test landlord account with sample data so Apple reviewers can test the app.
- **Notes for Reviewer:** Explain key flows (login, view properties, view lease, make payment).

---

## 5. Build and Upload

### 5.1 Build the Release Archive

```bash
cd frontend

# Clean previous builds
flutter clean
flutter pub get

# Install iOS pods
cd ios && pod install && cd ..

# Build the iOS release
flutter build ios --release
```

### 5.2 Archive in Xcode

1. Open `frontend/ios/Runner.xcworkspace` in Xcode.
2. Select **Product > Destination > Any iOS Device (arm64)**.
3. Select **Product > Archive**.
4. Wait for the archive to complete.

### 5.3 Upload to App Store Connect

1. In the **Organizer** window (Xcode > Window > Organizer), select the new archive.
2. Click **Distribute App**.
3. Select **App Store Connect > Upload**.
4. Follow prompts:
   - Select the distribution certificate and provisioning profile.
   - Enable **Upload your app's symbols** for crash reporting.
   - Disable **Manage Version and Build Number** if you set them manually.
5. Click **Upload**.

### 5.4 Alternative: Upload via CLI

```bash
# Using xcrun altool (deprecated but still functional)
xcrun altool --upload-app -f Runner.ipa -t ios -u "your@email.com" -p "app-specific-password"

# Using xcrun notarytool / Transporter app is also an option
```

---

## 6. Submit for Review

1. In App Store Connect, go to the app listing.
2. Under the new version, select the uploaded build.
3. Complete all required metadata (screenshots, description, privacy policy).
4. Answer the **Export Compliance** question:
   - AYRNOW uses HTTPS (standard encryption) — select **Yes, it uses encryption** and **Yes, it qualifies for an exemption** (standard HTTPS).
5. Click **Submit for Review**.

---

## 7. App Review Checklist

Before submitting, verify all of these:

- [ ] App launches without crash on a clean install.
- [ ] Login flow works with the demo account.
- [ ] All navigation paths are functional (no dead-end screens).
- [ ] Privacy policy URL is live and accessible.
- [ ] No placeholder text or "lorem ipsum" content.
- [ ] No references to "test", "debug", or "TODO" visible in the UI.
- [ ] App does not request permissions it does not use.
- [ ] All Info.plist privacy descriptions are present for used features.
- [ ] Authgear URL scheme callback is properly configured.
- [ ] Stripe payment flow does not violate Apple's in-app purchase rules (physical goods/services are exempt).
- [ ] No hardcoded API keys or secrets in the client bundle.
- [ ] App icon is set (1024x1024 for App Store, plus all required sizes in `Assets.xcassets`).
- [ ] LaunchScreen / splash screen displays correctly.

---

## 8. Post-Submission Monitoring

### Review Timeline

- Typical review time: 24-48 hours.
- Check status at [appstoreconnect.apple.com](https://appstoreconnect.apple.com).

### Common Rejection Reasons and Fixes

| Reason | Fix |
|--------|-----|
| Crash on launch | Test on a physical device before submission. |
| Missing privacy policy | Ensure the URL is live and returns a valid page. |
| Incomplete metadata | Fill in all required fields and screenshots. |
| Login required but no demo account | Provide demo credentials in review notes. |
| Guideline 4.3 — Spam | Ensure the app provides distinct value and is not a template clone. |
| Guideline 5.1.1 — Data collection | Disclose all data collection in the privacy section. |

### After Approval

1. The app will be set to **Pending Developer Release** or **Ready for Sale** based on your release settings.
2. If set to manual release, go to App Store Connect and click **Release This Version**.
3. Monitor crash reports via Xcode Organizer or App Store Connect > Analytics.
4. Monitor user reviews and respond promptly.

---

## 9. Ongoing Releases

For subsequent versions:

1. Increment the version number in `pubspec.yaml` and Xcode.
2. Increment the build number.
3. Repeat the build, archive, and upload steps.
4. Add "What's New" text for the update.
5. Submit for review.

---

## Related Docs

- [SETUP_MAC.md](./SETUP_MAC.md) — Development environment setup
- [PRODUCTION_RUNBOOK.md](./PRODUCTION_RUNBOOK.md) — Backend deployment
- [PLAY_STORE_SUBMISSION.md](./PLAY_STORE_SUBMISSION.md) — Android submission
- [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) — Required configuration
