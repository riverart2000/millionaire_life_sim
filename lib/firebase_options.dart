import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBeGQEO4MiL35CEQwEy3uF6phLiTbSEdt4',
        appId: '1:826118547879:web:b8f262355b300e04652e82',
        messagingSenderId: '826118547879',
        projectId: 'millionaire-lifestyle-e2770',
        authDomain: 'millionaire-lifestyle-e2770.firebaseapp.com',
        storageBucket: 'millionaire-lifestyle-e2770.firebasestorage.app',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_IOS_API_KEY',
          appId: 'YOUR_IOS_APP_ID',
          messagingSenderId: 'YOUR_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
          iosBundleId: 'com.example.millionaireLifeSimulator',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_MACOS_API_KEY',
          appId: 'YOUR_MACOS_APP_ID',
          messagingSenderId: 'YOUR_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
          iosBundleId: 'com.example.millionaireLifeSimulator',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'YOUR_DESKTOP_API_KEY',
          appId: 'YOUR_DESKTOP_APP_ID',
          messagingSenderId: 'YOUR_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }
}

