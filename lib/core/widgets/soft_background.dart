import 'package:flutter/material.dart';

class SoftBackground extends StatelessWidget {
  final Widget child;

  const SoftBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      decoration: BoxDecoration(
        gradient: brightness == Brightness.light
            ? const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF7F0E8),
            Color(0xFFF1E7DC),
            Color(0xFFE8DDD2),
          ],
        )
            : const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2C2724),
            Color(0xFF231F1C),
            Color(0xFF1A1715),
          ],
        ),
      ),
      child: child,
    );
  }
}
