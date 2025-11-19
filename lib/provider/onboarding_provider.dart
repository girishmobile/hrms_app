import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  int currentIndex = 0;

  void setPage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
