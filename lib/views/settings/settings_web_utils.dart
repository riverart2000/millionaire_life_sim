import 'dart:html' as html;

/// Clears web localStorage except theme-related keys
void clearWebStorage() {
  final storage = html.window.localStorage;
  final storageKeys = storage.keys.toList();
  for (final key in storageKeys) {
    if (!key.startsWith('theme_') && !key.startsWith('flex_')) {
      storage.remove(key);
    }
  }
}

/// Reloads the current web page
void reloadPage() {
  html.window.location.reload();
}
