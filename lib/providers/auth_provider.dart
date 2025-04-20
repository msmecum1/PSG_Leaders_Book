import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psg_leaders_book/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<bool> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
