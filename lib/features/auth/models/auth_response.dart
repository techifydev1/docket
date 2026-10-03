import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/user/user_response.dart';

class AuthResponse {
  final UserResponse user;
  final List<FamilyResponse> families;

  const AuthResponse({required this.user, required this.families});

  factory AuthResponse.json(Map<String, dynamic> json) {
    final families = (json["family"] as List<dynamic>? ?? const [])
        .map((item) => FamilyResponse.fromJson(item))
        .toList();
    return AuthResponse(
      user: UserResponse.fromJson(json["user"]),
      families: families,
    );
  }
}
