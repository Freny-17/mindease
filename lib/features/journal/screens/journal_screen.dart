import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/journal_controller.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String mood = "🙂";

  // List of mindful journal prompts for MindEase
  final List<String> _prompts = [
    "What is one thing you are grateful for today?",
    "What made you smile today?",
    "What is causing you stress, and how can you let it go?",
    "Describe a moment of peace you had recently.",
    "What is something you are proud of yourself for?",
    "If you could give your past self advice today, what would it be?",
    "What is a small goal you want to achieve tomorrow?",
    "Write down three words that describe your current mood.",
  ];

  void openEditor({
    String? id,
    String? title,
    String? content,
    String? existingMood,
  }) {
    final controller = Provider.of<JournalController>(context, listen: false);

    titleController.text = title ?? "";
    contentController.text = content ?? "";
    mood = existingMood ?? "🙂";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top drag handle
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                id == null ? "New Entry" : "Edit Entry",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Inspiration Button
                          if (id == null) ...[
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                final random = Random();
                                final randomPrompt = _prompts[random.nextInt(_prompts.length)];
                                setModalState(() {
                                  titleController.text = "Reflection";
                                  contentController.text = "$randomPrompt\n\n";
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Inspire Me",
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Title Input
                      TextField(
                        controller: titleController,
                        style: theme.textTheme.titleMedium,
                        decoration: InputDecoration(
                          hintText: "Give it a title...",
                          filled: true,
                          fillColor: theme.colorScheme.primary.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Content Input
                      TextField(
                        controller: contentController,
                        minLines: 3,
                        maxLines: 6,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: "Write how you feel today...",
                          filled: true,
                          fillColor: theme.colorScheme.primary.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Mood Selector
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "How are you feeling?",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: ["🙂", "😌", "😐", "😔", "😣"].map((e) {
                            final isSelected = mood == e;
                            return GestureDetector(
                              onTap: () => setModalState(() => mood = e),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? Colors.transparent : theme.colorScheme.primary.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]
                                      : [],
                                ),
                                child: Text(e, style: TextStyle(fontSize: isSelected ? 32 : 28)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () async {
                            if (id == null) {
                              await controller.addJournal(
                                titleController.text.trim().isEmpty ? "Untitled" : titleController.text,
                                contentController.text,
                                mood,
                              );
                            } else {
                              await controller.updateJournal(id, titleController.text, contentController.text, mood);
                            }

                            titleController.clear();
                            contentController.clear();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          child: Text(
                            id == null ? "Save Entry" : "Update Entry",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<JournalController>(context);
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          elevation: 4,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.edit_rounded),
          label: const Text("Write Entry", style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          onPressed: () => openEditor(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Journal", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("A safe space for your thoughts", style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6))),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.journalsStream,
                builder: (context, snapshot) {
                  // ✅ Showing exactly what the error is on screen if it fails
                  if (snapshot.hasError) {
                    debugPrint("Stream Error: ${snapshot.error}");
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text("Firebase Error: \n${snapshot.error}", textAlign: TextAlign.center),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                  }

                  // 1. Get raw documents from Firebase
                  final rawDocs = snapshot.data?.docs ?? [];

                  // 2. ✅ GENIUS WORKAROUND: Local sorting logic
                  // This sorts the journals locally by 'createdAt' (newest first)
                  final journals = rawDocs.toList()..sort((a, b) {
                    final aData = a.data() as Map<String, dynamic>;
                    final bData = b.data() as Map<String, dynamic>;

                    final aTime = aData['createdAt'] as Timestamp?;
                    final bTime = bData['createdAt'] as Timestamp?;

                    if (aTime == null || bTime == null) return 0;
                    return bTime.compareTo(aTime); // Descending order
                  });

                  if (journals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book_rounded, size: 80, color: theme.colorScheme.primary.withOpacity(0.2)),
                          const SizedBox(height: 20),
                          Text("No entries yet", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          const SizedBox(height: 8),
                          Text("Tap below to write your first journal.", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      final data = journals[index];
                      final map = data.data() as Map<String, dynamic>;

                      // Safely parse date
                      DateTime entryDate = DateTime.now();
                      if (map['createdAt'] != null) {
                        try {
                          entryDate = (map['createdAt'] as Timestamp).toDate();
                        } catch (e) {
                          debugPrint("Error parsing date for doc ${data.id}: $e");
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          openEditor(
                            id: data.id,
                            title: map['title'] ?? "",
                            content: map['content'] ?? "",
                            existingMood: map['moodTag'] ?? "🙂",
                          );
                        },
                        child: JournalCard(
                          title: map['title'] ?? "Untitled",
                          content: map['content'] ?? "",
                          mood: map['moodTag'] ?? "🙂",
                          date: entryDate,
                          onDelete: () => controller.deleteJournal(data.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// COMPACT JOURNAL CARD WIDGET
// ==========================================
class JournalCard extends StatelessWidget {
  final String title;
  final String content;
  final String mood;
  final DateTime date;
  final VoidCallback onDelete;

  const JournalCard({
    super.key,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
    required this.onDelete,
  });

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateString = '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    final timeString = TimeOfDay.fromDateTime(dateTime).format(context);
    return '$dateString • $timeString';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 135,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: colors.primary.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), shape: BoxShape.circle),
                      child: Text(mood, style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Journal Entry", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: colors.onSurface)),
                          const SizedBox(height: 2),
                          Text(_formatDateTime(context, date), style: TextStyle(fontSize: 11, color: colors.onSurface.withOpacity(0.5), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
              )
            ],
          ),
          const Spacer(),
          if (title.isNotEmpty) ...[
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
          ],
          Text(
            content,
            maxLines: title.isNotEmpty ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.onSurface.withOpacity(0.8), height: 1.3, fontSize: 13),
          )
        ],
      ),
    );
  }
}