import 'package:flutter/material.dart';

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {

    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {

        return Transform.scale(
          scale: controller.value,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        );

      },
    );
  }
}