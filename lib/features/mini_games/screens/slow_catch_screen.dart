import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/slow_catch_controller.dart';
import '../widgets/falling_flower.dart';
import '../widgets/flower_basket.dart';

class SlowCatchScreen extends StatefulWidget {
  const SlowCatchScreen({Key? key}) : super(key: key);

  @override
  State<SlowCatchScreen> createState() => _SlowCatchScreenState();
}

class _SlowCatchScreenState extends State<SlowCatchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _engine;
  late SlowCatchController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = SlowCatchController();

    // The Engine runs continuously and tells our controller to update the frame
    _engine = AnimationController(vsync: this, duration: const Duration(days: 999));
    _engine.addListener(() {
      _gameController.updateFrame(_engine.lastElapsedDuration ?? Duration.zero);
    });

    _engine.forward();
  }

  @override
  void dispose() {
    _gameController.finishSession(); // Save score to Firebase before leaving
    _engine.dispose();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        extendBodyBehindAppBar: true,

        // --- TOP BAR ---
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
              'Mindful Catch',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w300, letterSpacing: 2.0)
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, size: 28, color: theme.colorScheme.onSurface),
            onPressed: () {
              _gameController.finishSession();
              Navigator.of(context).pop();
            },
          ),
        ),

        body: Consumer<SlowCatchController>(
          builder: (context, controller, _) {
            final size = MediaQuery.of(context).size;

            return Stack(
              children: [
                // ==========================================
                // LAYER 1: AMBIENT BACKGROUND
                // ==========================================
                // The gradient shifts slightly as you move the basket
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0, -0.5 + (controller.basketX * 0.1)),
                        radius: 1.5,
                        colors: [
                          theme.colorScheme.primaryContainer.withOpacity(0.4),
                          theme.colorScheme.surface
                        ],
                      ),
                    ),
                  ),
                ),

                // ==========================================
                // LAYER 2: LARGE SCORE WATERMARK
                // ==========================================
                Positioned(
                  top: size.height * 0.18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${controller.score}',
                      style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 140,
                          fontWeight: FontWeight.w100,
                          color: theme.colorScheme.onSurface.withOpacity(0.03)
                      ),
                    ),
                  ),
                ),

                // ==========================================
                // LAYER 3: GAMEPLAY AREA (Gestures, Flowers, Basket)
                // ==========================================
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      controller.setTargetBasketPosition(details.delta.dx, size.width);
                    },
                    child: Stack(
                      children: [
                        // A: Render Particles First (so they are behind flowers)
                        ...controller.activeParticles.map((particle) {
                          double opacity = (particle.life / particle.maxLife).clamp(0.0, 1.0);
                          return Positioned(
                            left: particle.x * size.width,
                            top: particle.y * size.height,
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                width: 6, height: 6,
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(color: theme.colorScheme.primary, blurRadius: 8)
                                    ]
                                ),
                              ),
                            ),
                          );
                        }),

                        // B: Render Falling Flowers
                        ...controller.activeFlowers.map((flower) {
                          return FallingFlower(
                            key: ValueKey(flower.id),
                            flower: flower,
                            gameAreaWidth: size.width,
                            gameAreaHeight: size.height,
                          );
                        }),

                        // C: Render the Basket
                        FlowerBasket(
                          basketX: controller.basketX,
                          basketY: controller.basketY,
                          velocity: controller.basketVelocity,
                          gameAreaWidth: size.width,
                          gameAreaHeight: size.height,
                          widthRatio: controller.basketWidthRatio,
                        ),
                      ],
                    ),
                  ),
                ),

                // ==========================================
                // LAYER 4: PAUSE SCREEN BLUR
                // ==========================================
                if (controller.isPaused)
                  Positioned.fill(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: theme.colorScheme.surface.withOpacity(0.3),
                            child: Center(
                              child: Text(
                                'Breathe',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 4.0,
                                ),
                              ),
                            ),
                          )
                      )
                  ),

                // ==========================================
                // LAYER 5: BOTTOM BUTTON CONTROLS
                // ==========================================
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                              context,
                              controller.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                              controller.togglePause
                          ),
                          const SizedBox(width: 24),
                          _buildControlButton(
                              context,
                              Icons.refresh_rounded,
                              controller.reset
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- HELPER: ROUND BUTTON UI ---
  Widget _buildControlButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10)
              )
            ]
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.8), size: 28),
      ),
    );
  }
}