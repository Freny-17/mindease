import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ==========================================
// DATA MODELS
// ==========================================

class Particle {
  double x;
  double y;
  double dx; // Horizontal speed
  double dy; // Vertical speed
  double life;
  double maxLife;

  Particle({
    required this.x, required this.y,
    required this.dx, required this.dy,
    required this.life, required this.maxLife
  });
}

class Flower {
  final String id;

  // X and Y are percentages of the screen (0.0 to 1.0)
  final double startX;
  double currentX;
  double y;

  // Physics Settings
  final double fallSpeed;      // How fast it drops
  final double swayMagnitude;  // How wide it moves left/right
  final double swaySpeed;      // How fast it moves left/right
  final double swayOffset;     // Random starting point for the sway

  double rotation;
  double rotationSpeed;

  Flower({
    required this.id, required this.startX, required this.currentX, required this.y,
    required this.fallSpeed, required this.swayMagnitude,
    required this.swaySpeed, required this.swayOffset,
    required this.rotation, required this.rotationSpeed
  });
}

// ==========================================
// SERVICE ENGINE
// ==========================================

class SlowCatchService {
  final Random _random = Random();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- GAME LOGIC ---

  /// Creates a new flower at the top of the screen with random settings
  Flower spawnFlower() {
    // Pick a random starting X position (between 10% and 90% of screen width)
    double randomStartX = _random.nextDouble() * 0.8 + 0.1;

    return Flower(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      startX: randomStartX,
      currentX: randomStartX,
      y: -0.1, // Start slightly above the top edge of the screen

      // Randomize the physics slightly so no two flowers fall the exact same way
      fallSpeed: 0.12 + (_random.nextDouble() * 0.08),
      swayMagnitude: 0.04 + (_random.nextDouble() * 0.06),
      swaySpeed: 1.2 + (_random.nextDouble() * 1.2),
      swayOffset: _random.nextDouble() * pi * 2,

      rotation: _random.nextDouble() * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 1.5,
    );
  }

  /// Moves the flower down and side-to-side based on the passing time
  void updateFlowerPhysics(Flower flower, double deltaTime, double totalTime) {
    // 1. Move it down
    flower.y += flower.fallSpeed * deltaTime;

    // 2. Calculate the organic side-to-side drift (using a Sine wave)
    double currentSwayPhase = (totalTime * flower.swaySpeed) + flower.swayOffset;
    double wavePosition = sin(currentSwayPhase);
    flower.currentX = flower.startX + (wavePosition * flower.swayMagnitude);

    // 3. Rotate it gently
    flower.rotation += flower.rotationSpeed * deltaTime;
  }

  /// Checks if the flower has touched the basket
  bool checkCollision(Flower flower, double basketX, double basketY, double basketWidthRatio) {
    // Step 1: Is the flower at the exact same vertical height as the basket?
    bool isAtBasketHeight = flower.y >= (basketY - 0.03) && flower.y <= (basketY + 0.03);

    // Step 2: Is the flower within the horizontal width of the basket?
    double flowerHitbox = 0.04;
    bool isInsideBasketLeftEdge = flower.currentX + flowerHitbox >= basketX;
    bool isInsideBasketRightEdge = flower.currentX - flowerHitbox <= (basketX + basketWidthRatio);

    // If both are true, it's a catch!
    if (isAtBasketHeight && isInsideBasketLeftEdge && isInsideBasketRightEdge) {
      return true;
    }
    return false;
  }

  /// Creates 5 tiny glowing dots that explode when you catch a flower
  List<Particle> createCatchParticles(double startX, double startY) {
    List<Particle> particles = [];

    for (int i = 0; i < 5; i++) {
      double randomAngle = _random.nextDouble() * pi * 2;
      double randomSpeed = 0.1 + (_random.nextDouble() * 0.2);
      double randomLife = 0.5 + (_random.nextDouble() * 0.5);

      particles.add(Particle(
          x: startX,
          y: startY,
          dx: cos(randomAngle) * randomSpeed,
          dy: (sin(randomAngle) * randomSpeed) - 0.2, // -0.2 gives it a slight upward bump
          life: randomLife,
          maxLife: randomLife
      ));
    }
    return particles;
  }

  // --- FIREBASE LOGIC ---

  Future<void> logMindfulSession(int score, double durationInSeconds) async {
    if (score == 0) return; // Ignore if the user didn't catch anything

    try {
      await _firestore.collection('mindful_sessions').add({
        'game': 'Slow Catch',
        'moments_caught': score,
        'duration_seconds': durationInSeconds.toInt(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('MindEase Session Saved!');
    } catch (e) {
      debugPrint('Error saving to Firebase: $e');
    }
  }
}