import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    // Detects if the system or app is in Dark Mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        // Teal for Light Mode, White for Dark Mode
        isDarkMode ? Colors.white : const Color(0xFF006D77),
        BlendMode.srcIn,
      ),
      child: Image.asset(
        'assets/logo/app_main_logo.png', // Ensure this matches your file name
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}