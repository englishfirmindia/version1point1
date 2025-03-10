import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;
  AppUser? _user;

  AuthProvider(this._authService, this._firestoreService);

  AppUser? get user => _user;

  Future<bool> login(String email, String password) async {
    final firebaseUser = await _authService.signInWithEmailAndPassword(email, password);
    if (firebaseUser != null) {
      _user = await _firestoreService.getUser(firebaseUser.uid);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    final firebaseUser = await _authService.signUpWithEmailAndPassword(email, password);
    if (firebaseUser != null) {
      await _firestoreService.saveUserData(firebaseUser.uid, name, email);
      _user = AppUser(uid: firebaseUser.uid, name: name, email: email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}