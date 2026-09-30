import 'package:docket/features/family/family_response.dart';
import 'package:flutter/material.dart';

class FamilyProvider extends ChangeNotifier {
  FamilyResponse? _familyResponse;
  FamilyProvider();
  FamilyResponse? get familyResponse => _familyResponse;

  void updateFamily(FamilyResponse family) {
    _familyResponse = family;
    notifyListeners();
  }
}
