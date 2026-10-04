import 'package:docket/features/auth/screens/login_screen.dart';
import 'package:docket/features/family/screens/select_family_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasData) {
          return const SelectFamilyScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
