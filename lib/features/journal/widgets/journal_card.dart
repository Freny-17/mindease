import 'package:flutter/material.dart';

class JournalCard extends StatelessWidget {
  final String title;
  final String content;
  final String mood;
  final DateTime date;
  final VoidCallback onDelete;

  const JournalCard({
    super.key,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
    required this.onDelete,
  });

  // Helper method to format the date and time cleanly
  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateString = '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    final timeString = TimeOfDay.fromDateTime(dateTime).format(context);
    return '$dateString • $timeString';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      // Reduced height from 185 to 135 to make it a small, compact card
      height: 135,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16), // Tighter padding
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Mood Emoji (Scaled down)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        mood,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Date & Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Journal Entry",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14, // Scaled down
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateTime(context, date),
                            style: TextStyle(
                              fontSize: 11, // Scaled down
                              color: colors.onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Delete Button
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  size: 20, // Scaled down
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              )
            ],
          ),

          // Responsive spacer pushes the text to the bottom automatically
          const Spacer(),

          // Title
          if (title.isNotEmpty) ...[
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15, // Scaled down
              ),
            ),
            const SizedBox(height: 4),
          ],

          // Content
          Text(
            content,
            // If there's a title, show 1 line of content. If no title, show 2 lines.
            maxLines: title.isNotEmpty ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.8),
              height: 1.3,
              fontSize: 13, // Scaled down
            ),
          )
        ],
      ),
    );
  }
}