import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:docket/features/user/user_response.dart';

class UserService {
  final DioClient client = DioClient();

  Future<UserResponse> getUser() async {
    try {
      final response = await client.get<UserResponse, Map<String, dynamic>>(
        "/user",
        decoder: (userJson) => UserResponse.fromJson(userJson),
      );
      return response;
    } on ApiError {
      rethrow;
    }
  }
}
