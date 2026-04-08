import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchUserMoods() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('moods')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>> getWeeklyInsights() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

    final snapshot = await _firestore
        .collection('moods')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp', isGreaterThan: oneWeekAgo)
        .get();

    final moods = snapshot.docs.map((e) => e.data()).toList();

    if (moods.isEmpty) {
      return {
        "total": 0,
        "mostFrequent": null,
      };
    }

    Map<String, int> countMap = {};

    for (var mood in moods) {
      final type = mood['moodType'];
      countMap[type] = (countMap[type] ?? 0) + 1;
    }

    final mostFrequent =
        countMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      "total": moods.length,
      "mostFrequent": mostFrequent,
    };
  }
}