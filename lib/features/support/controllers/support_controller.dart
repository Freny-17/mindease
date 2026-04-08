import 'package:flutter/material.dart';
import '../services/support_service.dart';

class SupportController extends ChangeNotifier {

  final SupportService _service = SupportService();

  List<Map<String, dynamic>> guides = [];
  List<Map<String, String>> relaxationTips = [];
  List<Map<String, String>> mentalHealthTips = [];

  SupportController() {
    loadSupportData();
  }

  void loadSupportData() {

    guides = _service.getGuides();
    relaxationTips = _service.getRelaxationTips();
    mentalHealthTips = _service.getMentalHealthTips();

    notifyListeners();
  }
}