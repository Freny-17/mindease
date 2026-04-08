import 'package:flutter/material.dart';
import 'package:mindease/features/home/home_screen.dart';
import 'package:mindease/features/mood/screens/mood_history_screen.dart'; // ✅ changed
import 'package:mindease/features/journal/screens/journal_screen.dart';
import 'package:mindease/features/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MoodHistoryScreen(), // ✅ changed (was MoodScreen)
    JournalScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 0),
              _navItem(Icons.mood_rounded, 1),
              _navItem(Icons.menu_book_rounded, 2),
              _navItem(Icons.person_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isSelected ? 1.15 : 1.0,
          child: Icon(
            icon,
            size: 26,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium!.color,
          ),
        ),
      ),
    );
  }
}