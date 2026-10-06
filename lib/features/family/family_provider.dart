import 'package:docket/features/family/family_response.dart';
import 'package:flutter/material.dart';

class FamilyProvider extends ChangeNotifier {
  List<FamilyResponse> _families = const [];
  FamilyResponse? _selectedFamily;
  FamilyProvider();
  List<FamilyResponse> get families => _families;
  FamilyResponse? get selectedFamily => _selectedFamily;

  void updateFamilies(List<FamilyResponse> families) {
    _families = families;
    _selectedFamily = families.isEmpty ? null : families.first;
    notifyListeners();
  }

  void addFamily(FamilyResponse family) {
    _families = [..._families, family];
    _selectedFamily = family;
    notifyListeners();
  }

  void updateFamily(FamilyResponse family) {
    _selectedFamily = family;
    notifyListeners();
  }
}
