import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/declaration_model.dart';
import '../services/declaration_service.dart';
import 'bootstrap_provider.dart';

/// Provider for DeclarationService
final declarationServiceProvider = Provider<DeclarationService>((ref) {
  return DeclarationService(
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

/// Provider to load declarations
final declarationsLoadProvider = FutureProvider<void>((ref) async {
  final service = ref.read(declarationServiceProvider);
  await service.loadDeclarations();
});

/// Provider for all declarations
final allDeclarationsProvider = Provider<List<Declaration>>((ref) {
  ref.watch(declarationsLoadProvider);
  final service = ref.read(declarationServiceProvider);
  return service.getAllDeclarations();
});

/// Provider for saved declaration responses
final savedDeclarationResponsesProvider =
    FutureProvider<Map<String, DeclarationResponse>>((ref) async {
  final service = ref.read(declarationServiceProvider);
  return await service.getSavedResponses();
});

/// Provider for latest responses by type (for footer display)
final latestDeclarationsByTypeProvider =
    FutureProvider<Map<String, DeclarationResponse>>((ref) async {
  final service = ref.read(declarationServiceProvider);
  return await service.getLatestResponsesByType();
});
