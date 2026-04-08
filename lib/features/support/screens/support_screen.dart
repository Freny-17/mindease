import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/support_controller.dart';
import '../widgets/tip_card.dart';
import 'guide_steps_screen.dart';
import '../../meditation/screens/meditation_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<SupportController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Support & Guidance", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===============================
            // 1️⃣ I NEED SUPPORT RIGHT NOW (Hero Button)
            // ===============================
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MeditationScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "I need support right now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ===============================
            // 2️⃣ SELF HELP GUIDES (Responsive Grid)
            // ===============================
            Text(
              "Self Help Guides",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ✅ RESPONSIVE FIX: Auto-calculating grid for guides
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400, // Maximum width of a card before making a new column
                mainAxisExtent: 80, // Fixed height for guide cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.guides.length,
              itemBuilder: (context, index) {
                final guide = controller.guides[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GuideStepsScreen(
                          title: guide["title"],
                          steps: List<String>.from(guide["steps"]),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.colorScheme.surface,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            guide["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // ===============================
            // 3️⃣ RELAXATION TIPS (Responsive Grid)
            // ===============================
            Text(
              "Relaxation Tips",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 140, // Height for tip cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.relaxationTips.length,
              itemBuilder: (context, index) {
                final tip = controller.relaxationTips[index];
                return TipCard(
                  title: tip["title"]!,
                  description: tip["description"]!,
                );
              },
            ),

            const SizedBox(height: 40),

            // ===============================
            // 4️⃣ MENTAL HEALTH TIPS (Responsive Grid)
            // ===============================
            Text(
              "Mental Health Tips",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 140, // Height for tip cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.mentalHealthTips.length,
              itemBuilder: (context, index) {
                final tip = controller.mentalHealthTips[index];
                return TipCard(
                  title: tip["title"]!,
                  description: tip["description"]!,
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}