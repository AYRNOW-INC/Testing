# AYRNOW — Play Store Submission Runbook

Step-by-step guide for submitting the AYRNOW Android app to the Google Play Store.

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| Google Play Developer Account | Enrolled ($25 one-time fee) at [play.google.com/console](https://play.google.com/console) |
| Java 21 (OpenJDK) | Required for keytool and Gradle build |
| Flutter | 3.41+ with Android toolchain configured |
| Android SDK | Installed via Android Studio or Flutter |

---

## 1. Application ID Configuration

**Application ID:** `com.ayrnow.app`

Verify the application ID is set correctly in `frontend/android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.ayrnow.app"
    defaultConfig {
        applicationId = "com.ayrnow.app"
        // ...
    }
}
```

---

## 2. Signing Key Setup

### 2.1 Generate the Upload Keystore

Run this command once and store the keystore file securely:

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias ayrnow-upload \
  -dname "CN=AYRNOW, OU=Mobile, O=AYRNOW Inc, L=Wilmington, ST=Delaware, C=US"
```

- You will be prompted for a keystore password and a key password. Record them securely.
- Move the keystore file to a safe location (do not commit it to version control).
- Recommended location: `frontend/android/upload-keystore.jks` (already in `.gitignore`).

### 2.2 Create key.properties

Copy the example file and fill in real values:

```bash
cp frontend/android/key.properties.example frontend/android/key.properties
```

Edit `frontend/android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=ayrnow-upload
storeFile=../upload-keystore.jks
```

**Important:** `key.properties` must be in `.gitignore`. Never commit this file.

### 2.3 Configure Signing in build.gradle.kts

Verify the following signing configuration exists in `frontend/android/app/build.gradle.kts`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

---

## 3. Build the Release

### 3.1 Build an App Bundle (AAB) — Preferred

Google Play requires AAB format for new apps:

```bash
cd frontend

# Clean and get dependencies
flutter clean
flutter pub get

# Build the release AAB
flutter build appbundle --release
```

The output file will be at:
```
frontend/build/app/outputs/bundle/release/app-release.aab
```

### 3.2 Build an APK — Alternative

For testing or sideloading:

```bash
flutter build apk --release
```

The output file will be at:
```
frontend/build/app/outputs/flutter-apk/app-release.apk
```

### 3.3 Verify the Build

```bash
# Check the AAB was signed correctly
jarsigner -verify -verbose -certs frontend/build/app/outputs/bundle/release/app-release.aab
```

---

## 4. Google Play Console Setup

### 4.1 Create the App

1. Go to [play.google.com/console](https://play.google.com/console).
2. Click **Create app**.
3. Fill in:
   - **App name:** `AYRNOW`
   - **Default language:** English (United States)
   - **App or game:** App
   - **Free or paid:** Free
4. Accept the declarations and click **Create app**.

### 4.2 Store Listing

Navigate to **Grow > Store presence > Main store listing** and fill in:

| Field | Value |
|-------|-------|
| **Short description** (80 chars) | `Simplify rent collection and property management.` |
| **Full description** (4000 chars) | Detailed feature description covering landlord and tenant capabilities. |

#### Required Graphics

| Asset | Dimensions | Notes |
|-------|-----------|-------|
| App icon | 512 x 512 px | PNG, 32-bit, no alpha |
| Feature graphic | 1024 x 500 px | Required for store listing |
| Phone screenshots | Min 2, max 8 | Min 320px, max 3840px on any side. 16:9 or 9:16 aspect ratio. |
| Tablet screenshots | Min 1 (if supporting tablets) | 7" and 10" sizes |

Recommended screenshots:

1. Login / Welcome screen
2. Landlord dashboard
3. Property management
4. Lease creation
5. Rent payment
6. Tenant portal

### 4.3 App Content

Complete all required declarations under **Policy > App content**:

- **Privacy policy:** `https://ayrnow.com/privacy` (required, must be a live URL)
- **Ads:** App does not contain ads.
- **App access:** Provide test credentials for reviewers. Create a landlord demo account with sample data.
- **Content ratings:** Complete the IARC questionnaire.
- **Target audience:** Select appropriate age groups (likely 18+).
- **Data safety:** Declare all data collected and shared:
  - Account info (name, email)
  - Financial info (payment data via Stripe)
  - Property/address data
  - Documents (tenant uploads)

### 4.4 App Signing

Google Play App Signing is mandatory for new apps:

1. Navigate to **Release > Setup > App signing**.
2. Choose **Use Google-generated key** (recommended for new apps).
3. Google will manage the app signing key. Your upload key (the one in `key.properties`) is used only to authenticate uploads.

---

## 5. Upload and Release

### 5.1 Internal Testing Track (Recommended First)

1. Navigate to **Release > Testing > Internal testing**.
2. Click **Create new release**.
3. Upload the `app-release.aab` file.
4. Add release notes.
5. Click **Review release > Start rollout to internal testing**.
6. Add testers by email under the **Testers** tab.

### 5.2 Production Release

After internal testing is verified:

1. Navigate to **Release > Production**.
2. Click **Create new release**.
3. Upload the `app-release.aab` file (or promote from internal testing).
4. Add release notes under **What's new in this release**.
5. Set the rollout percentage (100% for full launch, or staged rollout).
6. Click **Review release > Start rollout to production**.

---

## 6. Pre-Submission Checklist

- [ ] App launches without crash on a clean install.
- [ ] Login flow works with the demo account.
- [ ] All navigation paths are functional.
- [ ] Privacy policy URL is live and accessible.
- [ ] No placeholder text or debug content visible in the UI.
- [ ] No references to "test", "debug", or "TODO" visible in the UI.
- [ ] `key.properties` is NOT committed to version control.
- [ ] Upload keystore is backed up securely outside the repository.
- [ ] `applicationId` is `com.ayrnow.app`.
- [ ] Version code is incremented from any previous upload.
- [ ] ProGuard / R8 minification does not break runtime behavior.
- [ ] Stripe payment flow works in release mode.
- [ ] App icon displays correctly at all sizes.
- [ ] No hardcoded API keys or secrets in the client bundle.
- [ ] `storeFile` path in `key.properties` resolves correctly relative to `app/build.gradle.kts`.

---

## 7. Post-Submission Monitoring

### Review Timeline

- Google Play review typically takes a few hours to several days for new apps.
- Check status at [play.google.com/console](https://play.google.com/console).

### Common Rejection Reasons and Fixes

| Reason | Fix |
|--------|-----|
| Missing privacy policy | Ensure the URL is live and returns a valid page. |
| Incomplete data safety declaration | Accurately declare all data collected via Stripe, document uploads, and user accounts. |
| Crash on specific devices | Test on multiple screen sizes and API levels. |
| Login wall without guest access | Provide demo credentials in the app access section. |
| Deceptive behavior warning | Ensure the app description accurately reflects functionality. |

### After Approval

1. Monitor the **Android vitals** dashboard for crash rates and ANR rates.
2. Monitor user reviews and respond promptly.
3. Track install counts and uninstall rates.
4. Set up pre-launch reports for future releases (automatic device testing by Google).

---

## 8. Ongoing Releases

For subsequent versions:

1. Increment `version` in `pubspec.yaml` (e.g., `1.0.1+2`).
   - The part before `+` is the version name.
   - The part after `+` is the version code (must always increase).
2. Rebuild: `flutter build appbundle --release`.
3. Upload the new AAB to the appropriate track.
4. Add "What's new" release notes.
5. Roll out.

---

## 9. key.properties Alignment

The `storeFile` path in `key.properties` is resolved relative to the `app/` directory inside the Android project. Ensure the path matches the actual keystore location:

- If keystore is at `frontend/android/upload-keystore.jks`, then `storeFile=../upload-keystore.jks`.
- If keystore is at `frontend/android/app/upload-keystore.jks`, then `storeFile=upload-keystore.jks`.

Verify with:

```bash
ls -la $(cd frontend/android/app && echo "$(cat ../key.properties | grep storeFile | cut -d= -f2)")
```

---

## Related Docs

- [SETUP_MAC.md](./SETUP_MAC.md) — Development environment setup
- [PRODUCTION_RUNBOOK.md](./PRODUCTION_RUNBOOK.md) — Backend deployment
- [APP_STORE_SUBMISSION.md](./APP_STORE_SUBMISSION.md) — iOS submission
- [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) — Required configuration
