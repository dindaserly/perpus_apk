import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check hardcoded credentials
    if (email.toLowerCase() == 'admin' && password == 'admin123') {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    throw Exception('Username atau password salah');
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
