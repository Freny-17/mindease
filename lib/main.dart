import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// 🔥 THIS IS THE MAGIC FILE THAT FIXES THE RED SCREEN
import 'firebase_options.dart';

import 'core/auth/auth_wrapper.dart';
import 'core/theme/theme_controller.dart';

// Controller Imports
import 'features/mood/controllers/mood_controller.dart';
import 'features/quotes/controllers/quotes_controller.dart';
import 'features/journal/controllers/journal_controller.dart';
import 'features/support/controllers/support_controller.dart';
import 'features/inner_guide/controllers/inner_guide_controller.dart';

import 'features/home/screens/splash_screen.dart';

void main() async {
  // 1. MUST BE FIRST: Tells Flutter to hold on a second
  WidgetsFlutterBinding.ensureInitialized();

  // 2. MUST BE SECOND: Boots up the Firebase Engine safely
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. MUST BE THIRD: Actually starts your app's UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => MoodController(),
        ),
        ChangeNotifierProvider(
          create: (_) => QuotesController(),
        ),
        ChangeNotifierProvider(
          create: (_) => JournalController(),
        ),
        ChangeNotifierProvider(
          create: (_) => SupportController(),
        ),
        // INNER GUIDE AI CONTROLLER
        ChangeNotifierProvider(
          create: (_) => InnerGuideController(),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MindEase',
            theme: themeController.currentTheme,
            home: const SplashScreenWrapper(),
          );
        },
      ),
    );
  }
}

// ==========================================
// SPLASH SCREEN LOGIC
// ==========================================
class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then show the Login Screen (or Home if logged in)
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    return const AuthWrapper();
  }
}