import 'package:flutter/material.dart';
import '../services/mood_service.dart';

class MoodController extends ChangeNotifier {

  final MoodService _moodService = MoodService();

  String? _selectedMood;
  String? get selectedMood => _selectedMood;

  Future<void> selectMood(String emoji) async {
    _selectedMood = emoji;
    notifyListeners();

    await _moodService.saveMood(emoji);
  }
}
