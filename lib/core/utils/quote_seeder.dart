import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteSeeder {

  static Future<void> seedQuotes() async {
    final firestore = FirebaseFirestore.instance;

    final quotes = [

      // Motivation
      // {"text": "Believe in yourself and all that you are.", "category": "Motivation"},
      {"text": "You are stronger than you think.", "category": "Motivation"},
      {"text": "Push yourself, no one else will.", "category": "Motivation"},
      {"text": "Small progress is still progress.", "category": "Motivation"},
      {"text": "Dream big. Start small. Act now.", "category": "Motivation"},
      {"text": "Success begins with self-belief.", "category": "Motivation"},
      {"text": "Your only limit is your mind.", "category": "Motivation"},
      {"text": "Discipline builds freedom.", "category": "Motivation"},
      {"text": "You can. You will.", "category": "Motivation"},
      {"text": "Make yourself proud.", "category": "Motivation"},

      // Calm
      {"text": "Calm mind brings inner strength.", "category": "Calm"},
      {"text": "Peace begins with a deep breath.", "category": "Calm"},
      {"text": "Stillness speaks louder than noise.", "category": "Calm"},
      {"text": "Let go and breathe.", "category": "Calm"},
      {"text": "Quiet the mind, and the soul will speak.", "category": "Calm"},
      {"text": "Slow down. Everything is unfolding.", "category": "Calm"},
      {"text": "You deserve moments of peace.", "category": "Calm"},
      {"text": "Calmness is power.", "category": "Calm"},
      {"text": "Exhale the stress.", "category": "Calm"},
      {"text": "Peace is within you.", "category": "Calm"},

      // Growth
      {"text": "Growth begins at the edge of comfort.", "category": "Growth"},
      {"text": "Every day is a chance to grow.", "category": "Growth"},
      {"text": "Mistakes are proof you are trying.", "category": "Growth"},
      {"text": "Be better than yesterday.", "category": "Growth"},
      {"text": "Growth requires patience.", "category": "Growth"},
      {"text": "Challenge creates change.", "category": "Growth"},
      {"text": "Step outside your comfort zone.", "category": "Growth"},
      {"text": "Progress, not perfection.", "category": "Growth"},
      {"text": "Learn. Grow. Repeat.", "category": "Growth"},
      {"text": "Every setback builds strength.", "category": "Growth"},

      // Self Love
      {"text": "You are enough.", "category": "Self Love"},
      {"text": "Be kind to yourself.", "category": "Self Love"},
      {"text": "Self-care is not selfish.", "category": "Self Love"},
      {"text": "Love yourself first.", "category": "Self Love"},
      {"text": "You matter.", "category": "Self Love"},
      {"text": "Honor your journey.", "category": "Self Love"},
      {"text": "Choose yourself daily.", "category": "Self Love"},
      {"text": "Your feelings are valid.", "category": "Self Love"},
      {"text": "Rest without guilt.", "category": "Self Love"},
      {"text": "You deserve happiness.", "category": "Self Love"},
    ];

    for (var quote in quotes) {
      await firestore.collection('quotes').add(quote);
    }

    print("Quotes Seeded Successfully");
  }
}
