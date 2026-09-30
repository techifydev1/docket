import 'package:docket/features/user/user_response.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserResponse? _userResponse;
  UserProvider();
  UserResponse? get userResponse => _userResponse;

  void updateUser(UserResponse user) {
    _userResponse = user;
    notifyListeners();
  }
}
