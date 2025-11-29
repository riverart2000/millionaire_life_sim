# 🚀 Build & Deploy Guide

## 🤖 Automated Builds (GitHub Actions)

The easiest way to build for all platforms is using GitHub Actions:

### 📱 Install on Android Phone

**Easy 3-Step Installation:**

1. **Download on your phone:**
   - Open browser on your Android phone
   - Go to: https://github.com/riverart2000/millionaire_life_sim/releases
   - Tap on `app-release.apk` to download

2. **Enable installation:**
   - Go to Settings → Security (or Privacy)
   - Enable "Install Unknown Apps" for your browser
   - Or tap the notification and allow installation

3. **Install & Play:**
   - Tap the downloaded APK file
   - Tap "Install"
   - Open and enjoy! 🎮

**Note:** The app is 100% offline - no internet needed after installation!

---

### Create a Release

1. **Tag your version:**
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. **GitHub Actions will automatically:**
   - Build for Android, macOS, Windows, and Web
   - Create a GitHub Release with downloadable files
   - Deploy web version to GitHub Pages

3. **Download builds from:**
   - Go to: https://github.com/riverart2000/millionaire_life_sim/releases
   - Latest release will have all platform builds attached

### Manual Trigger

You can also trigger builds manually:
1. Go to: https://github.com/riverart2000/millionaire_life_sim/actions
2. Select "Build & Release" workflow
3. Click "Run workflow"

### Play Online

Web version automatically deploys to:
- https://riverart2000.github.io/millionaire_life_sim/

---

## Quick Start - Development Mode

```bash
# Run on web (Chrome)
flutter run -d chrome

# Run on desktop (macOS)
flutter run -d macos

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

## 📦 Production Builds

### Web Build (Recommended - Works Everywhere)

```bash
# Build optimized web version
flutter build web --release

# Output location:
# build/web/

# Deploy to any web host:
# - Firebase Hosting
# - Netlify
# - Vercel
# - GitHub Pages
# - Your own server
```

**Deploy to Firebase Hosting:**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

**Test locally:**
```bash
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000
```

### Desktop Builds

#### macOS
```bash
# Build macOS app
flutter build macos --release

# Output location:
# build/macos/Build/Products/Release/millionaire_life_simulator.app

# Create DMG (optional)
# Use create-dmg tool or manual disk utility
```

#### Windows
```bash
# Build Windows app
flutter build windows --release

# Output location:
# build/windows/x64/runner/Release/
```

#### Linux
```bash
# Build Linux app
flutter build linux --release

# Output location:
# build/linux/x64/release/bundle/
```

### Mobile Builds

#### iOS
```bash
# Open Xcode first to configure signing
open ios/Runner.xcworkspace

# Build IPA
flutter build ios --release

# Or build directly to device
flutter build ios --release --no-codesign
```

#### Android
```bash
# Build APK (for direct installation)
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output locations:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

## 🔧 Build Optimizations

### Size Optimizations

```bash
# Analyze bundle size
flutter build web --release --analyze-size

# Split debug info (smaller app)
flutter build apk --release --split-debug-info=build/app/outputs/symbols

# Obfuscate code
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

## 🌐 Web Deployment Options

### 1. Firebase Hosting (Free)
```bash
firebase init hosting
firebase deploy
```

### 2. GitHub Pages (Free)
```bash
# Build
flutter build web --release --base-href "/millionaire_life_sim/"

# Copy to docs/ or gh-pages branch
cp -r build/web/* docs/

# Push to GitHub
git add docs/
git commit -m "Deploy to GitHub Pages"
git push
```

### 3. Netlify (Free)
- Drag & drop `build/web` folder to netlify.com
- Or connect GitHub repo for auto-deployment

### 4. Vercel (Free)
```bash
npm i -g vercel
cd build/web
vercel
```

## 📱 App Store Deployment

### iOS App Store
1. Configure signing in Xcode
2. Update version in `pubspec.yaml`
3. Build: `flutter build ios --release`
4. Open Xcode: `open ios/Runner.xcworkspace`
5. Archive and upload via Xcode
6. Submit for review in App Store Connect

### Google Play Store
1. Generate signing key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configure signing in `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

3. Build and upload:
```bash
flutter build appbundle --release
# Upload build/app/outputs/bundle/release/app-release.aab to Play Console
```

## 🎨 Branding Customization

Before building, update branding:

### App Name
- Update `name` in `pubspec.yaml`
- iOS: Update `CFBundleDisplayName` in `ios/Runner/Info.plist`
- Android: Update `android:label` in `android/app/src/main/AndroidManifest.xml`

### App Icon
```bash
# Install flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# Add configuration to pubspec.yaml
flutter pub run flutter_launcher_icons
```

### Splash Screen
```bash
# Install flutter_native_splash
flutter pub add dev:flutter_native_splash

# Configure and generate
flutter pub run flutter_native_splash:create
```

## 🔐 Environment Configuration

### Production Firebase Setup
1. Create Firebase project
2. Run: `flutterfire configure`
3. Replace values in `lib/firebase_options.dart`
4. Enable Firestore and Authentication

### Environment Variables
Create `.env` files for different environments:
```
# .env.production
FIREBASE_API_KEY=your_key
FIREBASE_PROJECT_ID=your_project
```

## 📊 Performance Tips

1. **Enable Code Splitting (Web)**
   - Reduces initial load time
   - Lazy loads features

2. **Use Web Workers**
   - Offload heavy computations
   - Better responsiveness

3. **Optimize Images**
   - Use WebP format
   - Compress assets

4. **Enable Caching**
   - Add service worker
   - Cache static assets

5. **Profile Performance**
```bash
flutter run --profile
# Open DevTools to analyze
```

## 🧪 Testing Before Deploy

```bash
# Run all tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade
```

## 📋 Pre-Release Checklist

- [ ] All tests passing
- [ ] No linter warnings
- [ ] Firebase configured (if using)
- [ ] App icon updated
- [ ] Splash screen configured
- [ ] Version number updated
- [ ] Release notes written
- [ ] Privacy policy created (if required)
- [ ] Terms of service created (if required)
- [ ] Test on multiple devices
- [ ] Performance profiled
- [ ] Security audit done

## 🎉 Ready to Deploy!

Choose your platform and follow the instructions above. Your Millionaire Life Simulator is ready to share with the world!

---

**Need Help?**
- Flutter Docs: https://docs.flutter.dev/deployment
- Firebase: https://firebase.google.com/docs
- Community: https://stackoverflow.com/questions/tagged/flutter
