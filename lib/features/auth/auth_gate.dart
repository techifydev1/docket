import 'package:docket/features/auth/screens/login_screen.dart';
import 'package:docket/features/family/screens/select_family_screen.dart';
import 'package:docket/features/onboarding/screens/third_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final user = snapshot.data;
        if (user == null) return const LoginScreen();
        if (!user.emailVerified) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const .all(16),
                child: ThirdScreen(
                  onComplete: () => FirebaseAuth.instance.currentUser?.reload(),
                ),
              ),
            ),
          );
        }
        return const SelectFamilyScreen();
      },
    );
  }
}
