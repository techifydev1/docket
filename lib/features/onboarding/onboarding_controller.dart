import 'package:docket/features/auth/models/register_request.dart';
import 'package:flutter/material.dart';

class OnboardingController with ChangeNotifier {
  final RegisterRequest _requestData = RegisterRequest();
  RegisterRequest get requestData => _requestData;

  void updateStep1({String vaultName = ""}) {
    _requestData.vaultName = vaultName;
    notifyListeners();
  }

  void updateStep2({
    required String name,
    required String email,
    required String phone,
    required String password,
    bool biometricsActive = false,
    required String publicKey,
    required String wrappedFamilyKey,
  }) {
    _requestData.fullName = name;
    _requestData.email = email;
    _requestData.password = password;
    _requestData.phone = phone;
    _requestData.isBiometricsEnabled = biometricsActive;
    _requestData.publicKey = publicKey;
    _requestData.wrappedFamilyKey = wrappedFamilyKey;
    notifyListeners();
  }
}
