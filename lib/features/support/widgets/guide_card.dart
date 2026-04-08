import 'package:flutter/material.dart';

class GuideCard extends StatelessWidget {

  final String title;
  final VoidCallback onTap;

  const GuideCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.9),
              theme.colorScheme.primary.withOpacity(0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.35),
              blurRadius: 35,
              offset: const Offset(0, 18),
            )
          ],
        ),
        child: Row(
          children: [

            const Icon(Icons.menu_book, color: Colors.white),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16)
          ],
        ),
      ),
    );
  }
}