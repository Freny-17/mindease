import 'package:flutter/material.dart';

class InnerGuideResponseWidget extends StatelessWidget {

  final String explanation;
  final String realityCheck;
  final String guidance;

  const InnerGuideResponseWidget({
    super.key,
    required this.explanation,
    required this.realityCheck,
    required this.guidance,
  });

  Widget buildCard(
      BuildContext context,
      String title,
      String text,
      IconData icon) {

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(icon, color: theme.colorScheme.primary),

              const SizedBox(width: 8),

              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),

          const SizedBox(height: 10),

          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        buildCard(
          context,
          "Understanding Your Situation",
          explanation,
          Icons.lightbulb_outline,
        ),

        buildCard(
          context,
          "Reality Check",
          realityCheck,
          Icons.verified_outlined,
        ),

        buildCard(
          context,
          "Calming Guidance",
          guidance,
          Icons.favorite_outline,
        ),

      ],
    );
  }
}