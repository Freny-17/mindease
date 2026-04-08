import 'package:flutter/services.dart';
import '../models/sleep_story.dart';

class SleepService {

  Future<List<SleepStory>> getStories() async {
    return [
      SleepStory(
        id: "forest",
        title: "Calm Forest Night",
        description: "A peaceful walk through a quiet forest.",
        text: await _loadStory("assets/stories/forest.txt"), // Back to normal!
      ),
      SleepStory(
        id: "rain",
        title: "Rain on a Wooden Cabin",
        description: "Relax inside a warm cabin during rainfall.",
        text: await _loadStory("assets/stories/rain.txt"),
      ),
      SleepStory(
        id: "lake",
        title: "Boat on a Quiet Lake",
        description: "Floating slowly across calm water.",
        text: await _loadStory("assets/stories/lake.txt"),
      ),
      SleepStory(
        id: "stars",
        title: "Sleeping Under the Stars",
        description: "Rest beneath a sky full of stars.",
        text: await _loadStory("assets/stories/stars.txt"),
      ),
      SleepStory(
        id: "snow",
        title: "Snowy Mountain Lodge",
        description: "A peaceful snowy mountain night.",
        text: await _loadStory("assets/stories/snow.txt"),
      ),
      SleepStory(
        id: "ocean",
        title: "Ocean Waves at Night",
        description: "Listen to calm ocean waves.",
        text: await _loadStory("assets/stories/ocean.txt"),
      ),
      SleepStory(
        id: "desert",
        title: "Peaceful Desert Night",
        description: "A calm desert under the stars.",
        text: await _loadStory("assets/stories/desert.txt"),
      ),
    ];
  }

  Future<String> _loadStory(String path) async {
    return await rootBundle.loadString(path);
  }
}