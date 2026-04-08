import 'package:flutter/material.dart';

class RealityVsImagination extends StatelessWidget {
  final List<String> real;
  final List<String> imagined;

  const RealityVsImagination({
    super.key,
    required this.real,
    required this.imagined,
  });

  Widget item(String text, bool isReal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isReal ? Icons.check_circle : Icons.cancel,
            color: isReal ? Colors.green : Colors.purple,
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
                      color: Colors.green),
                ),
                const SizedBox(height: 10),
                ...real.map((e) => item(e, true)),
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
                      color: Colors.purple),
                ),
                const SizedBox(height: 10),
                ...imagined.map((e) => item(e, false)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}