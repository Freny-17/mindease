import 'package:flutter/material.dart';

// 🔥 Import your active games
import 'slow_catch_screen.dart';
import 'focus_bubbles_screen.dart';
import 'calm_memory_screen.dart';
import 'color_match_screen.dart';

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. Ambient Background Glows
          Positioned(
            top: -50,
            left: -50,
            child: _buildGlow(theme.colorScheme.primary.withValues(alpha: 0.1), 300),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlow(theme.colorScheme.secondary.withValues(alpha: 0.1), 300),
          ),

          // 2. Main Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Custom Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Mindful Play",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Small games to reset your focus.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. ✅ RESPONSIVE GRID
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  sliver: SliverGrid(
                    // Automatically adds columns based on the screen width!
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220, // Cards will not exceed 220px in width
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildGameCard(
                        context: context,
                        title: "Slow Catch",
                        subtitle: "Catch flowers",
                        icon: Icons.local_florist_rounded,
                        color: Colors.pink.shade300,
                        screen: const SlowCatchScreen(),
                      ),
                      _buildGameCard(
                        context: context,
                        title: "Focus Bubbles",
                        subtitle: "Pop & clear",
                        icon: Icons.bubble_chart_rounded,
                        color: Colors.lightBlue.shade300,
                        screen: const FocusBubblesScreen(),
                      ),
                      _buildGameCard(
                        context: context,
                        title: "Calm Memory",
                        subtitle: "Match pairs",
                        icon: Icons.grid_view_rounded,
                        color: Colors.deepPurple.shade300,
                        screen: const CalmMemoryScreen(),
                      ),
                      _buildGameCard(
                        context: context,
                        title: "Color Match",
                        subtitle: "Ink challenge",
                        icon: Icons.palette_rounded,
                        color: Colors.orange.shade300,
                        screen: const ColorMatchScreen(),
                      ),
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
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with a soft background glow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1, // Prevents overflow on very narrow devices
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1, // Prevents overflow on very narrow devices
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 100, spreadRadius: 50),
        ],
      ),
    );
  }
}