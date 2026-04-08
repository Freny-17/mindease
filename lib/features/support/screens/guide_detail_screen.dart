import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {

  final String title;
  final String content;

  const GuideDetailScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.7,
          ),
        ),
      ),
    );
  }
}