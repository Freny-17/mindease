import 'package:flutter/material.dart';

class ColorOptionButton extends StatelessWidget {
  final String colorName;
  final Color colorValue;
  final VoidCallback onTap;
  final bool isEnabled;

  const ColorOptionButton({
    Key? key,
    required this.colorName,
    required this.colorValue,
    required this.onTap,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isEnabled
              ? colorValue.withOpacity(isDark ? 0.2 : 0.15)
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled ? colorValue.withOpacity(0.8) : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          colorName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isEnabled ? (isDark ? colorValue.withOpacity(0.9) : colorValue) : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}