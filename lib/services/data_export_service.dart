import 'dart:convert';

import '../repositories/interfaces/jar_repository.dart';
import '../repositories/interfaces/marketplace_repository.dart';
import '../repositories/interfaces/transaction_repository.dart';
import '../repositories/interfaces/user_repository.dart';

class DataExportService {
  DataExportService({
    required JarRepository jarRepository,
    required TransactionRepository transactionRepository,
    required UserRepository userRepository,
    required MarketplaceRepository marketplaceRepository,
  })  : _jarRepository = jarRepository,
        _transactionRepository = transactionRepository,
        _userRepository = userRepository,
        _marketplaceRepository = marketplaceRepository;

  final JarRepository _jarRepository;
  final TransactionRepository _transactionRepository;
  final UserRepository _userRepository;
  final MarketplaceRepository _marketplaceRepository;

  Future<String> exportToJson() async {
    final profile = await _userRepository.fetchProfile();
    final jars = await _jarRepository.fetchAll();
    final transactions = await _transactionRepository.fetchAll();
    final catalog = await _marketplaceRepository.fetchLocalCatalog();

    final payload = {
      'generatedAt': DateTime.now().toIso8601String(),
      'profile': profile?.toJson(),
      'jars': jars.map((jar) => jar.toJson()).toList(),
      'transactions': transactions.map((tx) => tx.toJson()).toList(),
      'catalog': catalog.map((item) => item.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}

