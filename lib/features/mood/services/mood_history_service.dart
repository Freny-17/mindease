import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodHistoryService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// STREAM USER MOODS
  Stream<List<Map<String, dynamic>>> streamUserMoods() {

    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('moods')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        final data = doc.data();

        return {
          "id": doc.id,
          "moodType": data['moodType'],
          "timestamp": data['timestamp'],
        };

      }).toList();

    });
  }

  /// DELETE MOOD
  Future<void> deleteMood(String id) async {

    await _firestore
        .collection('moods')
        .doc(id)
        .delete();
  }
}