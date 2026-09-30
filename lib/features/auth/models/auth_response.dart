import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/user/user_response.dart';

class AuthResponse {
  final UserResponse user;
  final FamilyResponse family;

  const AuthResponse({required this.user, required this.family});

  factory AuthResponse.json(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserResponse.fromJson(json["user"]),
      family: FamilyResponse.fromJson(json["family"]),
    );
  }
}
