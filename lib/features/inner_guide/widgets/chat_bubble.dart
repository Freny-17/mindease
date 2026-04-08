import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

        constraints: const BoxConstraints(maxWidth: 260),

        decoration: BoxDecoration(

          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.18)
              : theme.colorScheme.surface,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.25),
          ),

        ),

        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.9,
          ),
        ),
      ),
    );
  }
}