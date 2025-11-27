class Quote {
  final String text;
  final String author;

  const Quote({
    required this.text,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    // Support both 'text' and 'quote' keys for compatibility
    final quoteText = json['quote'] ?? json['text'] ?? '';
    return Quote(
      text: quoteText.toString(),
      author: (json['author'] ?? 'Unknown').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}

