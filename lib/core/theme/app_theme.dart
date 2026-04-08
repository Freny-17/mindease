import 'package:flutter/material.dart';

class AppTheme {

  // =========================
  // FLOWERS
  // =========================

  static final flowersLight = _buildTheme(
    brightness: Brightness.light,
    background: const Color(0xFFD0D5CA),
    primary: const Color(0xFF757756),
    surface: Colors.white,
    textColor: const Color(0xFF3E483E),
  );

  static final flowersDark = _buildTheme(
    brightness: Brightness.dark,
    background: const Color(0xFF1B2428),
    primary: const Color(0xFF969C81),
    surface: const Color(0xFF3E483E),
    textColor: Colors.white,
  );

  // =========================
  // FOREST
  // =========================

  static final forestLight = _buildTheme(
    brightness: Brightness.light,
    background: const Color(0xFFACA69E),
    primary: const Color(0xFF72654C),
    surface: Colors.white,
    textColor: const Color(0xFF4D4126),
  );

  static final forestDark = _buildTheme(
    brightness: Brightness.dark,
    background: const Color(0xFF060402),
    primary: const Color(0xFF4D4126),
    surface: const Color(0xFF1A1408),
    textColor: Colors.white,
  );

  // =========================
  // BUTTERFLY
  // =========================

  static final butterflyLight = _buildTheme(
    brightness: Brightness.light,
    background: const Color(0xFFD8A6B3),
    primary: const Color(0xFFBA6C7F),
    surface: Colors.white,
    textColor: const Color(0xFF573341),
  );

  static final butterflyDark = _buildTheme(
    brightness: Brightness.dark,
    background: const Color(0xFF281B23),
    primary: const Color(0xFF8C435F),
    surface: const Color(0xFF573341),
    textColor: Colors.white,
  );

  // =========================
  // HOME
  // =========================

  static final homeLight = _buildTheme(
    brightness: Brightness.light,
    background: const Color(0xFFF1E9DD),
    primary: const Color(0xFF8F643F),
    surface: Colors.white,
    textColor: const Color(0xFF613C21),
  );

  static final homeDark = _buildTheme(
    brightness: Brightness.dark,
    background: const Color(0xFF25150E),
    primary: const Color(0xFFB28C6B),
    surface: const Color(0xFF613C21),
    textColor: Colors.white,
  );

  // =========================
  // THEME BUILDER
  // =========================

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color primary,
    required Color surface,
    required Color textColor,
  }) {

    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
      primary: primary,
      secondary: primary,
      surface: surface,
    )
        : ColorScheme.light(
      primary: primary,
      secondary: primary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textColor.withValues(alpha: 0.8),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(primary),
        trackColor: WidgetStatePropertyAll(
          primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}