import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bubble {
  final String id;
  double x;
  double y;
  final double size;
  final Color color;
  final double speed;
  bool isPopping = false;

  Bubble({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
  });
}

class FocusBubblesController extends ChangeNotifier {
  final Random _random = Random();

  bool isPlaying = false;
  bool isGameOver = false;

  int score = 0;
  int highScore = 0;
  int timeLeft = 30;

  Timer? _gameLoopTimer;
  Timer? _countdownTimer;

  List<Bubble> bubbles = [];
  double screenHeight = 800;

  FocusBubblesController() {
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('focus_bubbles_high_score') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('focus_bubbles_high_score', highScore);
    }
  }

  // 🔥 UPDATED PREMIUM COLOR PALETTES
  List<Color> getBubbleColors(bool isDark) {
    if (isDark) {
      // Soft glowing pastels for Dark Mode
      return [
        const Color(0xFFFFCCBC), // Peach
        const Color(0xFFA5D6A7), // Mint
        const Color(0xFF81D4FA), // Ice Blue
        const Color(0xFFCE93D8), // Lilac
        const Color(0xFFFFF59D), // Soft Yellow
      ];
    } else {
      // Vibrant Jewel Tones for Light Mode (Replaced the dark browns/greys)
      return [
        const Color(0xFF5C6BC0), // Indigo
        const Color(0xFF26A69A), // Teal
        const Color(0xFFFF7043), // Coral
        const Color(0xFFAB47BC), // Vibrant Lavender
        const Color(0xFF29B6F6), // Ocean Blue
      ];
    }
  }

  void startGame(double height) {
    screenHeight = height;
    score = 0;
    timeLeft = 30;
    bubbles.clear();

    isPlaying = true;
    isGameOver = false;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        endGame();
      }
    });

    _gameLoopTimer =
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
          _updateBubbles();
        });
  }

  void spawnBubble(bool isDark) {
    final colors = getBubbleColors(isDark);

    bubbles.add(
      Bubble(
        id: DateTime.now().microsecondsSinceEpoch.toString() + _random.nextInt(1000).toString(),
        x: _random.nextDouble() * 0.8 + 0.1, // Keeps bubbles mostly centered
        y: screenHeight + 50, // Spawns below screen
        size: _random.nextDouble() * 30 + 40,
        color: colors[_random.nextInt(colors.length)],
        speed: _random.nextDouble() * 2 + 2,
      ),
    );
  }

  void _updateBubbles() {
    for (int i = 0; i < bubbles.length; i++) {
      if (!bubbles[i].isPopping) {
        bubbles[i].y -= bubbles[i].speed;
      }
    }

    // Remove bubbles that float off the top
    bubbles.removeWhere((b) => b.y < -100 && !b.isPopping);
    notifyListeners();
  }

  void popBubble(String id) {
    if (!isPlaying || isGameOver) return;

    final index = bubbles.indexWhere((b) => b.id == id);

    if (index != -1 && !bubbles[index].isPopping) {
      bubbles[index].isPopping = true;
      score += 10; // 10 points per pop!
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 150), () {
        bubbles.removeWhere((b) => b.id == id);
        notifyListeners();
      });
    }
  }

  void endGame() {
    _countdownTimer?.cancel();
    _gameLoopTimer?.cancel();
    isPlaying = false;
    isGameOver = true;
    _saveHighScore();
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _gameLoopTimer?.cancel();
    super.dispose();
  }
}