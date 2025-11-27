import 'package:flutter/foundation.dart';

void logInfo(String message) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('[INFO] $message');
  }
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('[ERROR] $message :: $error');
    if (stackTrace != null) {
      // ignore: avoid_print
      print(stackTrace);
    }
  }
}

