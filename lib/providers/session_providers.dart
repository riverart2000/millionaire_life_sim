import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fully offline user session
final userIdProvider = Provider<String>((ref) {
  return 'offline-user';
});

final userDisplayNameProvider = Provider<String>((ref) {
  return 'Millionaire';
});

