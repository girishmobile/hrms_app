import 'package:flutter/cupertino.dart';

class LoginProvider with ChangeNotifier {
  final tetEmail = TextEditingController();
  final tetPassword = TextEditingController();
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    resetState();
  }

  void resetState() {
    tetEmail.clear();
    tetPassword.clear();
    _obscurePassword = true;

    notifyListeners();
  }
}
