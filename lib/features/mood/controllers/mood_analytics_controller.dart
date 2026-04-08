import 'package:flutter/material.dart';
import '../services/mood_analytics_service.dart';

class MoodAnalyticsController extends ChangeNotifier {
  final MoodAnalyticsService _service = MoodAnalyticsService();

  List<Map<String, dynamic>> moods = [];
  Map<String, dynamic> insights = {};
  bool isLoading = true;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    moods = await _service.fetchUserMoods();
    insights = await _service.getWeeklyInsights();

    isLoading = false;
    notifyListeners();
  }
}