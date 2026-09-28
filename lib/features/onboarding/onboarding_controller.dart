import 'package:docket/features/auth/widgets/register_request.dart';
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
  }) {
    _requestData.fullName = name;
    _requestData.email = email;
    _requestData.password = password;
    _requestData.phone = phone;
    _requestData.biometricsEnabled = biometricsActive;
    notifyListeners();
  }
}
