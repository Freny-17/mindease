import 'dart:async';
import 'package:flutter/material.dart';
import '../models/memory_card.dart';

class CalmMemoryController extends ChangeNotifier {
  List<MemoryCard> cards = [];
  int moves = 0;
  int timeInSeconds = 0;
  bool isGameOver = false;
  bool isProcessing = false;

  Timer? _timer;
  MemoryCard? _firstSelectedCard;

  final List<String> _emojis = ['🌸', '🌊', '🌿', '🦋', '🌙', '⭐', '🌈', '🍀'];

  CalmMemoryController() {
    resetGame();
  }

  void resetGame() {
    _timer?.cancel();
    moves = 0;
    timeInSeconds = 0;
    isGameOver = false;
    isProcessing = false;
    _firstSelectedCard = null;

    // Create 8 pairs of emojis
    List<String> pairedEmojis = [..._emojis, ..._emojis];
    pairedEmojis.shuffle();

    cards = List.generate(
      16,
          (index) => MemoryCard(id: index, emoji: pairedEmojis[index]),
    );
    notifyListeners();
  }

  void startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeInSeconds++;
      notifyListeners();
    });
  }

  void flipCard(MemoryCard card) async {
    // Prevent interaction if processing a mismatch, or if card is already revealed
    if (isProcessing || card.isFaceUp || card.isMatched) return;

    // Start timer on the very first interaction
    if (moves == 0 && _firstSelectedCard == null && timeInSeconds == 0) {
      startTimer();
    }

    card.isFaceUp = true;
    notifyListeners();

    if (_firstSelectedCard == null) {
      _firstSelectedCard = card;
    } else {
      moves++;
      isProcessing = true;
      notifyListeners();

      if (_firstSelectedCard!.emoji == card.emoji) {
        // Match found
        _firstSelectedCard!.isMatched = true;
        card.isMatched = true;
        _firstSelectedCard = null;
        isProcessing = false;
        _checkWinCondition();
        notifyListeners();
      } else {
        // No match found - wait slightly so player can see the card, then flip back
        await Future.delayed(const Duration(milliseconds: 800));
        _firstSelectedCard!.isFaceUp = false;
        card.isFaceUp = false;
        _firstSelectedCard = null;
        isProcessing = false;
        notifyListeners();
      }
    }
  }

  void _checkWinCondition() {
    if (cards.every((card) => card.isMatched)) {
      isGameOver = true;
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}