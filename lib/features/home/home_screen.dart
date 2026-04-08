import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:mindease/features/mood/controllers/mood_controller.dart';
import 'package:mindease/features/quotes/controllers/quotes_controller.dart';
import 'package:mindease/features/quotes/screens/quotes_screen.dart';
import 'package:mindease/features/mini_games/screens/mini_games_screen.dart';
import 'package:mindease/features/meditation/screens/meditation_screen.dart';
import 'package:mindease/features/support/screens/support_screen.dart';
import 'package:mindease/features/sleep/screens/sleep_screen.dart';
import 'package:mindease/features/inner_guide/screens/inner_guide_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    if (hour < 20) return "Good Evening";
    return "Good Night";
  }

  String _getMoodText(String emoji) {
    switch (emoji) {
      case "🙂": return "Happy";
      case "😌": return "Calm";
      case "😐": return "Neutral";
      case "😔": return "Low";
      case "😣": return "Stressed";
      default: return "";
    }
  }

  void _handleNavigation(BuildContext context, String title) {
    switch (title) {
      case "Quotes":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotesScreen()));
        break;
      case "Meditation":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MeditationScreen()));
        break;
      case "Support":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()));
        break;
      case "Sleep":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepScreen()));
        break;
      case "Mini Games":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MiniGamesScreen()));
        break;
      case "Inner Guide":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InnerGuideScreen()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title coming soon")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodController = context.watch<MoodController>();
    final quotesController = context.watch<QuotesController>();
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.email?.split('@').first ?? "User";

    return Scaffold(
      body: SafeArea(
        // ✅ 1. Wrap the entire body in a ScrollView to prevent ALL overflow
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Bottom padding for nav bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER AREA
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, $username",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "How are you feeling today?",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // HORIZONTAL MOOD TRACKER
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ["🙂", "😌", "😐", "😔", "😣"].map((emoji) {
                    final isSelected = moodController.selectedMood == emoji;

                    return GestureDetector(
                      onTap: () => moodController.selectMood(emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected ? [] : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(emoji, style: const TextStyle(fontSize: 28)),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _getMoodText(emoji),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // DAILY INSIGHT CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Daily Insight",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        quotesController.getQuoteForMood(moodController.selectedMood) ?? "Loading inspiration...",
                        key: ValueKey(moodController.selectedMood),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ✅ 2. Use GridView.count instead of rigid rows to prevent card overflow
              GridView.count(
                shrinkWrap: true, // Allows GridView to sit inside the SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Disables nested scrolling
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05, // ✅ Magic number to make the boxes tall enough for the text
                children: [
                  _buildGridTile(context, "Inner Guide", Icons.psychology_rounded, isPrimary: true),
                  _buildGridTile(context, "Meditation", Icons.self_improvement_rounded),
                  _buildGridTile(context, "Sleep", Icons.bedtime_rounded),
                  _buildGridTile(context, "Mini Games", Icons.videogame_asset_rounded),
                  _buildGridTile(context, "Quotes", Icons.format_quote_rounded),
                  _buildGridTile(context, "Support", Icons.support_agent_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, IconData icon, {bool isPrimary = false}) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _handleNavigation(context, title),
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: isPrimary ? null : Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.all(12), // Reduced outer padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Hugs content tightly
          children: [
            Container(
              padding: const EdgeInsets.all(12), // Reduced inner padding
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withValues(alpha: 0.2) : theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : theme.colorScheme.primary,
                size: 28, // Reduced icon size slightly to make room for text
              ),
            ),
            const SizedBox(height: 8),
            // ✅ Flexible + FittedBox ensures the text will NEVER overflow its bounds
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}