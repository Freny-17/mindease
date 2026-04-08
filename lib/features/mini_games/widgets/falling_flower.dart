import 'package:flutter/material.dart';
import '../services/slow_catch_service.dart';

class FallingFlower extends StatelessWidget {
  final Flower flower;
  final double gameAreaWidth;
  final double gameAreaHeight;

  const FallingFlower({
    Key? key,
    required this.flower,
    required this.gameAreaWidth,
    required this.gameAreaHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double size = gameAreaWidth * 0.14;

    return Positioned(
      // Position on screen
      left: flower.currentX * gameAreaWidth,
      top: flower.y * gameAreaHeight,

      child: Transform.rotate(
        angle: flower.rotation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Double shadow creates a soft, ethereal glow
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.spa_rounded,
              color: theme.colorScheme.primary.withOpacity(0.9),
              size: size * 0.65,
            ),
          ),
        ),
      ),
    );
  }
}