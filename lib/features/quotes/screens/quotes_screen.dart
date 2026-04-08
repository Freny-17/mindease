import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/quotes_controller.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuotesController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("Daily Wisdom", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Categories
            _buildCategoryList(controller, theme),

            // Quotes Grid
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.filteredQuotes.length,
                itemBuilder: (context, index) {
                  final quote = controller.filteredQuotes[index];
                  final isFav = controller.isFavorite(quote.text); // ✅ Instant check

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote_rounded, color: theme.colorScheme.primary.withOpacity(0.2)),
                        Expanded(
                          child: Text(quote.text,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, height: 1.4)),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ WORKING TOGGLE BUTTON
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? Colors.redAccent : theme.colorScheme.primary,
                              ),
                              onPressed: () => controller.toggleFavorite(quote),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 20),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: quote.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Copied!"), duration: Duration(seconds: 1)));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(QuotesController controller, ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          final isSel = cat == controller.selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSel,
              onSelected: (_) => controller.selectCategory(cat),
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(color: isSel ? Colors.white : theme.colorScheme.primary),
            ),
          );
        },
      ),
    );
  }
}