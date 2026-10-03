import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _loading = true;

  User? get user => _user;
  bool get isLoading => _loading;

  AuthStateProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _loading = false;
      notifyListeners();
    });
  }
}
