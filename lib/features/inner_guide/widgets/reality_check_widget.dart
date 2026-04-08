import 'package:flutter/material.dart';

class RealityCheckWidget extends StatelessWidget {

  const RealityCheckWidget({super.key});

  Widget item(String text, bool real) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          Icon(
            real ? Icons.check_circle : Icons.cancel,
            color: real ? Colors.green : Colors.purple,
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(child: Text(text)),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "What's Real",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 10),

                item("The exam has not happened yet.", true),
                item("You can start revising now.", true),
                item("You have solved difficult things before.", true),

              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "What's Imagined",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),

                const SizedBox(height: 10),

                item("I will definitely fail.", false),
                item("Everyone will judge me.", false),
                item("My future is ruined.", false),

              ],
            ),
          ),
        ),

      ],
    );
  }
}