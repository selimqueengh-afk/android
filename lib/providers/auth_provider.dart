import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await _loadUserProfile(userCredential.user!.uid);
      }
    } catch (e) {
      _setError('Giriş başarısız: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          username: username,
          email: email,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
        );
        
        await _firebaseService.createUser(user);
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      _setError('Kayıt başarısız: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Çıkış başarısız: ${e.toString()}');
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final user = await _firebaseService.getUser(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      _setError('Kullanıcı profili yüklenemedi: ${e.toString()}');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}