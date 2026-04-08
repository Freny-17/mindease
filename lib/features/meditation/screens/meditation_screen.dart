import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/meditation_controller.dart';
import 'meditation_session_screen.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => MeditationController(),
      builder: (context, child) {
        return Scaffold(
          // ✅ This ensures the background color is consistent
          backgroundColor: theme.colorScheme.surface,
          body: Stack(
            children: [
              // 1. Ambient Background Glow
              Positioned(
                top: -100,
                right: -50,
                child: _ambientGlow(theme.colorScheme.primary.withOpacity(0.1), 400),
              ),

              // 2. Main Content
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // CUSTOM HEADER WITH BACK BUTTON
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            // ✅ FIXED: Manual Back Button
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                              tooltip: "Back",
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Meditation",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Welcome Text
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time to breathe",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Featured "Daily Session" Hero Card
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverToBoxAdapter(
                        child: _featuredCard(context, theme),
                      ),
                    ),

                    // 4. Section Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Text(
                          "Quick Sessions",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // 5. Grid of Meditation Styles
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildListDelegate([
                          _compactSessionCard(context, "Quick Reset", "2 min", Icons.bolt_rounded, Colors.amber),
                          _compactSessionCard(context, "Mindful Break", "5 min", Icons.spa_rounded, Colors.green),
                          _compactSessionCard(context, "Deep Focus", "10 min", Icons.self_improvement_rounded, Colors.blue),
                          _compactSessionCard(context, "Sleep Ready", "15 min", Icons.bedtime_rounded, Colors.indigo),
                        ]),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets remain the same as before ---
  Widget _featuredCard(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => _startMeditation(context, 10),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "RECOMMENDED",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Daily Calm",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "10 Minutes • Guided Session",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 24,
              bottom: 24,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow_rounded, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _compactSessionCard(BuildContext context, String title, String time, IconData icon, Color color) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _startMeditation(context, int.parse(time.split(' ')[0])),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(time, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _startMeditation(BuildContext context, int minutes) {
    final controller = Provider.of<MeditationController>(context, listen: false);
    controller.startSession(minutes);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: controller,
          child: const MeditationSessionScreen(),
        ),
      ),
    );
  }

  Widget _ambientGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}