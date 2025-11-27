import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const _storageKeyName = 'template_user_name';
  static const _storageKeyEmail = 'template_user_email';

  String? _name;
  String? _email;
  bool _isReady = false;

  bool get isAuthenticated => _name != null && _email != null;
  bool get isReady => _isReady;
  String? get name => _name;
  String? get email => _email;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_storageKeyName);
    final email = prefs.getString(_storageKeyEmail);

    if (name != null && email != null) {
      _name = name;
      _email = email;
    }

    _isReady = true;
    notifyListeners();
  }

  Future<bool> login({required String name, required String email}) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty || trimmedEmail.isEmpty) {
      return false;
    }

    _name = trimmedName;
    _email = trimmedEmail;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKeyName, trimmedName);
    await prefs.setString(_storageKeyEmail, trimmedEmail);

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _name = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKeyName);
    await prefs.remove(_storageKeyEmail);

    notifyListeners();
  }
}

