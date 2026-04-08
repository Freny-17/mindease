import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  Stream<QuerySnapshot> streamJournals() {
    return _firestore
        .collection('journals')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addJournal(
      String title,
      String content,
      String mood,
      ) async {

    await _firestore.collection('journals').add({
      'userId': userId,
      'title': title,
      'content': content,
      'moodTag': mood,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateJournal(
      String id,
      String title,
      String content,
      String mood,
      ) async {

    await _firestore.collection('journals').doc(id).update({
      'title': title,
      'content': content,
      'moodTag': mood,
    });
  }

  Future<void> deleteJournal(String id) async {
    await _firestore.collection('journals').doc(id).delete();
  }
}