import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/affirmation_model.dart';

class AffirmationsService {
  static const String _affirmationsAssetPath = 'MMI-affirmations.txt';
  final Random _random = Random();
  
  List<String> _rawAffirmations = [];
  List<AffirmationModel> _affirmations = [];

  /// Load affirmations from asset file
  Future<void> loadAffirmations() async {
    try {
      final content = await rootBundle.loadString(_affirmationsAssetPath);
      _rawAffirmations = content
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      
      _affirmations = _rawAffirmations.map((text) => _createAffirmation(text)).toList();
    } catch (e) {
      // If file not found in assets, use hardcoded affirmations
      _rawAffirmations = _defaultAffirmations;
      _affirmations = _rawAffirmations.map((text) => _createAffirmation(text)).toList();
    }
  }

  /// Get all affirmations
  List<AffirmationModel> getAffirmations() => _affirmations;

  /// Get a random affirmation for practice
  AffirmationModel getRandomAffirmation() {
    if (_affirmations.isEmpty) return _createAffirmation('I am financially successful.');
    return _affirmations[_random.nextInt(_affirmations.length)];
  }

  /// Get a specific affirmation by ID
  AffirmationModel? getAffirmationById(String id) {
    try {
      return _affirmations.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if user's answer is correct
  bool checkAnswer(AffirmationModel affirmation, int blankIndex, String userAnswer) {
    if (blankIndex >= affirmation.blankIndices.length) return false;
    
    final correctIndex = affirmation.blankIndices[blankIndex];
    final correctWord = affirmation.words[correctIndex].toLowerCase().replaceAll(RegExp(r'[,.]'), '');
    final userWord = userAnswer.toLowerCase().trim();
    
    return correctWord == userWord;
  }

  /// Create affirmation model with random blanks
  AffirmationModel _createAffirmation(String text) {
    final words = text.split(' ');
    final id = text.substring(0, min(20, text.length)).replaceAll(' ', '_');
    
    // Select 2-3 meaningful words to blank out (skip common words)
    final meaningfulIndices = <int>[];
    for (int i = 0; i < words.length; i++) {
      final word = words[i].toLowerCase().replaceAll(RegExp(r'[,.]'), '');
      if (_isMeaningfulWord(word)) {
        meaningfulIndices.add(i);
      }
    }
    
    // Randomly select 2-3 words to blank
    meaningfulIndices.shuffle(_random);
    final blankIndices = meaningfulIndices.take(min(3, meaningfulIndices.length)).toList()
      ..sort();
    
    return AffirmationModel(
      id: id,
      fullText: text,
      words: words,
      blankIndices: blankIndices,
    );
  }

  /// Check if word is meaningful (not a common filler word)
  bool _isMeaningfulWord(String word) {
    const skipWords = {
      'i', 'a', 'an', 'the', 'and', 'or', 'but', 'is', 'am', 'are', 'was', 'were',
      'be', 'been', 'being', 'to', 'of', 'in', 'for', 'on', 'at', 'by', 'with',
      'my', 'me', 'it', 'as', 'that', 'this', 'from', 'have', 'has', 'had',
    };
    return word.length > 3 && !skipWords.contains(word);
  }

  /// Default affirmations if file load fails
  static const List<String> _defaultAffirmations = [
    'I am an excellent money manager.',
    'I always pay myself first.',
    'I put money into my Financial Freedom account everyday.',
    'My money works hard for me and makes me more and more money.',
    'I earn enough passive income to pay for my desired lifestyle.',
    'I am financially free, I work because I choose to, not because I have to.',
    'My part-time business is managing and investing my money and creating passive income streams.',
    'I create my life. I create the exact amount of my financial success.',
    'I play the money game to win. My intention is to create massive wealth and abundance.',
    'I admire and model rich and successful people.',
    'I believe money is important, money is freedom and money makes life more enjoyable.',
    'I get rich doing what I love.',
    'I deserve to be rich because I add massive value to other peoples lives.',
    'I am a generous giver and an excellent receiver.',
    'I am truly grateful for all the money I have right now.',
    'Lucrative opportunities always come my way.',
    'My capacity to earn, hold and grow money expands day-by-day.',
  ];
}
