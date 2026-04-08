import 'dart:async';
import 'package:flutter/material.dart';
import '../services/meditation_service.dart';

class MeditationController extends ChangeNotifier {

  final MeditationService _service = MeditationService();

  Timer? _timer;

  int totalSeconds = 0;
  int remainingSeconds = 0;

  bool isRunning = false;

  void startSession(int minutes) {

    totalSeconds = _service.getTotalSeconds(minutes);
    remainingSeconds = totalSeconds;

    isRunning = true;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        stopSession();
      }

    });

    notifyListeners();
  }

  void pauseSession() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resumeSession() {

    if (remainingSeconds <= 0) return;

    isRunning = true;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        stopSession();
      }

    });

    notifyListeners();
  }

  void stopSession() {
    _timer?.cancel();
    isRunning = false;
    remainingSeconds = 0;
    notifyListeners();
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel(); // VERY IMPORTANT
    super.dispose();
  }
}