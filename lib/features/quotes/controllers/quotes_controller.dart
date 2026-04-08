import 'dart:math'; // ✅ Added for Random seed logic
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuoteModel {
  final String text;
  final String category;

  QuoteModel({required this.text, required this.category});

  factory QuoteModel.fromMap(Map<String, dynamic> data) {
    return QuoteModel(
      text: data['text'] ?? '',
      category: data['category'] ?? 'General',
    );
  }
}

class QuotesController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QuoteModel> _allQuotes = [];
  List<QuoteModel> _filteredQuotes = [];
  Set<String> _favQuoteTexts = {};

  String _selectedCategory = "All";
  bool _isLoading = true;

  List<QuoteModel> get filteredQuotes => _filteredQuotes;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final set = _allQuotes.map((q) => q.category).toSet().toList();
    return ["All", ...set];
  }

  QuotesController() {
    fetchQuotes();
    _listenToFavorites();
  }

  // ✅ NEW: Logic to pick a specific index based on today's date
  int _getDailyIndex(int listLength) {
    if (listLength <= 0) return 0;
    final now = DateTime.now();
    // Creates a unique number for today (e.g., 20260329)
    final int dateSeed = now.year * 10000 + now.month * 100 + now.day;
    return Random(dateSeed).nextInt(listLength);
  }

  bool isFavorite(String text) => _favQuoteTexts.contains(text);

  Future<void> fetchQuotes() async {
    try {
      _isLoading = true;
      notifyListeners();
      final snapshot = await _firestore.collection('quotes').get();
      _allQuotes = snapshot.docs.map((doc) => QuoteModel.fromMap(doc.data())).toList();
      _filteredQuotes = _allQuotes;
    } catch (e) {
      debugPrint("Error fetching quotes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorite_quotes")
        .snapshots()
        .listen((snapshot) {
      _favQuoteTexts = snapshot.docs.map((doc) => doc.data()['text'] as String).toSet();
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final favRef = _firestore.collection("users").doc(user.uid).collection("favorite_quotes");

    try {
      final query = await favRef.where("text", isEqualTo: quote.text).get();
      if (query.docs.isEmpty) {
        await favRef.add({
          "text": quote.text,
          "category": quote.category,
          "timestamp": FieldValue.serverTimestamp(),
        });
      } else {
        for (var doc in query.docs) {
          await favRef.doc(doc.id).delete();
        }
      }
    } catch (e) {
      debugPrint("Toggle Operation Failed: $e");
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _filteredQuotes = category == "All"
        ? _allQuotes
        : _allQuotes.where((q) => q.category == category).toList();
    notifyListeners();
  }

  // ✅ IMPROVED: getQuoteForMood now changes daily
  String? getQuoteForMood(String? moodEmoji) {
    if (_allQuotes.isEmpty) return "Loading wisdom...";

    String targetCategory = "Motivation";
    switch (moodEmoji) {
      case "🙂": targetCategory = "Growth"; break;
      case "😌": targetCategory = "Calm"; break;
      case "😐": targetCategory = "Motivation"; break;
      case "😔": targetCategory = "Self Love"; break;
      case "😣": targetCategory = "Calm"; break;
      default:
      // If no mood is selected, pick one from the entire list using the daily seed
        return _allQuotes[_getDailyIndex(_allQuotes.length)].text;
    }

    final categoryQuotes = _allQuotes.where((q) => q.category == targetCategory).toList();

    if (categoryQuotes.isNotEmpty) {
      // Use the daily seed specifically for this category
      return categoryQuotes[_getDailyIndex(categoryQuotes.length)].text;
    }

    return _allQuotes[_getDailyIndex(_allQuotes.length)].text;
  }
}