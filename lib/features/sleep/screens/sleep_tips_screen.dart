import 'package:flutter/material.dart';

class SleepTipsScreen extends StatelessWidget {
  const SleepTipsScreen({super.key});

  final List<String> tips = const [
    "Avoid screens at least 30 minutes before sleep.",
    "Keep your bedroom cool and dark.",
    "Drink warm water or herbal tea before bed.",
    "Stretch your body gently to release tension.",
    "Try deep breathing to calm your mind.",
    "Maintain a consistent sleep schedule.",
    "Avoid heavy meals before bedtime.",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Tips"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Icon(
                  Icons.nightlight_round,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    tips[index],
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}