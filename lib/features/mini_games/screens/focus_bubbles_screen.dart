import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/focus_bubbles_controller.dart';

class FocusBubblesScreen extends StatelessWidget {
  const FocusBubblesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusBubblesController(),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatefulWidget {
  const _GameView();

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FocusBubblesController>();
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ SAFER SPAWNING
    if (controller.isPlaying && controller.bubbles.length < 10) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) controller.spawnBubble(isDark);
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Focus Bubbles", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        // Premium Background Gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [theme.colorScheme.surface, Colors.black]
                : [theme.colorScheme.primary.withValues(alpha: 0.05), theme.colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [

              // ==========================================
              // THE PLAYABLE BUBBLE AREA
              // ==========================================
              Positioned.fill(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: controller.bubbles.map((bubble) {
                    return Positioned(
                      left: (bubble.x * size.width).clamp(0.0, size.width - bubble.size),
                      top: bubble.y,
                      child: GestureDetector(
                        onTapDown: (_) => controller.popBubble(bubble.id),
                        child: AnimatedScale(
                          scale: bubble.isPopping ? 1.5 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutBack,
                          child: AnimatedOpacity(
                            opacity: bubble.isPopping ? 0 : 0.85,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              width: bubble.size,
                              height: bubble.size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    bubble.color.withValues(alpha: 0.4),
                                    bubble.color,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: bubble.color.withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    blurRadius: 5,
                                    spreadRadius: -2,
                                    offset: const Offset(-2, -2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ==========================================
              // TOP HUD
              // ==========================================
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatBadge(context, Icons.stars_rounded, 'Score', '${controller.score}'),
                        const SizedBox(height: 6),
                        Text(
                          " Best: ${controller.highScore}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        )
                      ],
                    ),
                    _buildStatBadge(
                      context,
                      Icons.timer_rounded,
                      'Time',
                      '00:${controller.timeLeft.toString().padLeft(2, '0')}',
                      isWarning: controller.timeLeft <= 5 && controller.isPlaying,
                    ),
                  ],
                ),
              ),

              // ==========================================
              // START SCREEN OVERLAY (Glassmorphism)
              // ==========================================
              if (!controller.isPlaying && !controller.isGameOver)
                _buildOverlayMenu(
                  context,
                  title: "Ready to Focus?",
                  subtitle: "Tap the bubbles as they appear to clear your mind and improve concentration.",
                  buttonText: "Start Session",
                  onPressed: () => controller.startGame(size.height),
                ),

              // ==========================================
              // GAME OVER OVERLAY (Glassmorphism)
              // ==========================================
              if (controller.isGameOver)
                _buildOverlayMenu(
                  context,
                  title: "Focus Restored",
                  subtitle: "Great job! You popped ${controller.score ~/ 10} distracting thoughts.", // Divide by 10 since each pop is 10 pts
                  buttonText: "Play Again",
                  onPressed: () => controller.startGame(size.height),
                  isGameOver: true,
                  score: controller.score,
                  highScore: controller.highScore,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, IconData icon, String label, String value, {bool isWarning = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isWarning
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.9)
            : theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWarning
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isWarning ? theme.colorScheme.error : theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayMenu(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String buttonText,
        required VoidCallback onPressed,
        bool isGameOver = false,
        int? score,
        int? highScore,
      }) {
    final theme = Theme.of(context);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: 5)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isGameOver) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(score! >= highScore! && score > 0 ? Icons.emoji_events_rounded : Icons.self_improvement_rounded, size: 48, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    score! >= highScore! && score > 0 ? "New High Score!" : title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text("Score: $score", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ] else ...[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onPressed,
                    child: Text(buttonText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}