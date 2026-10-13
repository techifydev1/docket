import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/onboarding/onboarding_controller.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

Future<void> logout(BuildContext context) async {
  context.read<FamilyProvider>().clear();
  context.read<UserProvider>().clear();
  context.read<DocumentsProvider>().clear();
  context.read<AddDocumentProvider>().reset();
  context.read<OnboardingController>().clear();
  await FirebaseAuth.instance.signOut();
}
