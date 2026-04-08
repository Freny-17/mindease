import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/slow_catch_service.dart';

class SlowCatchController extends ChangeNotifier {
  final SlowCatchService _service = SlowCatchService();

  // Screen Lists
  List<Flower> activeFlowers = [];
  List<Particle> activeParticles = [];

  // Basket Settings
  double basketX = 0.39;
  double _targetBasketX = 0.39;
  double basketVelocity = 0.0;
  final double basketY = 0.78;
  final double basketWidthRatio = 0.22;

  // Game Stats
  int score = 0;
  bool isPaused = false;

  // Timers
  Duration _lastFrameTime = Duration.zero;
  double _totalTimeElapsed = 0.0;
  double _sessionDuration = 0.0;
  double _timeSinceLastSpawn = 0.0;

  /// This runs continuously to update the screen
  void updateFrame(Duration elapsed) {
    if (isPaused) {
      _lastFrameTime = elapsed;
      return;
    }

    // --- STEP 1: CALCULATE TIME (Delta Time) ---
    if (_lastFrameTime == Duration.zero) {
      _lastFrameTime = elapsed;
    }

    double dt = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
    if (dt > 0.1) dt = 0.1;

    _lastFrameTime = elapsed;
    _totalTimeElapsed += dt;
    _sessionDuration += dt;

    // --- STEP 2: GLIDE THE BASKET (Lerping) ---
    double oldX = basketX;
    basketX += (_targetBasketX - basketX) * 12.0 * dt;
    basketVelocity = (basketX - oldX) / dt;

    // --- STEP 3: SPAWN NEW FLOWERS ---
    _timeSinceLastSpawn += dt;
    if (_timeSinceLastSpawn > 2.2) {
      activeFlowers.add(_service.spawnFlower());
      _timeSinceLastSpawn = 0.0;
    }

    // --- STEP 4: UPDATE FLOWERS & CHECK CATCHES ---
    List<Flower> flowersToErase = [];

    for (var flower in activeFlowers) {
      _service.updateFlowerPhysics(flower, dt, _totalTimeElapsed);

      // Did we catch it?
      bool isCaught = _service.checkCollision(flower, basketX, basketY, basketWidthRatio);

      if (isCaught) {
        HapticFeedback.lightImpact();
        score++;
        flowersToErase.add(flower);
        activeParticles.addAll(_service.createCatchParticles(flower.currentX, flower.y));
      }
      // Did it fall off the bottom of the screen?
      else if (flower.y > 1.1) {
        flowersToErase.add(flower);

        // ==========================================
        // NEW LOGIC: SCORE RESET ON MISS
        // ==========================================
        if (score > 0) {
          score = 0;
          // Optional: A different haptic feel to subtly let them know the streak broke
          HapticFeedback.mediumImpact();
        }
      }
    }

    // Remove the caught/missed flowers from the screen
    activeFlowers.removeWhere((f) => flowersToErase.contains(f));

    // --- STEP 5: UPDATE EXPLOSION PARTICLES ---
    for (var p in activeParticles) {
      p.x += p.dx * dt;
      p.y += p.dy * dt;
      p.life -= dt;
    }
    // Erase dead particles
    activeParticles.removeWhere((p) => p.life <= 0);

    notifyListeners(); // Tell the UI to redraw
  }

  // --- USER CONTROLS ---

  void setTargetBasketPosition(double deltaX, double gameAreaWidth) {
    if (isPaused) return;

    _targetBasketX += deltaX / gameAreaWidth;

    if (_targetBasketX < 0) {
      _targetBasketX = 0;
    }
    if (_targetBasketX > 1.0 - basketWidthRatio) {
      _targetBasketX = 1.0 - basketWidthRatio;
    }
  }

  void togglePause() {
    isPaused = !isPaused;
    if (!isPaused) {
      _lastFrameTime = Duration.zero;
    }
    notifyListeners();
  }

  Future<void> finishSession() async {
    isPaused = true;
    notifyListeners();
    await _service.logMindfulSession(score, _sessionDuration);
  }

  Future<void> reset() async {
    await finishSession();

    activeFlowers.clear();
    activeParticles.clear();
    score = 0;
    _sessionDuration = 0.0;
    _targetBasketX = 0.5 - (basketWidthRatio / 2);
    isPaused = false;
    _totalTimeElapsed = 0.0;
    _lastFrameTime = Duration.zero;

    notifyListeners();
  }
}