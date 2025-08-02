import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserProfile(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      _currentUser = await FirebaseService.getUserById(uid);
      notifyListeners();
    } catch (e) {
      print('Load user profile error: $e');
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await FirebaseService.signUp(
        email: email,
        password: password,
        username: username,
      );

      if (credential != null) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Kayıt olma işlemi başarısız oldu';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await FirebaseService.signIn(
        email: email,
        password: password,
      );

      if (credential != null) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Giriş işlemi başarısız oldu';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      if (_currentUser != null) {
        await FirebaseService.updateUserStatus(_currentUser!.id, false);
      }
      await FirebaseService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}