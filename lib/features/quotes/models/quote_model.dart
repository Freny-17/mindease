class QuoteModel {
  final String id;
  final String text;
  final String category;

  QuoteModel({
    required this.id,
    required this.text,
    required this.category,
  });

  factory QuoteModel.fromMap(String id, Map<String, dynamic> data) {
    return QuoteModel(
      id: id,
      text: data['text'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category,
    };
  }
}
