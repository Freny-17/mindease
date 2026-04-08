import 'package:flutter/material.dart';

class AIResponseCard extends StatelessWidget {

  final String title;
  final String text;
  final IconData icon;
  final Color color;

  const AIResponseCard({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(icon, color: color),

              const SizedBox(width: 8),

              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),

            ],
          ),

          const SizedBox(height: 10),

          Text(
            text,
            style: const TextStyle(
              height: 1.5,
              fontSize: 14,
            ),
          ),

        ],
      ),
    );
  }
}