import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/declaration_model.dart';
import '../models/transaction_model.dart';
import '../core/constants/hive_box_constants.dart';
import '../repositories/interfaces/transaction_repository.dart';
import 'package:uuid/uuid.dart';

/// Service to manage declarations and user responses
class DeclarationService {
  static const String _declarationsKey = 'user_declarations';
  List<Declaration>? _declarations;
  final TransactionRepository? _transactionRepository;
  final Uuid _uuid = const Uuid();

  DeclarationService({TransactionRepository? transactionRepository})
      : _transactionRepository = transactionRepository;

  /// Load declarations from JSON asset
  Future<void> loadDeclarations() async {
    if (_declarations != null) return;

    try {
      final String response =
          await rootBundle.loadString('assets/data/declarations.json');
      final List<dynamic> data = json.decode(response);
      _declarations = data.map((json) => Declaration.fromJson(json)).toList();
      debugPrint('✅ Loaded ${_declarations!.length} declarations');
    } catch (e) {
      debugPrint('❌ Error loading declarations: $e');
      _declarations = [];
    }
  }

  /// Get all declarations
  List<Declaration> getAllDeclarations() {
    return _declarations ?? [];
  }

  /// Save user response to Hive (overwrites previous response for same type)
  Future<void> saveResponse({
    required String declarationId,
    required String type,
    required String text,
    String? userInput,
  }) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.declarations);
      
      final response = DeclarationResponse(
        declarationId: declarationId,
        type: type,
        text: text,
        userInput: userInput,
        completedAt: DateTime.now(),
      );

      // Get existing responses
      final String? existingJson = box.get(_declarationsKey);
      Map<String, dynamic> responses = {};
      
      if (existingJson != null) {
        responses = json.decode(existingJson);
      }

      // Overwrite response for this declaration ID
      responses[declarationId] = response.toJson();

      // Save back to Hive
      await box.put(_declarationsKey, json.encode(responses));
      debugPrint('✅ Saved declaration response: $declarationId');

      // If this is an answer type, record it as a transaction
      if (type == 'answer' && userInput != null && _transactionRepository != null) {
        final transaction = MoneyTransaction(
          id: _uuid.v4(),
          jarId: 'none', // No jar associated with answers
          amount: 0.0,
          kind: TransactionKind.answer,
          date: DateTime.now(),
          description: userInput,
          metadata: {
            'declarationId': declarationId,
            'question': text,
          },
        );
        await _transactionRepository.save(transaction);
        debugPrint('✅ Recorded answer in transaction history');
      }
    } catch (e) {
      debugPrint('❌ Error saving declaration response: $e');
    }
  }

  /// Get all saved responses
  Future<Map<String, DeclarationResponse>> getSavedResponses() async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.declarations);
      final String? responsesJson = box.get(_declarationsKey);
      
      if (responsesJson == null) return {};

      final Map<String, dynamic> data = json.decode(responsesJson);
      return data.map(
        (key, value) => MapEntry(
          key,
          DeclarationResponse.fromJson(value),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error loading declaration responses: $e');
      return {};
    }
  }

  /// Get latest response for each type (for footer display)
  Future<Map<String, DeclarationResponse>> getLatestResponsesByType() async {
    final allResponses = await getSavedResponses();
    final Map<String, DeclarationResponse> latestByType = {};

    for (final response in allResponses.values) {
      final existing = latestByType[response.type];
      if (existing == null ||
          response.completedAt.isAfter(existing.completedAt)) {
        latestByType[response.type] = response;
      }
    }

    return latestByType;
  }

  /// Get random declaration that hasn't been answered today
  Future<Declaration?> getRandomDeclaration() async {
    if (_declarations == null || _declarations!.isEmpty) {
      await loadDeclarations();
    }

    if (_declarations == null || _declarations!.isEmpty) return null;

    final savedResponses = await getSavedResponses();
    final today = DateTime.now();

    // Find declarations not answered today
    final unanswered = _declarations!.where((declaration) {
      final response = savedResponses[declaration.id];
      if (response == null) return true;
      
      final responseDate = response.completedAt;
      return responseDate.year != today.year ||
          responseDate.month != today.month ||
          responseDate.day != today.day;
    }).toList();

    if (unanswered.isEmpty) return null;

    // Return random unanswered declaration
    unanswered.shuffle();
    return unanswered.first;
  }

  /// Clear today's responses (called at start of new day to reset declarations)
  Future<void> clearTodayResponses() async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.declarations);
      await box.delete(_declarationsKey);
      debugPrint('✅ Cleared today\'s declaration responses');
    } catch (e) {
      debugPrint('❌ Error clearing declaration responses: $e');
    }
  }
}
