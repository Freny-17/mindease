import 'dart:ui';
import 'package:flutter/material.dart';

class FlowerBasket extends StatelessWidget {
  final double basketX;
  final double basketY;
  final double velocity;
  final double gameAreaWidth;
  final double gameAreaHeight;
  final double widthRatio;

  const FlowerBasket({
    Key? key,
    required this.basketX,
    required this.basketY,
    required this.velocity,
    required this.gameAreaWidth,
    required this.gameAreaHeight,
    required this.widthRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double width = gameAreaWidth * widthRatio;

    // Tilt the basket slightly based on how fast the user is moving it
    // Clamp limits the tilt so it doesn't spin out of control
    double tiltAngle = (velocity * 0.5).clamp(-0.25, 0.25);

    return Positioned(
      left: basketX * gameAreaWidth,
      top: basketY * gameAreaHeight,

      child: Transform.rotate(
        angle: tiltAngle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),

          // --- FROSTED GLASS EFFECT ---
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: width,
              height: 18.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceTint.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),

                // Light inner border for premium Apple-style glass look
                border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    width: 1.5
                ),
                boxShadow: [
                  BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8)
                  )
                ],
              ),

              // --- INNER BASKET LINE ---
              child: Center(
                child: Container(
                  height: 4,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}