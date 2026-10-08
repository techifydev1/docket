import 'package:docket/core/theme/app_theme.dart';
import 'package:docket/features/auth/auth_gate.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/onboarding/onboarding_controller.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final crypto = CryptoService();
  await crypto.initSodium();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        Provider<CryptoService>.value(value: crypto),
        ChangeNotifierProvider(create: (_) => AddDocumentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: AuthGate(),
    );
  }
}
