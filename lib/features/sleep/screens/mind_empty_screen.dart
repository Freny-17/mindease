import 'dart:async';
import 'package:flutter/material.dart';

class MindEmptyScreen extends StatefulWidget {
  const MindEmptyScreen({super.key});

  @override
  State<MindEmptyScreen> createState() => _MindEmptyScreenState();
}

class _MindEmptyScreenState extends State<MindEmptyScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  String phase = "Inhale";
  int cycle = 1;
  final int totalCycles = 5;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _breathAnimation =
        Tween<double>(begin: 120, end: 200).animate(CurvedAnimation(
          parent: _breathController,
          curve: Curves.easeInOut,
        ));

    _startBreathingGuide();
  }

  void _startBreathingGuide() {

    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {

      if (!mounted) return;

      setState(() {

        if (phase == "Inhale") {
          phase = "Exhale";
        } else {
          phase = "Inhale";
          cycle++;
        }

        if (cycle > totalCycles) {
          timer.cancel();
          _showFinishDialog();
        }
      });
    });
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Great Job 🌙"),
        content: const Text(
          "Your mind is calmer now.\nTake this peaceful feeling into your sleep.",
        ),
        actions: [
          TextButton(
            child: const Text("Finish"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mind Empty Exercise"),
      ),

      body: Column(
        children: [

          const SizedBox(height: 40),

          Text(
            "Clear Your Mind",
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Follow the breathing rhythm",
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 60),

          /// Breathing Circle
          Center(
            child: AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, child) {

                return Container(
                  width: _breathAnimation.value,
                  height: _breathAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.6),
                        theme.colorScheme.primary.withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      phase,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 60),

          /// Progress
          Text(
            "Cycle $cycle / $totalCycles",
            style: theme.textTheme.titleMedium,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: cycle / totalCycles,
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Let thoughts pass like clouds.\nFocus only on breathing.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}