class MemoryCard {
  final int id;
  final String emoji;
  bool isFaceUp;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.emoji,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}