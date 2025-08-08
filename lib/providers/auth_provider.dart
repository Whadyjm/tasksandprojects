import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  // aqui simulo un login sencillo
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = true;
    _userEmail = email;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}