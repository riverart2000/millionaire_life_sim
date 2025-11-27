import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const String _themeModeKey = 'theme_mode';

  String _colorScheme = 'Material Deep Purple'; // Default FlexColorScheme
  ThemeMode _themeMode = ThemeMode.system;
  bool _initialized = false;
  
  // Backward compatibility
  FlexScheme _selectedScheme = FlexScheme.blue;

  String get colorScheme => _colorScheme;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get initialized => _initialized;
  List<String> get availableSchemes => AppTheme.schemes.keys.toList();
  
  // Backward compatibility
  FlexScheme get selectedScheme => _selectedScheme;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    final savedMode = prefs.getString(_themeModeKey);

    if (savedTheme != null) {
      // Try new string-based scheme first
      if (AppTheme.schemes.containsKey(savedTheme)) {
        _colorScheme = savedTheme;
        // Update backward compatibility scheme
        _selectedScheme = AppTheme.schemes[savedTheme] ?? FlexScheme.material;
      } else {
        // Backward compatibility: try old FlexScheme enum
        try {
          _selectedScheme = FlexScheme.values.firstWhere(
            (scheme) => scheme.name == savedTheme,
            orElse: () => FlexScheme.blue,
          );
          // Map to closest named scheme
          _colorScheme = _findClosestSchemeName(_selectedScheme);
        } catch (_) {
          _selectedScheme = FlexScheme.blue;
          _colorScheme = 'Material Deep Purple';
        }
      }
    }

    if (savedMode != null) {
      switch (savedMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    }

    _initialized = true;
    notifyListeners();
  }
  
  String _findClosestSchemeName(FlexScheme scheme) {
    // Map common schemes to named versions
    for (final entry in AppTheme.schemes.entries) {
      if (entry.value == scheme) {
        return entry.key;
      }
    }
    return 'Material Deep Purple';
  }

  // New method for setting color scheme by name
  Future<void> setColorScheme(String scheme) async {
    if (!AppTheme.schemes.containsKey(scheme)) return;
    if (_colorScheme == scheme) return;

    _colorScheme = scheme;
    _selectedScheme = AppTheme.schemes[scheme] ?? FlexScheme.material;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, scheme);
  }
  
  // Backward compatibility method
  Future<void> setTheme(FlexScheme scheme) async {
    if (_selectedScheme == scheme) return;

    _selectedScheme = scheme;
    _colorScheme = _findClosestSchemeName(scheme);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _colorScheme);
  }
  
  Future<void> toggleDarkMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(_themeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await prefs.setString(_themeModeKey, modeString);
  }

  ThemeData get currentTheme => AppTheme.getTheme(
    isDarkMode: _themeMode == ThemeMode.dark,
    colorScheme: _colorScheme,
  );
  
  ThemeData getLightTheme() {
    // Ensure initialized, but don't block - use defaults if not ready
    if (!_initialized) {
      _initialized = true; // Mark as initialized to prevent multiple calls
      initialize().catchError((e) {
        debugPrint('Theme init error: $e');
      });
    }
    return AppTheme.getTheme(
      isDarkMode: false,
      colorScheme: _colorScheme,
    );
  }

  ThemeData getDarkTheme() {
    // Ensure initialized, but don't block - use defaults if not ready
    if (!_initialized) {
      _initialized = true; // Mark as initialized to prevent multiple calls
      initialize().catchError((e) {
        debugPrint('Theme init error: $e');
      });
    }
    return AppTheme.getTheme(
      isDarkMode: true,
      colorScheme: _colorScheme,
    );
  }

  // Get list of available themes with display names
  static List<ThemeOption> get availableThemes => [
        ThemeOption(FlexScheme.blue, 'Blue Delight', 'Classic blue theme'),
        ThemeOption(FlexScheme.indigo, 'Indigo Nights', 'Deep indigo'),
        ThemeOption(FlexScheme.hippieBlue, 'Hippie Blue', 'Retro vibes'),
        ThemeOption(FlexScheme.aquaBlue, 'Aqua Blue', 'Ocean breeze'),
        ThemeOption(FlexScheme.brandBlue, 'Brand Blue', 'Corporate blue'),
        ThemeOption(FlexScheme.deepBlue, 'Deep Blue Sea', 'Navy depths'),
        ThemeOption(FlexScheme.sakura, 'Sakura', 'Cherry blossom pink'),
        ThemeOption(FlexScheme.mandyRed, 'Mandy Red', 'Bold red'),
        ThemeOption(FlexScheme.red, 'Red', 'Classic red'),
        ThemeOption(FlexScheme.redWine, 'Red Wine', 'Elegant burgundy'),
        ThemeOption(FlexScheme.purpleBrown, 'Purple Brown', 'Earthy purple'),
        ThemeOption(FlexScheme.green, 'Green', 'Fresh green'),
        ThemeOption(FlexScheme.money, 'Money', 'Dollar green'),
        ThemeOption(FlexScheme.jungle, 'Jungle', 'Tropical forest'),
        ThemeOption(FlexScheme.greyLaw, 'Grey Law', 'Professional grey'),
        ThemeOption(FlexScheme.wasabi, 'Wasabi', 'Spicy green'),
        ThemeOption(FlexScheme.gold, 'Gold', 'Luxury gold'),
        ThemeOption(FlexScheme.mango, 'Mango', 'Tropical orange'),
        ThemeOption(FlexScheme.amber, 'Amber', 'Warm amber'),
        ThemeOption(FlexScheme.vesuviusBurn, 'Vesuvius Burn', 'Volcanic orange'),
        ThemeOption(FlexScheme.deepPurple, 'Deep Purple', 'Rich purple'),
        ThemeOption(FlexScheme.ebonyClay, 'Ebony Clay', 'Dark sophistication'),
        ThemeOption(FlexScheme.barossa, 'Barossa', 'Wine country'),
        ThemeOption(FlexScheme.shark, 'Shark', 'Cool grey'),
        ThemeOption(FlexScheme.bigStone, 'Big Stone', 'Slate blue'),
        ThemeOption(FlexScheme.damask, 'Damask', 'Elegant red'),
        ThemeOption(FlexScheme.bahamaBlue, 'Bahama Blue', 'Caribbean waters'),
        ThemeOption(FlexScheme.mallardGreen, 'Mallard Green', 'Nature green'),
        ThemeOption(FlexScheme.espresso, 'Espresso', 'Coffee brown'),
        ThemeOption(FlexScheme.outerSpace, 'Outer Space', 'Cosmic dark'),
        ThemeOption(FlexScheme.blueWhale, 'Blue Whale', 'Ocean depths'),
        ThemeOption(FlexScheme.sanJuanBlue, 'San Juan Blue', 'Mediterranean'),
        ThemeOption(FlexScheme.rosewood, 'Rosewood', 'Rich wood'),
        ThemeOption(FlexScheme.blumineBlue, 'Blumine Blue', 'Sky blue'),
        ThemeOption(FlexScheme.flutterDash, 'Flutter Dash', 'Official Flutter'),
        ThemeOption(FlexScheme.materialBaseline, 'Material Baseline', 'Material Design'),
        ThemeOption(FlexScheme.verdunHemlock, 'Verdun Hemlock', 'Forest green'),
        ThemeOption(FlexScheme.dellGenoa, 'Dell Genoa', 'Tech green'),
        ThemeOption(FlexScheme.redM3, 'Red M3', 'Material 3 Red'),
        ThemeOption(FlexScheme.pinkM3, 'Pink M3', 'Material 3 Pink'),
        ThemeOption(FlexScheme.purpleM3, 'Purple M3', 'Material 3 Purple'),
        ThemeOption(FlexScheme.indigoM3, 'Indigo M3', 'Material 3 Indigo'),
        ThemeOption(FlexScheme.blueM3, 'Blue M3', 'Material 3 Blue'),
        ThemeOption(FlexScheme.cyanM3, 'Cyan M3', 'Material 3 Cyan'),
        ThemeOption(FlexScheme.tealM3, 'Teal M3', 'Material 3 Teal'),
        ThemeOption(FlexScheme.greenM3, 'Green M3', 'Material 3 Green'),
        ThemeOption(FlexScheme.limeM3, 'Lime M3', 'Material 3 Lime'),
        ThemeOption(FlexScheme.yellowM3, 'Yellow M3', 'Material 3 Yellow'),
        ThemeOption(FlexScheme.orangeM3, 'Orange M3', 'Material 3 Orange'),
        ThemeOption(FlexScheme.deepOrangeM3, 'Deep Orange M3', 'Material 3 Deep Orange'),
      ];
}

class ThemeOption {
  final FlexScheme scheme;
  final String name;
  final String description;

  const ThemeOption(this.scheme, this.name, this.description);
}

