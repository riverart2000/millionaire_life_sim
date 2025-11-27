# Millionaire Life Simulator 💰

A modular wealth simulation app built on the T. Harv Eker 6-Jar Money System, featuring offline-first architecture with Firebase sync and a polished template UI.

## ✨ Features

### Core Functionality
- **6-Jar Money Management** - Split income across NEC, FFA, LTSS, EDU, PLAY, GIVE jars
- **Daily Income Simulation** - Simulate earning and automatic jar distribution
- **Marketplace** - Buy and sell items (local + networked via Firebase)
- **Transaction History** - Complete ledger of all financial activities
- **Offline-First** - Full functionality without internet, syncs when online

### UI Components (from Template)
- **Professional Header** - Navigation menu, user info, sound toggle, logout
- **Motivational Quotes** - Rotating inspirational messages
- **Celebration Effects** - Confetti and sounds for milestones
- **Modern Material 3** - Clean, responsive design
- **Footer** - Professional app footer with links

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd /Users/riverart/flutter/millionaire_life_sim
flutter pub get
```

### 2. Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
# Web (Chrome)
flutter run -d chrome

# Desktop (macOS)
flutter run -d macos

# iOS Simulator
flutter run -d ios

# Android
flutter run -d android
```

### 4. Configure Firebase (Optional)
```bash
flutterfire configure
```
*Note: App works fully offline without Firebase. Firebase enables networked marketplace.*

## 🏗️ Architecture

### Tech Stack
- **UI Framework**: Flutter 3.x with Material 3
- **State Management**: 
  - Riverpod 3.x (core business logic)
  - Provider 6.x (template UI components)
- **Dependency Injection**: get_it + injectable
- **Local Database**: Hive 2.x
- **Cloud Database**: Firebase Firestore
- **Data Models**: freezed + json_serializable + hive_generator
- **Charts**: fl_chart
- **Animations**: flutter_animate + confetti
- **Audio**: audioplayers

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants (jar percentages, box names)
│   ├── di/                 # Dependency injection setup
│   └── utils/              # Utilities (logger, helpers)
├── models/                 # Data models (Jar, Transaction, MarketplaceItem, UserProfile)
├── repositories/
│   ├── interfaces/         # Repository contracts
│   ├── local/              # Hive implementations
│   └── remote/             # Firestore implementations
├── services/               # Business logic services
├── providers/              # Riverpod + Provider state management
├── views/                  # Screen views (Dashboard, Marketplace, etc.)
├── widgets/                # Reusable UI components (header, footer, quotes)
└── main.dart               # App entry point
```

## 📱 User Interface

### Navigation
The app uses a horizontal chip-based menu in the header:
- **Dashboard** - Overview of jars, wealth, recent transactions
- **Marketplace** - Browse and trade items
- **Transactions** - Full transaction history
- **Settings** - Configure income, jar percentages, sync

### Dashboard View
- Jar distribution pie chart
- Total wealth display
- Daily income simulator
- Recent transactions
- Motivational quote

### Marketplace View
- Browse catalog of items
- Buy items (deducts from selected jar)
- Sell owned items (adds to FFA jar)
- Firebase-synced global listings (when online)

### Transactions View
- Complete transaction ledger
- Filter by type (income, purchase, sale, transfer)
- Date and amount details

### Settings View
- Edit daily income range
- Adjust jar percentages (must total 100%)
- Toggle Firebase sync
- Manual sync button
- Export data to JSON

## 🎯 The 6-Jar System

Based on T. Harv Eker's "Secrets of the Millionaire Mind":

| Jar | Purpose | Default % |
|-----|---------|-----------|
| **NEC** | Necessities | 55% |
| **FFA** | Financial Freedom Account | 10% |
| **LTSS** | Long-Term Savings for Spending | 10% |
| **EDU** | Education | 10% |
| **PLAY** | Play | 10% |
| **GIVE** | Give | 5% |

*Percentages are fully customizable in Settings.*

## 🔄 Data Flow

### Offline Mode (Default)
```
User Action → Service → Local Repository (Hive) → UI Update
```

### Online Mode (Firebase Enabled)
```
User Action → Service → Local Repository → Remote Repository (Firestore) → Sync
```

### Bootstrap Flow
1. Initialize Hive + Firebase
2. Register Hive adapters
3. Load user profile (or create default)
4. Initialize jars (if first run)
5. Seed marketplace from JSON
6. Display dashboard

## 🛠️ Development

### Code Generation
Run this whenever you modify models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Clean Build
If you encounter issues:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Adding New Views
1. Create view in `lib/views/your_view/`
2. Add menu item in `main.dart` `_menuItems`
3. Add view to `IndexedStack` in `_RootShell`

### Adding Celebration Effects
```dart
// Import
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';

// In your widget
final soundProvider = context.read<SoundProvider>();
await soundProvider.playCelebration();
```

## 🎨 Customization

### Change App Branding
Edit `lib/widgets/template_header.dart`:
```dart
Text(
  'Your App Name',  // Line 47
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
  ),
),
```

### Modify Theme
Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4A5EE5), // Change this
  ),
  useMaterial3: true,
),
```

### Add Custom Quotes
Edit `assets/data/motivational_quotes.json`:
```json
[
  {
    "text": "Your custom quote",
    "author": "Author Name"
  }
]
```

## 🐛 Troubleshooting

### Dashboard Stuck Loading
- Check console for errors
- Verify Hive boxes are initialized
- Ensure assets are registered in `pubspec.yaml`

### Firebase Errors
- App works fully offline, Firebase is optional
- To use Firebase: run `flutterfire configure`
- Enable Firestore and Auth in Firebase Console

### Quotes Not Showing
- Verify `assets/data/motivational_quotes.json` exists
- Check asset is registered in `pubspec.yaml`
- Run `flutter clean && flutter pub get`

### Sound Not Playing
- Check network connection (sounds load from URLs)
- Verify sound toggle is ON in header
- Check browser console for CORS errors

## 📚 Documentation

- [TEMPLATE_INTEGRATION_COMPLETE.md](./TEMPLATE_INTEGRATION_COMPLETE.md) - Template integration details
- [SETUP_COMPLETE.md](./SETUP_COMPLETE.md) - Initial setup summary

## 🎉 Success Criteria

✅ All dependencies installed  
✅ Code generation complete  
✅ App runs without errors  
✅ Dashboard displays jar data  
✅ Marketplace loads items  
✅ Transactions view works  
✅ Settings allows configuration  
✅ Header/footer/menu render  
✅ Motivational quotes display  
✅ Sound toggle functional  
✅ No linter errors  

## 📝 License

Private project - not for redistribution.

---

**Built with Flutter 💙 | Powered by the 6-Jar Money System 💰**
