import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/color_match_controller.dart';
import '../widgets/color_option_button.dart';

class ColorMatchScreen extends StatelessWidget {
  const ColorMatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorMatchController(),
      child: const _ColorMatchView(),
    );
  }
}

class _ColorMatchView extends StatefulWidget {
  const _ColorMatchView({Key? key}) : super(key: key);

  @override
  State<_ColorMatchView> createState() => _ColorMatchViewState();
}

class _ColorMatchViewState extends State<_ColorMatchView> {
  late ColorMatchController _controller;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ColorMatchController>();
    _controller.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    if (_controller.isGameOver && !_hasShownDialog) {
      _hasShownDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog();
      });
    } else if (!_controller.isGameOver) {
      _hasShownDialog = false;
    }
  }

  void _showGameOverDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            "Time's Up!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: ${_controller.score}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Best Streak: ${_controller.maxStreak}',
                style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
              ),
              if (_controller.score >= _controller.highScore && _controller.score > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'New High Score!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Back',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _controller.startGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Color Match', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Consumer<ColorMatchController>(
          builder: (context, controller, child) {
            return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      // Forces the content to be at least as tall as the screen
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        // ✅ mainAxisAlignment.spaceBetween handles the vertical spacing safely
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // ================================
                            // 1. TOP SECTION (Stats)
                            // ================================
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStatBadge(context, 'Score', '${controller.score}'),
                                    _buildStatBadge(
                                      context,
                                      'Time',
                                      '${controller.timeRemaining}s',
                                      isWarning: controller.timeRemaining <= 5 && controller.isPlaying,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'High Score: ${controller.highScore}',
                                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                                    ),
                                    Text(
                                      'Streak: ${controller.streak} 🔥',
                                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // ================================
                            // 2. MIDDLE SECTION (Game Word)
                            // ================================
                            if (!controller.isPlaying && !controller.isGameOver)
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: theme.colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                  ),
                                  onPressed: controller.startGame,
                                  child: const Text('Start 30s Challenge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  Text(
                                    'Tap the INK color, not the word!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  // The Target Word
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return ScaleTransition(scale: animation, child: child);
                                    },
                                    child: FittedBox( // Safe scaling for long words
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        controller.currentQuestion?.textWord ?? '',
                                        key: ValueKey<String>(controller.currentQuestion?.textWord ?? ''),
                                        style: TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: controller.currentQuestion?.inkColorValue ?? theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            // ================================
                            // 3. BOTTOM SECTION (Grid)
                            // ================================
                            Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 2.5,
                                  ),
                                  itemCount: controller.gameColors.length,
                                  itemBuilder: (context, index) {
                                    final colorName = controller.gameColors.keys.elementAt(index);
                                    final colorValue = controller.gameColors.values.elementAt(index);

                                    return ColorOptionButton(
                                      colorName: colorName,
                                      colorValue: colorValue,
                                      isEnabled: controller.isPlaying,
                                      onTap: () => controller.checkAnswer(colorName),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, String label, String value, {bool isWarning = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isWarning
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}