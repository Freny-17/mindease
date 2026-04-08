import 'package:flutter/material.dart';

class AiTypingIndicator extends StatelessWidget {

  const AiTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 14,
            child: Icon(Icons.psychology, size: 16),
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text("Inner Guide is thinking..."),
          ),

        ],
      ),
    );
  }
}