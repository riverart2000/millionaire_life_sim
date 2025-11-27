import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/quote.dart';
import '../services/quote_service.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteService _service;
  final Random _random;

  QuoteProvider({QuoteService? service, Random? random})
      : _service = service ?? QuoteService(),
        _random = random ?? Random();

  List<Quote> _quotes = const [];
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _error;

  Quote? get currentQuote => _currentQuote;
  bool get hasQuotes => _quotes.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuotes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load quotes using static method first
      await QuoteService.loadQuotes();
      // Then get the list via instance method for compatibility
      final quotes = await _service.loadQuotesAsync();
      _quotes = quotes;
      _currentQuote = quotes.isNotEmpty ? quotes[_random.nextInt(quotes.length)] : null;
    } catch (error, stackTrace) {
      _error = 'Unable to load motivational quotes';
      if (kDebugMode) {
        // ignore: avoid_print
        print('QuoteProvider.loadQuotes error: $error\n$stackTrace');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextQuote() {
    if (_quotes.isEmpty) {
      return;
    }
    if (_quotes.length == 1) {
      _currentQuote = _quotes.first;
    } else {
      Quote? candidate;
      do {
        candidate = _quotes[_random.nextInt(_quotes.length)];
      } while (candidate == _currentQuote);
      _currentQuote = candidate;
    }
    notifyListeners();
  }
}

