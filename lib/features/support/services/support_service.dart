import 'package:flutter/material.dart';

class SupportService {

  List<Map<String, dynamic>> getGuides() {
    return [

      {
        "title": "Anxiety Relief",
        "steps": [
          "Take a slow deep breath",
          "Relax your shoulders",
          "Focus on what you can see around you",
          "Remind yourself that this moment will pass"
        ]
      },

      {
        "title": "Stress Management",
        "steps": [
          "Pause and take a deep breath",
          "Step away from the stressful situation",
          "Move your body gently",
          "Focus on one small task at a time"
        ]
      },

      {
        "title": "Overthinking Control",
        "steps": [
          "Notice the thought without judging it",
          "Write the thought down",
          "Ask if the thought is realistic",
          "Let the thought go and refocus"
        ]
      },

      {
        "title": "Motivation Reset",
        "steps": [
          "Start with a very small task",
          "Celebrate completing that step",
          "Remove distractions around you",
          "Build momentum slowly"
        ]
      },

    ];
  }

  List<Map<String, String>> getRelaxationTips() {
    return [
      {
        "title": "Slow Deep Breathing",
        "description": "Take slow deep breaths to calm your nervous system."
      },
      {
        "title": "Take a Short Walk",
        "description": "Walking even for a few minutes helps clear your mind."
      },
      {
        "title": "Listen to Calm Sounds",
        "description": "Nature sounds can relax your mind quickly."
      },
      {
        "title": "Focus on the Present",
        "description": "Bring your attention to the moment instead of worries."
      },
    ];
  }

  List<Map<String, String>> getMentalHealthTips() {
    return [
      {
        "title": "Build Healthy Routines",
        "description": "Regular habits help maintain emotional stability."
      },
      {
        "title": "Stay Connected",
        "description": "Talking with friends or family improves mental wellbeing."
      },
      {
        "title": "Practice Gratitude",
        "description": "Reflect on positive moments each day."
      },
      {
        "title": "Take Breaks",
        "description": "Short breaks from work refresh your mind."
      },
    ];
  }
}