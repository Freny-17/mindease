import 'package:flutter/material.dart';

class DailyQuoteCard extends StatelessWidget {
  final String? quote;

  const DailyQuoteCard({super.key, this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.15),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [

          // Decorative Quote Icon
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.format_quote,
              size: 120,
              color: theme.colorScheme.primary.withOpacity(0.08),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: theme.colorScheme.primary.withOpacity(0.15),
                ),
                child: Text(
                  "Daily Insight",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                quote ?? "Loading inspiration...",
                style: theme.textTheme.titleLarge?.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
