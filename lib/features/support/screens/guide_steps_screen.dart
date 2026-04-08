import 'package:flutter/material.dart';

class GuideStepsScreen extends StatefulWidget {
  final String title;
  final List<String> steps;

  const GuideStepsScreen({
    super.key,
    required this.title,
    required this.steps,
  });

  @override
  State<GuideStepsScreen> createState() => _GuideStepsScreenState();
}

class _GuideStepsScreenState extends State<GuideStepsScreen> {
  int currentStep = 0;

  void nextStep() {
    if (currentStep < widget.steps.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // ✅ 1. Wrap in SafeArea and Center to align nicely on all screens
      body: SafeArea(
        child: Center(
          // ✅ 2. SingleChildScrollView prevents vertical overflow on small phones
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              // ✅ 3. Max Width prevents the card from stretching too wide on tablets/web
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Step Counter Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Step ${currentStep + 1} of ${widget.steps.length}",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ✅ 4. AnimatedSwitcher makes the text transition smooth
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        widget.steps[currentStep],
                        key: ValueKey<int>(currentStep), // Crucial for AnimatedSwitcher to know the text changed
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.4, // Better line height for readability
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ✅ 5. Wrap prevents horizontal overflow if there are many dots
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        widget.steps.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: index == currentStep ? 24 : 8, // Active dot becomes a pill shape
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: index == currentStep
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                            ),
                            onPressed: currentStep == 0 ? null : previousStep,
                            child: const Text("Previous", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: currentStep == widget.steps.length - 1 ? null : nextStep,
                            child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}