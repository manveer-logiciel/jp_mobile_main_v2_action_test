# Local Build Execution

This document explains how to run the GitHub Actions locally for development and testing.

## 🚀 Quick Start

### Option 1: Local Build Script (Recommended)

Run the build script directly on your machine:

```bash
# Make script executable (first time only)
chmod +x scripts/local-build.sh

# Run with default values
./scripts/local-build.sh

# Run with custom version and build number
./scripts/local-build.sh 3.37.2 303700200 Android

# Run for both platforms
./scripts/local-build.sh 3.37.2 303700200 Both
```

**Parameters:**
- `APP_VERSION` (default: 3.37.2) - App version in x.y.z format
- `BUILD_NUMBER` (default: 303700200) - Numeric build number  
- `BUILD_PLATFORM` (default: Android) - Android, iOS, or Both

### Option 2: Manual Commands

If you prefer to run commands manually:

```bash
# 1. Update version files
sed -i.bak "s/^version: .*/version: 3.37.2+303700200/" pubspec.yaml
sed -i.bak "s/String appVersion = '[^']*';/String appVersion = '3.37.2';/" lib/common/libraries/global.dart

# 2. Get dependencies
flutter pub get

# 3. Build Android App Bundle
flutter build appbundle --release

# 4. Build iOS (macOS only)
cd ios && pod install && cd ..
flutter build ios --release --no-codesign
```

## 🔧 Prerequisites

### For Android Builds:
- Flutter SDK (3.27.2+)
- Java JDK 11 or 17
- Android SDK (API 35)
- 4GB+ RAM available for Gradle

### For iOS Builds:
- macOS
- Xcode
- CocoaPods
- Apple Developer certificates (for signed builds)

## 🐛 Troubleshooting

### OutOfMemoryError
If you encounter Java heap space errors:

1. **Increase system memory allocation:**
   ```bash
   export GRADLE_OPTS="-Xmx4096m"
   export _JAVA_OPTIONS="-Xmx4096m"
   ```

2. **Close other applications** to free up RAM

3. **Use the release build only:**
   ```bash
   flutter build appbundle --release --no-debug --no-profile
   ```

### Flutter Dependencies Issues
```bash
# Clean and reinstall dependencies
flutter clean
flutter pub get
```

### Android Build Issues
```bash
# Clean Gradle cache
cd android
./gradlew clean
cd ..
```

## 📁 Output Locations

After successful builds:

- **Android App Bundle:** `build/app/outputs/bundle/release/app-release.aab`
- **iOS Build:** `build/ios/iphoneos/Runner.app`

## 🔐 Signing Configuration

### Android Signing
The script uses the existing keystore configuration in `android/key.properties`. Make sure you have:
- `android/job_progress.jks` keystore file
- Valid `android/key.properties` with correct credentials

### iOS Signing
iOS builds run without code signing (`--no-codesign`). For production builds:
1. Add Apple Developer certificates to Keychain
2. Update iOS project settings with correct provisioning profiles
3. Remove `--no-codesign` flag

## 📊 Performance Tips

1. **Use Gradle daemon:** Already enabled in `gradle.properties`
2. **Enable parallel builds:** Already configured
3. **Increase heap size:** Set to 4GB in configuration
4. **Close unnecessary applications** during builds
5. **Use SSD storage** for faster I/O

## 🆚 GitHub Actions vs Local

| Feature | GitHub Actions | Local Build |
|---------|---------------|-------------|
| **Environment** | Clean Ubuntu/macOS | Your development machine |
| **Dependencies** | Always fresh | Cached (faster re-runs) |
| **Signing** | Secrets-based | Local keystore |
| **Output** | Artifacts | Local files |
| **Cost** | GitHub minutes | Free |
| **Speed** | Network dependent | Local hardware dependent |

## 🔄 Next Steps

After running local builds:

1. **Test the app bundle:** Install on device or emulator
2. **Verify signing:** Check certificate validity
3. **Upload to stores:** Google Play Console or App Store Connect
4. **Monitor performance:** Check app size and startup time

## 🐳 Docker Support (Coming Soon)

We're working on Docker support for consistent cross-platform builds. This will provide:
- Isolated build environment
- Consistent dependencies
- Linux-based Android builds on any OS
