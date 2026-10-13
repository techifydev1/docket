import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:docket/features/user/user_response.dart';

class RecoveryService {
  final DioClient client = DioClient();

  Future<UserResponse> uploadKeyBackup(String keyBackup) async {
    try {
      final response = await client.post<UserResponse>("/recovery/backup", {
        "keyBackup": keyBackup,
      }, decoder: (json) => UserResponse.fromJson(json));
      return response;
    } on ApiError {
      rethrow;
    }
  }

  Future<String> requestRecoveryCode() async {
    try {
      final response = await client.post<String>(
        "/recovery/request",
        null,
        decoder: (json) => json["message"],
      );
      return response;
    } on ApiError {
      rethrow;
    }
  }

  Future<String> confirmRecovery(String code) async {
    try {
      final response = await client.post<String>("/recovery/confirm", {
        "code": code,
      }, decoder: (json) => json["keyBackup"]);
      return response;
    } on ApiError {
      rethrow;
    }
  }
}
