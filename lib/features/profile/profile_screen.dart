import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mindease/core/theme/theme_controller.dart';
import 'package:mindease/core/theme/theme_pack.dart';
import 'package:mindease/features/quotes/screens/favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final controller = Provider.of<ThemeController>(context);

    final username = user?.email?.split('@').first ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        // ✅ 1. LayoutBuilder detects screen size changes (Tablet/Phone/Rotation)
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isTablet = maxWidth > 600;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // ✅ 2. Dynamic horizontal padding for wider screens
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? maxWidth * 0.15 : 24,
                  vertical: 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. USER HEADER CARD
                  _buildUserHeader(theme, username, user?.email, isTablet),

                  const SizedBox(height: 35),

                  // 2. MY SANCTUARY
                  Text(
                    "My Sanctuary",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    theme,
                    title: "Favorite Quotes",
                    icon: Icons.favorite_rounded,
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  // 3. APPEARANCE (Responsive Grid)
                  Text(
                    "App Environment",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // ✅ 3. SliverGridDelegateWithMaxCrossAxisExtent for auto-column scaling
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    children: [
                      _themeCard(context, "Flowers", "assets/flowers.jpg", ThemePack.flowers, controller),
                      _themeCard(context, "Forest", "assets/forest.jpg", ThemePack.forest, controller),
                      _themeCard(context, "Butterfly", "assets/butterfly.jpg", ThemePack.butterfly, controller),
                      _themeCard(context, "Home", "assets/home.jpg", ThemePack.home, controller),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // 4. PREFERENCES & INFO
                  Text(
                    "Preferences & Info",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                    ),
                    child: SwitchListTile(
                      title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
                      secondary: Icon(Icons.dark_mode_rounded, color: theme.colorScheme.primary),
                      value: controller.isDarkMode,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) => controller.toggleDarkMode(value),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMenuTile(
                    theme,
                    title: "About the Developer",
                    icon: Icons.info_outline_rounded,
                    iconColor: theme.colorScheme.primary,
                    onTap: () => _showAboutDeveloperDialog(context, theme),
                  ),

                  const SizedBox(height: 40),

                  // 5. LOGOUT BUTTON
                  _buildLogoutButton(context, isTablet),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildUserHeader(ThemeData theme, String name, String? email, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isTablet ? 45 : 35,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            child: Icon(Icons.person_rounded, size: isTablet ? 50 : 40, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 26 : 20,
                )),
                const SizedBox(height: 4),
                Text(email ?? "No email linked",
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6)
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(ThemeData theme, {required String title, required IconData icon, required Color iconColor, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isTablet) {
    return Center(
      child: SizedBox(
        width: isTablet ? 320 : double.infinity,
        height: 55,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade400,
            side: BorderSide(color: Colors.red.shade100, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.logout_rounded),
          label: const Text("Sign Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: () => _showLogoutDialog(context),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sign Out?"),
        content: const Text("Are you sure you want to leave MindEase?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ✅ FULLY RESPONSIVE ABOUT DEVELOPER DIALOG
  void _showAboutDeveloperDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: theme.colorScheme.surface,
          child: ConstrainedBox(
            // ✅ Prevents dialog from becoming huge on tablets
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              // ✅ Prevents overflow on short landscape screens
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/mu-logo.png',
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.school_rounded, size: 40),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Freny Sorathiya',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Software Developer',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Specializing in end-to-end mobile application development and modern software architecture.\n\nMindEase was developed to bring accessible mental wellness to everyone through clean, user-centric design.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.email_outlined, size: 20),
                        label: const FittedBox(
                          // ✅ Ensures email never overflows button width
                          child: Text(
                            'frenysorathiya@gmail.com',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        onPressed: () async {
                          final Uri emailUri = Uri(scheme: 'mailto', path: 'frenysorathiya@gmail.com', query: 'subject=Regarding MindEase App');
                          if (await canLaunchUrl(emailUri)) await launchUrl(emailUri);
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _themeCard(BuildContext context, String title, String asset, ThemePack pack, ThemeController controller) {
    final isSelected = controller.currentPack == pack;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => controller.setThemePack(pack),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))] : [],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset(asset, fit: BoxFit.cover)),
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black87, Colors.transparent]))),
            if (isSelected) Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.colorScheme.primary, width: 3))),
            Positioned(bottom: 12, left: 14, child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5))),
            if (isSelected) Positioned(top: 10, right: 10, child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 24))),
          ],
        ),
      ),
    );
  }
}