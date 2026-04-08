import 'package:flutter/material.dart';
import '../services/mood_history_service.dart';

class MoodHistoryController extends ChangeNotifier {
  final MoodHistoryService _service = MoodHistoryService();

  List<Map<String, dynamic>> _moods = [];
  bool _isLoading = true;
  bool _showHistory = true;

  List<Map<String, dynamic>> get moods => _moods;
  bool get isLoading => _isLoading;
  bool get showHistory => _showHistory;

  void init() {
    _service.streamUserMoods().listen((data) {
      _moods = data;

      _moods.sort((a, b) {
        final t1 = a['timestamp'].toDate();
        final t2 = b['timestamp'].toDate();
        return t2.compareTo(t1);
      });

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> deleteMood(String id) async {
    await _service.deleteMood(id);
  }

  void toggleHistory() {
    _showHistory = !_showHistory;
    notifyListeners();
  }

  Map<int, String> get weeklyMoodMap {
    final Map<int, String> map = {};

    for (var mood in _moods) {
      final timestamp = mood['timestamp']?.toDate();
      if (timestamp == null) continue;

      final weekday = timestamp.weekday;

      if (!map.containsKey(weekday)) {
        map[weekday] = mood['moodType'];
      }
    }

    return map;
  }

  Map<String, int> get moodFrequency {
    Map<String, int> freq = {
      "🙂": 0,
      "😌": 0,
      "😐": 0,
      "😔": 0,
      "😣": 0,
    };

    for (var mood in _moods) {
      final type = mood['moodType'];

      if (freq.containsKey(type)) {
        freq[type] = freq[type]! + 1;
      }
    }

    return freq;
  }
}