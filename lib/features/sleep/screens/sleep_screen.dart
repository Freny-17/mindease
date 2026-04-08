import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mindease/features/sleep/screens/sleep_tips_screen.dart';
import 'package:mindease/features/sleep/screens/sleep_story_list_screen.dart';
import 'package:mindease/features/meditation/screens/meditation_screen.dart'; // ✅ Import Meditation

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 15)
    )..repeat();

    for (int i = 0; i < 45; i++) {
      stars.add(Star());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Sleep Sanctuary", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. Deep Night Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF020617), Colors.black]
                    : [theme.colorScheme.primary.withValues(alpha: 0.15), theme.colorScheme.surface],
              ),
            ),
          ),

          // 2. Stars
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: StarPainter(stars, _controller.value, isDark ? Colors.white : theme.colorScheme.primary),
                size: Size.infinite,
              );
            },
          ),

          // 3. Content Area
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("Rest & Restore", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text("Calm your mind for a deeper night.",
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),

                  const SizedBox(height: 35),

                  // 🔥 FEATURED: Sleep Stories
                  _buildHeroCard(
                    context,
                    title: "Sleep Stories",
                    subtitle: "Drift away to calming narrations",
                    icon: Icons.nightlight_round_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SleepStoryListScreen())),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 THE NEW GRID: Meditation & Tips
                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareCard(
                          context,
                          title: "Meditation",
                          subtitle: "Sleep Zen",
                          icon: Icons.self_improvement_rounded, // ✅ Meditation Icon
                          color: Colors.deepPurple,
                          onTap: () {
                            // Navigation to Meditation Screen
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const MeditationScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSquareCard(
                          context,
                          title: "Sleep Tips",
                          subtitle: "Best Habits",
                          icon: Icons.auto_awesome_rounded,
                          color: Colors.amber,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepTipsScreen())),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeroCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)]),
          boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }
}

// Ensure Star and StarPainter classes are at the bottom of the file
class Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 2 + 1;
  double speed = Random().nextDouble() * 0.01 + 0.005;
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  final Color color;
  StarPainter(this.stars, this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final double twinkle = (sin(animationValue * 2 * pi + (star.x * 10)) + 1) / 2;
      final paint = Paint()..color = color.withValues(alpha: 0.1 + (twinkle * 0.5));
      double dy = (star.y + animationValue * star.speed) % 1;
      canvas.drawCircle(Offset(star.x * size.width, dy * size.height), star.size, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}