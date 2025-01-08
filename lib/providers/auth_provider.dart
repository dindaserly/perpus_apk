import 'package:flutter/foundation.dart';
import '../models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  Member? _currentMember;
  Member? get currentMember => _currentMember;
  bool get isAuthenticated => _currentMember != null;

  Future<void> login(String email, String password) async {
    try {
      final member = await _authService.login(email, password);
      await setCurrentMember(member);
    } catch (e) {
      throw Exception('Email atau password salah');
    }
  }

  Future<void> setCurrentMember(Member member) async {
    _currentMember = member;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('member_data', jsonEncode(member.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _currentMember = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('member_data');
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final memberData = prefs.getString('member_data');
    if (memberData != null) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(memberData);
        _currentMember = Member.fromJson(jsonData);
        notifyListeners();
      } catch (e) {
        debugPrint('Error parsing member data: $e');
        await logout();
      }
    }
  }

  // Initialize default admin account
  Future<void> initializeApp() async {
    await _authService.initializeDefaultAdmin();
  }
}
