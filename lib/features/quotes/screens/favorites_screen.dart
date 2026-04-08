import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. Ambient Background Glow (Consistent with MindEase theme)
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 2. Custom App Bar for better spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "My Favorites",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Favorites List
                Expanded(
                  child: user == null
                      ? const Center(child: Text("Please log in to see favorites"))
                      : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .collection("favorite_quotes")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 80,
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "No favorites yet",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Heart a quote to save it here!"),
                            ],
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75, // Keeps cards uniform
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          return _buildFavoriteCard(context, data, docs[index].id, theme);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> data, String docId, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: theme.colorScheme.primary.withValues(alpha: 0.2), size: 24),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              data["text"] ?? "",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          const Divider(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .collection("favorite_quotes")
                    .doc(docId)
                    .delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Removed from Favorites"), duration: Duration(seconds: 1)),
                );
              },
              child: const Icon(Icons.favorite, color: Colors.redAccent, size: 22),
            ),
          )
        ],
      ),
    );
  }
}