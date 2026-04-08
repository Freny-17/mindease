import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/meditation_controller.dart';

class MeditationSessionScreen extends StatefulWidget {
  const MeditationSessionScreen({super.key});

  @override
  State<MeditationSessionScreen> createState() => _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  bool isSoundOn = false;
  bool isPlaying = true;
  String currentSound = "sounds/rain.mp3";

  late AnimationController breathingController;

  final List<Map<String, dynamic>> sounds = [
    {"name": "Rain", "file": "sounds/rain.mp3", "icon": Icons.umbrella_rounded},
    {"name": "Ocean", "file": "sounds/ocean.mp3", "icon": Icons.waves_rounded},
    {"name": "Forest", "file": "sounds/forest.mp3", "icon": Icons.park_rounded},
    {"name": "Wind", "file": "sounds/wind.mp3", "icon": Icons.air_rounded},
  ];

  @override
  void initState() {
    super.initState();
    breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 19),
    )..repeat();
  }

  Future<void> playSound(String file) async {
    currentSound = file;
    await player.stop();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource(file));
  }

  String breathingPhase() {
    final cycle = breathingController.value * 19;
    if (cycle < 4) return "Inhale";
    if (cycle < 11) return "Hold";
    return "Exhale";
  }

  double breathingScale() {
    final cycle = breathingController.value * 19;
    if (cycle < 4) return 1.0 + (cycle / 4) * 0.25;
    if (cycle < 11) return 1.25;
    return 1.25 - ((cycle - 11) / 8) * 0.25;
  }

  @override
  void dispose() {
    breathingController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MeditationController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ 1. RESPONSIVE CALCULATION: Get screen size
    final size = MediaQuery.of(context).size;
    final double baseCircleSize = min(size.width, size.height) * 0.45; // 45% of screen

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 28),
          onPressed: () {
            controller.stopSession();
            player.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: breathingController,
        builder: (context, child) {
          final scale = breathingScale();
          final phase = breathingPhase();

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.1),
                radius: scale * 1.0,
                colors: [
                  theme.colorScheme.primary.withOpacity(isDark ? 0.08 : 0.15),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              // ✅ 2. BULLETPROOF LAYOUT: Prevents RenderFlex Overflows entirely
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight, // Fills screen at minimum
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "MIND OVER MATTER",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w300,
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),

                              const Spacer(flex: 2), // Flexible spacing instead of fixed height

                              // ✅ 3. DYNAMIC CIRCLE SIZING
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Soft Outer Pulse
                                    Container(
                                      width: (baseCircleSize * 1.3) * scale,
                                      height: (baseCircleSize * 1.3) * scale,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.03 : 0.06),
                                      ),
                                    ),
                                    // Inner Core Circle
                                    Container(
                                      width: baseCircleSize * scale,
                                      height: baseCircleSize * scale,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.35),
                                            blurRadius: isDark ? 25 : 40,
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            phase,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: baseCircleSize * 0.15, // Text scales with circle
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "${controller.remainingSeconds}s",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: baseCircleSize * 0.08, // Text scales with circle
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(flex: 3),

                              // Ambient Sound Selector
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: sounds.map((sound) {
                                      final isSelected = currentSound == sound["file"];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: ChoiceChip(
                                          label: Text(sound["name"]),
                                          avatar: Icon(
                                              sound["icon"],
                                              size: 16,
                                              color: isSelected ? Colors.white : theme.colorScheme.primary
                                          ),
                                          selected: isSelected,
                                          onSelected: (val) async {
                                            await playSound(sound["file"]);
                                            setState(() => isSoundOn = true);
                                          },
                                          selectedColor: theme.colorScheme.primary,
                                          backgroundColor: theme.colorScheme.surface,
                                          labelStyle: TextStyle(
                                            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.1)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30), // Slightly reduced

                              // Premium Floating Controls
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded),
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      onPressed: () async {
                                        setState(() => isSoundOn = !isSoundOn);
                                        isSoundOn ? await playSound(currentSound) : await player.stop();
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => isPlaying = !isPlaying);
                                        if (isPlaying) {
                                          controller.resumeSession();
                                          breathingController.repeat();
                                        } else {
                                          controller.pauseSession();
                                          breathingController.stop();
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: theme.colorScheme.primary,
                                        child: Icon(
                                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.stop_rounded),
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      onPressed: () async {
                                        controller.stopSession();
                                        await player.stop();
                                        if (mounted) Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          );
        },
      ),
    );
  }
}