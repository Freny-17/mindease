import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/inner_guide_service.dart';

class InnerGuideController extends ChangeNotifier {
  final InnerGuideService _service = InnerGuideService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, String>> messages = [];
  bool isLoading = false;

  // Detects the tone to provide a hint to the AI service
  String _detectEmotion(String text) {
    text = text.toLowerCase();
    if (text.contains("stress") || text.contains("anxious") || text.contains("pressure")) return "stress";
    if (text.contains("sad") || text.contains("depressed") || text.contains("lonely")) return "sad";
    if (text.contains("angry") || text.contains("frustrated")) return "anger";
    return "normal";
  }

  Future<void> sendMessage(String text) async {
    final user = _auth.currentUser;
    if (user == null || text.isEmpty) return;

    // 1. Update UI with User Message & Start Loading
    messages.add({"role": "user", "content": text});
    isLoading = true;
    notifyListeners();

    try {
      final emotion = _detectEmotion(text);
      String promptPrefix = "";
      if (emotion != "normal") promptPrefix = "Context: The user feels $emotion. ";

      // 2. Fetch AI Response
      final response = await _service.getResponse(promptPrefix + text);

      // 3. Add AI Response to list
      messages.add({"role": "assistant", "content": response});

      // 4. Save to Firestore (Background task)
      _saveToFirestore(user.uid, text, response, emotion);

    } catch (e) {
      messages.add({
        "role": "assistant",
        "content": "Logical Explanation: I'm having trouble connecting. Reality Check: Technology sometimes dips. Calm Guidance: Please try again in a moment."
      });
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _saveToFirestore(String uid, String query, String response, String emotion) {
    _firestore.collection("users").doc(uid).collection("inner_guide_chats").add({
      "user_query": query,
      "ai_response": response,
      "emotion": emotion,
      "timestamp": FieldValue.serverTimestamp(),
    }).catchError((e) => debugPrint("Firestore Error: $e"));
  }

  void clearChat() {
    messages.clear();
    notifyListeners();
  }
}