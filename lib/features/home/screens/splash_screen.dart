import 'package:flutter/material.dart';
import '../../../core/widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Center: Main App Branding
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 200),
                const SizedBox(height: 4),

              ],
            ),
          ),

          // 2. Bottom: University Partnership
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Powered by',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.withOpacity(0.7),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/logo/mu-logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}