import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Fetch journals for the current user
  Stream<QuerySnapshot>? get journalsStream {
    final user = _auth.currentUser;
    if (user == null) return null;

    // ✅ FIXED: Matches your screenshot structure
    // Looks in the root 'journals' collection and filters by the 'userId' field
    return _firestore
        .collection('journals')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 2. Add a new journal
  Future<void> addJournal(String title, String content, String mood) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // ✅ FIXED: Adds to the root 'journals' collection
      await _firestore.collection('journals').add({
        'userId': user.uid, // Explicitly linking the document to this user
        'title': title,
        'content': content,
        'moodTag': mood,
        'createdAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding journal: $e");
    }
  }

  // 3. Update an existing journal
  Future<void> updateJournal(String id, String title, String content, String mood) async {
    try {
      await _firestore.collection('journals').doc(id).update({
        'title': title,
        'content': content,
        'moodTag': mood,
        // Typically we don't change 'createdAt' when updating
      });
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating journal: $e");
    }
  }

  // 4. Delete a journal
  Future<void> deleteJournal(String id) async {
    try {
      await _firestore.collection('journals').doc(id).delete();
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting journal: $e");
    }
  }
}