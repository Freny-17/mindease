import 'package:flutter/material.dart';
import '../services/sleep_service.dart';
import '../models/sleep_story.dart';
import '../widgets/story_card.dart';
import 'sleep_story_player_screen.dart';

class SleepStoryListScreen extends StatefulWidget {
  const SleepStoryListScreen({super.key});

  @override
  State<SleepStoryListScreen> createState() => _SleepStoryListScreenState();
}

class _SleepStoryListScreenState extends State<SleepStoryListScreen> {

  final SleepService sleepService = SleepService();

  List<SleepStory> stories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  Future<void> loadStories() async {

    final loadedStories = await sleepService.getStories();

    setState(() {
      stories = loadedStories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Stories"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {

          final story = stories[index];

          return StoryCard(
            story: story,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SleepStoryPlayerScreen(story: story),
                ),
              );
            },
          );
        },
      ),
    );
  }
}