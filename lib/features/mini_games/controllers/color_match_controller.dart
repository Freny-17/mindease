import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/color_question.dart';

class ColorMatchController extends ChangeNotifier {
  static const int roundDuration = 30;
  static const String _highScoreKey = 'color_match_high_score';

  int score = 0;
  int highScore = 0;
  int streak = 0;
  int maxStreak = 0;
  int timeRemaining = roundDuration;

  bool isPlaying = false;
  bool isGameOver = false;

  ColorQuestion? currentQuestion;
  Timer? _timer;
  final Random _random = Random();

  // Using calm, softer variations of the standard colors to fit MindEase
  final Map<String, Color> gameColors = {
    'Red': const Color(0xFFE57373),
    'Blue': const Color(0xFF64B5F6),
    'Green': const Color(0xFF81C784),
    'Yellow': const Color(0xFFFFD54F),
  };

  ColorMatchController() {
    _loadHighScore();
    _generateQuestion(); // Generate initial state so UI isn't empty
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_highScoreKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, highScore);
    }
  }

  void startGame() {
    score = 0;
    streak = 0;
    maxStreak = 0;
    timeRemaining = roundDuration;
    isPlaying = true;
    isGameOver = false;

    _generateQuestion();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        timeRemaining--;
        notifyListeners();
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    isPlaying = false;
    isGameOver = true;
    _saveHighScore();
    notifyListeners();
  }

  void _generateQuestion() {
    final colorNames = gameColors.keys.toList();

    // Pick random text and random ink color
    String textWord = colorNames[_random.nextInt(colorNames.length)];
    String inkColorName = colorNames[_random.nextInt(colorNames.length)];

    // Ensure we get a good mix of congruent and incongruent (Stroop effect)
    // 70% chance to force a mismatch for cognitive challenge
    if (_random.nextDouble() > 0.3 && textWord == inkColorName) {
      inkColorName = colorNames.firstWhere((color) => color != textWord);
    }

    currentQuestion = ColorQuestion(
      textWord: textWord.toUpperCase(),
      inkColorName: inkColorName,
      inkColorValue: gameColors[inkColorName]!,
    );
  }

  void checkAnswer(String selectedColorName) {
    if (!isPlaying || isGameOver || currentQuestion == null) return;

    if (selectedColorName == currentQuestion!.inkColorName) {
      // Correct! Identify the INK color
      score += 10;
      streak++;
      if (streak > maxStreak) maxStreak = streak;
    } else {
      // Wrong!
      score = (score - 5).clamp(0, double.infinity).toInt(); // Prevent negative scores
      streak = 0;
    }

    _generateQuestion();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}