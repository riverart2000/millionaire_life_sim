import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/quote.dart';

class QuoteService {
  static const _assetPath = 'assets/data/motivational_quotes.json';
  static List<Quote>? _quotes;
  static final Random _random = Random();
  static bool _isLoaded = false;
  
  static bool get isLoaded => _isLoaded;

  /// Load quotes from JSON file (static method matching learning_hub)
  static Future<void> loadQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      _quotes = jsonData.map((json) => Quote.fromJson(json)).toList();
      _isLoaded = true;
      print('✅ Loaded ${_quotes!.length} motivational quotes from JSON');
    } catch (e) {
      print('⚠️ Error loading quotes, using defaults: $e');
      // If file doesn't exist or has errors, use default quotes
      _quotes = _getDefaultQuotes();
      _isLoaded = true;
    }
  }

  /// Get a random quote (static method matching learning_hub)
  static Quote getRandomQuote() {
    if (_quotes == null || _quotes!.isEmpty) {
      print('⚠️ No quotes loaded, returning default');
      return Quote(
        text: 'Keep learning and growing!',
        author: 'Millionaire Life Simulator',
      );
    }
    
    final quote = _quotes![_random.nextInt(_quotes!.length)];
    print('💡 Selected quote: "${quote.text}" — ${quote.author}');
    return quote;
  }

  /// Instance method for backward compatibility with QuoteProvider
  Future<List<Quote>> loadQuotesAsync() async {
    if (!_isLoaded) {
      await loadQuotes();
    }
    return _quotes ?? [];
  }

  /// Default fallback quotes
  static List<Quote> _getDefaultQuotes() {
    return [
      Quote(
        text: 'Keep learning and growing!',
        author: 'Millionaire Life Simulator',
      ),
      Quote(
        text: 'The beautiful thing about learning is that no one can take it away from you.',
        author: 'B.B. King',
      ),
      Quote(
        text: 'Education is the most powerful weapon which you can use to change the world.',
        author: 'Nelson Mandela',
      ),
      Quote(
        text: 'The more that you read, the more things you will know. The more that you learn, the more places you\'ll go.',
        author: 'Dr. Seuss',
      ),
      Quote(
        text: 'Live as if you were to die tomorrow. Learn as if you were to live forever.',
        author: 'Mahatma Gandhi',
      ),
      Quote(
        text: 'Success is the sum of small efforts, repeated day in and day out.',
        author: 'Robert Collier',
      ),
      Quote(
        text: 'Action is the foundational key to all success.',
        author: 'Pablo Picasso',
      ),
      Quote(
        text: 'It always seems impossible until it is done.',
        author: 'Nelson Mandela',
      ),
    ];
  }
}

