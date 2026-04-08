import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_model.dart';

class QuoteService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all quotes
  Future<List<QuoteModel>> fetchQuotes() async {
    final snapshot = await _firestore.collection('quotes').get();

    return snapshot.docs
        .map((doc) => QuoteModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Fetch categories
  Future<List<String>> fetchCategories() async {
    final snapshot = await _firestore.collection('quotes').get();

    final categories = snapshot.docs
        .map((doc) => doc['category'] as String)
        .toSet()
        .toList();

    return categories;
  }

  // Save favorite
  Future<void> saveFavorite(String userId, QuoteModel quote) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('userFavorites')
        .doc(quote.id)
        .set({
      'quoteId': quote.id,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove favorite
  Future<void> removeFavorite(String userId, String quoteId) async {
    await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('userFavorites')
        .doc(quoteId)
        .delete();
  }

  // Fetch user favorites
  Future<List<String>> fetchFavoriteIds(String userId) async {
    final snapshot = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('userFavorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
