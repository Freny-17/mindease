import 'dart:math';
import 'package:flutter/material.dart';
import '../models/memory_card.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const MemoryCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Ensure initial state matches card data (in case it starts face up)
    if (widget.card.isFaceUp) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // FIX: Simply command the animation to match the current state.
    // Calling forward() or reverse() is safe even if it's already animating.
    if (widget.card.isFaceUp) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseCardColor = isDark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surface;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : theme.colorScheme.shadow.withOpacity(0.1);
    final matchedColor = Colors.green.withOpacity(0.15);
    final matchedBorderColor = Colors.green.withOpacity(0.5);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFrontVisible = angle >= pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: widget.card.isMatched ? matchedColor : baseCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.card.isMatched ? matchedBorderColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isFrontVisible
                  ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: Text(
                  widget.card.emoji,
                  style: const TextStyle(fontSize: 38),
                ),
              )
                  : Icon(
                Icons.spa_rounded,
                size: 32,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
            ),
          );
        },
      ),
    );
  }
}