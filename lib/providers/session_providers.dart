import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Check if Firebase is initialized
bool _isFirebaseInitialized() {
  try {
    Firebase.app();
    return true;
  } catch (e) {
    return false;
  }
}

/// Get FirebaseAuth instance safely, or null if not initialized
FirebaseAuth? _getFirebaseAuth() {
  try {
    if (_isFirebaseInitialized()) {
      return FirebaseAuth.instance;
    }
  } catch (e) {
    // Firebase not initialized
  }
  return null;
}

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = _getFirebaseAuth();
  if (auth == null) {
    // Return a stream that immediately emits null and closes
    return Stream.value(null);
  }
  return auth.authStateChanges();
});

final userIdProvider = Provider<String>((ref) {
  try {
    final authState = ref.watch(authStateProvider);
    final auth = _getFirebaseAuth();
    final user = authState.value ?? auth?.currentUser;
    return user?.uid ?? 'offline-user';
  } catch (e) {
    // Firebase not available, use offline user ID
    return 'offline-user';
  }
});

// Provider that gets user display name from legacy AuthProvider
// This is a workaround since we're mixing Riverpod and Provider
final userDisplayNameProvider = Provider<String>((ref) {
  // Try to get name from Firebase first
  try {
    final authState = ref.watch(authStateProvider);
    final auth = _getFirebaseAuth();
    final user = authState.value ?? auth?.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
  } catch (e) {
    // Firebase not available or no display name
  }
  
  // Fallback to default name - the actual name comes from AuthProvider
  // which is accessed in the UI via legacy.Provider
  return 'Millionaire';
});

