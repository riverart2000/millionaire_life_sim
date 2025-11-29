import 'package:flutter/services.dart' show rootBundle;

class AffirmationService {
  List<String> _affirmations = [];
  int _currentIndex = 0;

  /// Load affirmations from assets/data/MMI-affirmations.txt
  Future<void> loadAffirmations() async {
    try {
      final content = await rootBundle.loadString('assets/data/MMI-affirmations.txt');
      _affirmations = content
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      
      if (_affirmations.isEmpty) {
        _affirmations = _defaultAffirmations;
      }
    } catch (e) {
      _affirmations = _defaultAffirmations;
    }
  }

  String getNextAffirmation() {
    if (_affirmations.isEmpty) return 'I am financially successful.';
    final affirmation = _affirmations[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _affirmations.length;
    return affirmation;
  }

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
