import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveMood(String emoji) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("moods").add({
      "userId": user.uid,
      "moodType": emoji,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
