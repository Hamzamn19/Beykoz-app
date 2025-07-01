import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading; // تأكد من وجود هذا السطر

  AuthService() {
    _isLoading = true;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Check if user is currently signed in
  bool get isSignedIn => _user != null;

  // Get current user email
  String? get userEmail => _user?.email;

  // Get current user display name
  String? get userDisplayName => _user?.displayName;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _isLoading = true; // <-- عند بدء تسجيل الدخول
      notifyListeners();
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false; // <-- عند الانتهاء
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false; // <-- عند الخطأ
      notifyListeners();
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true; // <-- عند بدء تسجيل الخروج
      notifyListeners();
      await _auth.signOut();
      _isLoading = false; // <-- عند الانتهاء
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}